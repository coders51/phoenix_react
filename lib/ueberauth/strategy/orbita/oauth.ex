defmodule Ueberauth.Strategy.Orbita.OAuth do
  @moduledoc """
  OAuth2 for Orbita.
  Add `client_id` and `client_secret` to your configuration:
  config :ueberauth, Ueberauth.Strategy.Orbita.OAuth,
    client_id: System.get_env("ORBITA_CLIENT_ID"),
    client_secret: System.get_env("ORBITA_CLIENT_SECRET")
  """
  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: Application.get_env(:ueberauth, Ueberauth.Strategy.Orbita.OAuth)[:site],
    authorize_url: Application.get_env(:ueberauth, Ueberauth.Strategy.Orbita.OAuth)[:authorize_url],
    token_url: Application.get_env(:ueberauth, Ueberauth.Strategy.Orbita.OAuth)[:token_url],
    token_method: :post
  ]

  @doc """
  Construct a client for requests to Facebook.
  This will be setup automatically for you in `Ueberauth.Strategy.Facebook`.
  These options are only useful for usage outside the normal callback phase
  of Ueberauth.
  """
  def client(opts \\ []) do
    config = Application.get_env(:ueberauth, Ueberauth.Strategy.Orbita.OAuth)

    opts =
      @defaults
      |> Keyword.merge(config)
      |> Keyword.merge(opts)

    OAuth2.Client.new(opts)
  end

  @doc """
  Provides the authorize url for the request phase of Ueberauth.
  No need to call this usually.
  """
  def authorize_url!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.get_token!(params)
  end

  def get(token, url, headers \\ [], opts \\ []) do
    [token: token]
    |> client
    |> put_param("client_secret", client().client_secret)
    |> OAuth2.Client.get(url, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
