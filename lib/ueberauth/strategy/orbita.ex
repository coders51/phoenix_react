defmodule Ueberauth.Strategy.Orbita do
  @moduledoc """
  Provides an Ueberauth strategy for authenticating with Orbita.
  ### Setup
  Create an application in Orbita for you to use.
  Register a new application and get the `client_id` and `client_secret`.
  Include the provider in your configuration for Ueberauth
      config :ueberauth, Ueberauth,
        providers: [
          orbita: { Ueberauth.Strategy.Orbita, [] }
        ]
  Then include the configuration for orbita.
      config :ueberauth, Ueberauth.Strategy.Orbita.OAuth,
        client_id: System.get_env("ORBITA_CLIENT_ID"),
        client_secret: System.get_env("ORBITA_CLIENT_SECRET")
  If you haven't already, create a pipeline and setup routes for your callback handler
      pipeline :auth do
        Ueberauth.plug "/auth"
      end
      scope "/auth" do
        pipe_through [:browser, :auth]
        get "/:provider/callback", AuthController, :callback
      end
  Create an endpoint for the callback where you will handle the `Ueberauth.Auth` struct
      defmodule MyApp.AuthController do
        use MyApp.Web, :controller
        def callback_phase(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
          # do things with the failure
        end
        def callback_phase(%{ assigns: %{ ueberauth_auth: auth } } = conn, params) do
          # do things with the auth
        end
      end
  """
  use Ueberauth.Strategy, uid_field: :id,
                          default_scope: "public accounts points",
                          oauth2_module: Ueberauth.Strategy.Orbita.OAuth

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles the initial redirect to the orbita authentication page.
  To customize the scope (permissions) that are requested by orbita include them as part of your url:
      "/auth/orbita?scope=user,public_repo,gist"
  You can also include a `state` param that orbita will return to you.
  """
  def handle_request!(conn) do

    scopes = conn.params["scope"] || option(conn, :default_scope)
    opts = [redirect_uri: callback_url(conn), scope: scopes]

    opts =
      if conn.params["state"], do: Keyword.put(opts, :state, conn.params["state"]), else: opts

    module = option(conn, :oauth2_module)

    last_path = case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", referer} -> referer
      nil -> PhoenixReact.Router.Helpers.url(conn)
    end

    conn = conn
    |> put_session(:last_path, last_path)

    redirect!(conn, apply(module, :authorize_url!, [opts]))
  end

  @doc """
  Handles the callback from Orbita. When there is a failure from Orbita the failure is included in the
  `ueberauth_failure` struct. Otherwise the information returned from Orbita is returned in the `Ueberauth.Auth` struct.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    token_data = apply(module, :get_token!, [[code: code]])
    if token_data != nil && token_data.token != nil do
      fetch_user(conn, token_data.token)
    else
      set_errors!(conn, [error(token_data.other_params["error"], token_data.other_params["error_description"])])
    end
  end

  @doc false
  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc """
  Cleans up the private area of the connection used for passing the raw Orbita response around during the callback.
  """
  def handle_cleanup!(conn) do
    conn
    |> put_private(:orbita_user, nil)
    |> put_private(:orbita_token, nil)
  end

  @doc """
  Fetches the uid field from the Orbita response. This defaults to the option `uid_field` which in-turn defaults to `id`
  """
  def uid(conn) do
    user =
      conn
      |> option(:uid_field)
      |> to_string
    conn.private.orbita_user[user]
  end

  @doc """
  Includes the credentials from the Orbita response.
  """
  def credentials(conn) do
    token        = conn.private.orbita_token
    scope_string = (token.other_params["scope"] || "")
    scopes       = String.split(scope_string, ",")

    %Credentials{
      token: token.access_token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at,
      token_type: token.token_type,
      expires: !!token.expires_at,
      scopes: scopes
    }
  end

  @doc """
  Fetches the fields to populate the info section of the `Ueberauth.Auth` struct.
  """
  def info(conn) do
    user = conn.private.orbita_user

    %Info{
      nickname: user["username"],
      name: user["name"],
      email: user["email"],
      first_name: user["first_name"],
      last_name: user["last_name"]
    }

  end

  @doc """
  Stores the raw information (including the token) obtained from the Orbita callback.
  """
  def extra(conn) do
    %Extra {
      raw_info: %{
        token: conn.private.orbita_token,
        user: conn.private.orbita_user
      }
    }
  end

  defp fetch_user(conn, token) do
    conn = put_private(conn, :orbita_token, token)
    # Will be better with Elixir 1.3 with/else
    case Ueberauth.Strategy.Orbita.OAuth.get(token, "/api/v1/users/me") do
      {:ok, %OAuth2.Response{status_code: 401, body: _body}} ->
        set_errors!(conn, [error("token", "unauthorized")])
      {:ok, %OAuth2.Response{status_code: status_code, body: user}} when status_code in 200..399 ->
        put_private(conn, :orbita_user, user)
      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])
    end
  end

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end
end
