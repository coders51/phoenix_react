defmodule PhoenixReact.AuthController do
  use PhoenixReact.Web, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  alias PhoenixReact.User
  alias PhoenixReact.Repo
  alias PhoenixReact.Router

  def request(conn, params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> configure_session(drop: true)
    |> delete_resp_cookie("remember_me")
    |> delete_resp_cookie("o51_uid")
    |> redirect external: "#{Application.get_env(:ueberauth, Ueberauth.Strategy.Orbita.OAuth)[:site]}/users/sign_out?return_to=#{Router.Helpers.url(conn)}"
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> configure_session(drop: true)
    |> send_resp(401, "Login Error")
    |> redirect external: Router.Helpers.url(conn)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = {Repo.get_by(User, o51_uid: auth.uid), auth, conn}
    |> save_user

    # perms = case user.is_admin do
    #   false -> %{default: [:read, :write]}
    #   true -> %{default: [:read, :write], admin: [:dashboard]}
    # end

    {:ok, token, _full_claims } = Guardian.encode_and_sign(user, :remember, perms: %{default: [:read, :write]})
    conn
      |> put_resp_cookie("remember_me", token, max_age: 60*60*24*365*10)
      |> put_resp_cookie("o51_uid", "#{auth.uid}", max_age: 60*60*24*365*10)
      |> redirect external: get_session(conn, :last_path) || Router.Helpers.url(conn)

  end


  defp save_user({nil, o51_user, _conn}) do #create

    IO.puts "create"

    user_change = %{
      first_name: o51_user.extra.raw_info.user["first_name"],
      last_name: o51_user.extra.raw_info.user["last_name"],
      email: o51_user.extra.raw_info.user["email"],
      o51_uid: o51_user.uid,
      o51_username: o51_user.extra.raw_info.user["username"],
      o51_avatar_url: o51_user.extra.raw_info.user["avatar_url"],
      o51_authentications: o51_user.extra.raw_info.user["authentications"],
      o51_province: o51_user.extra.raw_info.user["province"],
      o51_profile_completeness: o51_user.extra.raw_info.user["profile_completeness"],
      o51_authentication_token: o51_user.credentials.token,
      o51_refresh_token: o51_user.credentials.refresh_token,
      o51_token_type: o51_user.credentials.token_type,
      o51_expires_at: o51_user.credentials.expires_at,
      is_admin: o51_user.extra.raw_info.user["is_admin"],
    }
    user = User.changeset(%User{}, user_change)
    case Repo.insert user do
      {:ok, model}        ->
        model # created with success
      {:error, changeset} -> IO.puts "ERROR"# Something went wrong
    end
  end

  defp save_user({found, o51_user, _conn}) do #update
    IO.puts "update"

    change = User.changeset(found, %{
      first_name: o51_user.extra.raw_info.user["first_name"],
      last_name: o51_user.extra.raw_info.user["last_name"],
      email: o51_user.extra.raw_info.user["email"],
      o51_uid: o51_user.uid,
      o51_username: o51_user.extra.raw_info.user["username"],
      o51_avatar_url: o51_user.extra.raw_info.user["avatar_url"],
      o51_authentications: o51_user.extra.raw_info.user["authentications"],
      o51_province: o51_user.extra.raw_info.user["province"],
      o51_profile_completeness: o51_user.extra.raw_info.user["profile_completeness"],
      o51_authentication_token: o51_user.credentials.token,
      o51_refresh_token: o51_user.credentials.refresh_token,
      o51_token_type: o51_user.credentials.token_type,
      o51_expires_at: o51_user.credentials.expires_at,
    })

    case Repo.update change do
      {:ok, model}        -> model # created with success
      {:error, changeset} -> IO.puts "ERROR"# Something went wrong
    end

  end

end
