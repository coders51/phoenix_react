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
              put_session(conn, Guardian.Keys.base_key(the_key), jwt)
            { :error, :token_expired } ->
              case conn.req_cookies["o51_uid"] do
                nil -> conn
                o51_uid -> renew_token(conn, o51_uid)
              end
            {:error, _} -> conn
          end
      end
    end
  end

  defp renew_token(conn, o51_uid) do
    case Repo.get_by(User, o51_uid: o51_uid) do
      nil -> conn
      user ->
        perms = case user.is_admin do
          false -> %{default: [:read, :write]}
          true -> %{default: [:read, :write], admin: [:dashboard]}
        end
        {:ok, token, full_claims } = Guardian.encode_and_sign(user, :remember, perms: perms)
        case Guardian.revoke! token, full_claims do
          :ok ->
            new_conn = Guardian.Plug.api_sign_in(conn, user)
            jwt = Guardian.Plug.current_token(new_conn)
            new_conn
              |> put_resp_cookie("remember_me", jwt)
          {:error, :could_not_revoke_token} -> conn
          {:error, reason} -> conn
        end
    end
  end
end