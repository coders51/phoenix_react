defmodule PhoenixReact.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string

      add :o51_username, :string
      add :o51_authentications, :map
      add :o51_authentication_token, :text
      add :o51_authentication_token_secret, :text
      add :o51_expires_at, :integer
      add :o51_refresh_token, :text
      add :o51_token_type, :string
      add :o51_profile, :map
      add :o51_profile_completeness, :float
      add :o51_province, :string
      add :o51_avatar_url, :string
      add :o51_uid, :integer
      add :o51_points, :integer
      add :first_name, :string
      add :last_name, :string
      add :is_admin, :boolean

      timestamps()
    end

    create unique_index(:users, [:email, :o51_uid])

  end
end
