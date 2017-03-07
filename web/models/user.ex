defmodule PhoenixReact.User do
  use PhoenixReact.Web, :model

  schema "users" do
    field :email, :string
    field :o51_username, :string
    field :o51_authentications, :map
    field :o51_authentication_token, :string
    field :o51_authentication_token_secret, :string
    field :o51_expires_at, :integer
    field :o51_refresh_token, :string
    field :o51_token_type, :string
    field :o51_profile, :map
    field :o51_avatar_url, :string
    field :o51_profile_completeness, :float
    field :o51_uid, :integer
    field :o51_points, :integer
    field :o51_province, :string
    field :first_name, :string
    field :last_name, :string
    field :is_admin, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :email,
      :o51_username,
      :o51_authentications,
      :o51_authentication_token,
      :o51_authentication_token_secret,
      :o51_profile_completeness,
      :o51_refresh_token,
      :o51_token_type,
      :o51_expires_at,
      :o51_province,
      :o51_profile,
      :o51_avatar_url,
      :o51_uid,
      :o51_points,
      :first_name,
      :last_name,
      :is_admin,
     ])
    |> validate_required([
        :email,
        :o51_authentication_token,
        :o51_profile_completeness,
        :o51_refresh_token,
        :o51_token_type,
        :o51_expires_at,
        :o51_avatar_url,
        :o51_uid,
      ])
    |> unique_constraint(:email)
    |> unique_constraint(:o51_uid)
  end
end
