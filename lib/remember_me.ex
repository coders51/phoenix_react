defmodule PhoenixReact.Plug.RememberMe do
  import Plug.Conn
  import Guardian.Plug
  alias PhoenixReact.Repo
  alias PhoenixReact.User

  def init(opts \\ %{}), do: Enum.into(opts, %{})

  def call(conn, _) do
    current_user = current_resource(conn)
    if ( current_user == nil ) do
      case conn.req_cookies["remember_me"] do
        nil -> conn
        jwt ->
          case Guardian.decode_and_verify(jwt) do
            { :ok, claims } ->
              the_key = Map.get(claims, :key, :default)
              conn = case conn.req_cookies["remember_me"] do
                nil -> conn
                jwt -> conn |> put_resp_cookie("remember_me", jwt, max_age: 60*60*24*365*10)
              end

              conn = case conn.req_cookies["o51_uid"] do
                nil -> conn
                o51_uid ->
                  conn = Repo.get_by(User, o51_uid: o51_uid) |> renew_perms(conn, claims, jwt)
              end

              put_session(conn, Guardian.Keys.base_key(the_key), jwt)
            { :error, :token_expired } -> conn
            {:error, _} -> conn
          end
      end
    end
  end

  defp renew_perms(user, conn, claims, jwt) do
    perms = case user.is_admin do
      false -> %{default: [:read, :write]}
      true -> %{default: [:read, :write], admin: [:dashboard]}
    end
    case Guardian.revoke! jwt, claims do
      :ok ->
        claims = Guardian.Claims.app_claims |> Map.put("perms", perms) |> Guardian.Claims.ttl({60, :days})
        new_conn = conn |> Guardian.Plug.api_sign_in(user, :remember, claims)
        jwt = Guardian.Plug.current_token(new_conn)
        new_conn
          |> put_resp_cookie("o51_uid", "#{user.o51_uid}", max_age: 60*60*24*365*10)
          |> put_resp_cookie("remember_me", jwt, max_age: 60*60*24*365*10)
      {:error, :could_not_revoke_token} -> conn
      {:error, _reason} -> conn
    end
  end
  defp renew_perms(nil, conn, _claims, _jwt), do: conn
end
