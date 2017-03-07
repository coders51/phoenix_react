defmodule PhoenixReact.PageView do
  use PhoenixReact.Web, :view
  require Logger

  def render("index.html", opts) do
    props = %{}
    props =
      case opts[:current_user] do
        nil -> %{}
        current_user ->
          Map.put(props, :currentUser, %{
            id: current_user.id,
            email: current_user.email,
            first_name: current_user.first_name,
            last_name: current_user.last_name,
            avatarUrl: current_user.o51_avatar_url,
            profile_completeness: current_user.o51_profile_completeness,
            authToken: current_user.o51_authentication_token,
          })
      end

    result = PhoenixReact.ReactIo.json_call!(%{
      component: Application.app_dir(:phoenix_react, "priv/static/js/server.js"),
      props: props,
    })

    render "app.html", html: result["html"], props: props
  end
end
