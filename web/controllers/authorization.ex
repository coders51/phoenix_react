defmodule PhoenixReact.ControllerAuthorization do
  @moduledoc """
  Add authorization check to a controller.
  """
  defmacro __using__(_) do
    quote do
      plug :check_authorized

      defp check_authorized(%{assigns: %{authorized: true}} = conn, _) do
        conn
      end
      defp check_authorized(conn, _) do
        conn
        |> put_flash(:error, "Non sei autorizzato")
        |> redirect external: PhoenixReact.Router.Helpers.url(conn)
      end
    end
  end
end
