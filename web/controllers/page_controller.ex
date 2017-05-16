defmodule PhoenixReact.PageController do
  use PhoenixReact.Web, :controller

  alias PhoenixReact.User

  def index(conn, _params) do
    render conn, "index.html",
      current_user: Guardian.Plug.current_resource(conn)
  end

end
