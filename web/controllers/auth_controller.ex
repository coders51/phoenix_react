defmodule PhoenixReact.AuthController do
  use PhoenixReact.Web, :controller

  alias PhoenixReact.User

  alias PhoenixReact.Repo

  alias PhoenixReact.Router

  require IEx

  def index(conn, _params) do

    case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", referer} ->
        last_path = referer
      nil ->
        last_path = Router.Helpers.url(conn) <> conn.request_path
    end

    conn
    |> put_session(:last_path, last_path)
    |> redirect external: authorize_url!()
  end

  def callback(conn, %{"code" => code}) do
    client = O51OAuth.get_token!(code: code)
    user = get_user!(client, conn)
    handle_redirect(conn, user, client.token)
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect external: "#{Application.get_env(:phoenix_react, O51OAuth)[:site]}/users/sign_out?return_to=#{Router.Helpers.url(conn)}"
  end

  defp authorize_url!(),   do: O51OAuth.authorize_url!(scope: "public accounts points")

  defp get_user!(client, conn) do
    o51_user = OAuth2.Client.get!(client, "/api/v1/users/me").body
    {Repo.get_by(User, o51_uid: o51_user["id"]), o51_user, client, conn}
    |> save_user
  end

  defp save_user({nil, o51_user, client, conn}) do

    IO.puts "create"

    user_change = %{
      first_name: o51_user["first_name"],
      last_name: o51_user["last_name"],
      email: o51_user["email"],
      o51_uid: o51_user["id"],
      o51_username: o51_user["username"],
      o51_avatar_url: o51_user["avatar_url"],
      o51_authentications: o51_user["authentications"],
      o51_province: o51_user["province"],
      o51_profile_completeness: o51_user["profile_completeness"],
      o51_authentication_token: client.token.access_token,
      o51_refresh_token: client.token.refresh_token,
      o51_token_type: client.token.token_type,
      o51_expires_at: client.token.expires_at,
      is_admin: o51_user["is_admin"],
    }
    user = User.changeset(%User{}, user_change)
    case Repo.insert user do
      {:ok, model}        ->
        model # created with success
      {:error, changeset} -> IO.puts "ERROR"# Something went wrong
    end
  end

  defp save_user({found, o51_user, client, conn}) do
    IO.puts "update"

    change = User.changeset(found, %{
      first_name: o51_user["first_name"],
      last_name: o51_user["last_name"],
      email: o51_user["email"],
      o51_uid: o51_user["id"],
      o51_username: o51_user["username"],
      o51_avatar_url: o51_user["avatar_url"],
      o51_province: o51_user["province"],
      o51_profile_completeness: o51_user["profile_completeness"],
      o51_authentications: o51_user["authentications"],
      o51_authentication_token: client.token.access_token,
      o51_refresh_token: client.token.refresh_token,
      o51_token_type: client.token.token_type,
      o51_expires_at: client.token.expires_at,
    })

    case Repo.update change do
      {:ok, model}        -> model # created with success
      {:error, changeset} -> IO.puts "ERROR"# Something went wrong
    end

  end

  defp handle_redirect(conn, user, token) do
    conn
    |> manage_session(user, token)
  end

  defp manage_session(conn, :ok, _token) do
    conn
    |> configure_session(drop: true)
    |> send_resp(401, "Login Error")
    |> redirect external: Router.Helpers.url(conn)
  end

  defp manage_session(conn, user, token) do
    conn
    |> put_session(:o51_uid, user.o51_uid)
    |> put_session(:access_token, token.access_token)
    |> redirect external: get_session(conn, :last_path) || Router.Helpers.url(conn)
  end

end
