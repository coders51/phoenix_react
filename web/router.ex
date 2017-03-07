defmodule PhoenixReact.Router do
  use PhoenixReact.Web, :router

  if Mix.env == :prod do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

  alias PhoenixReact.Repo
  alias PhoenixReact.User

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixReact do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/auth", PhoenixReact do
    pipe_through :browser

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
    get "/logout", AuthController, :logout
  end

  defp assign_current_user(conn, _) do
    case get_session(conn, :o51_uid) do
      nil -> assign(conn, :current_user, nil)
      o51_uid -> case Repo.get_by(User, o51_uid: o51_uid) do
        nil -> assign(conn, :current_user, nil)
        user -> assign(conn, :current_user, user)
      end
    end
  end
end
