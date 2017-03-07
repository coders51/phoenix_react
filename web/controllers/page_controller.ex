defmodule PhoenixReact.PageController do
  use PhoenixReact.Web, :controller

  alias PhoenixReact.User
  alias PhoenixReact.Repo

  require IEx

  def index(conn, _params) do
    %{current_user: current_user} = conn.assigns

    render conn, "index.html",
      current_user: current_user
  end


  defp renew_token(current_user, conn) do
    IO.puts "renew"
    {:ok, params} = %{
      "grant_type": "refresh_token",
      "client_id": Application.get_env(:phoenix_react, O51OAuth)[:client_id],
      "client_secret": Application.get_env(:phoenix_react, O51OAuth)[:client_secret],
      "refresh_token": current_user.o51_refresh_token
    } |> Poison.encode
    case HTTPoison.post "#{Application.get_env(:phoenix_react, O51OAuth)[:site]}/oauth/token", params, [{"Content-type", "application/json"}] do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode body do
          {:ok, data} ->
            change = User.changeset(current_user, %{o51_authentication_token: data["access_token"], o51_refresh_token: data["refresh_token"]})
            case Repo.update change do
              {:ok, model}        ->
                put_session(conn, :access_token, data["access_token"])
                assign(conn, :current_user, model)
              {:error, changeset} -> IO.puts "ERROR"# Something went wrong
            end
        end
    end
  end

end
