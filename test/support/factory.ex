defmodule PhoenixReact.Factory do
  use ExMachina.Ecto, repo: PhoenixReact.Repo

  def user_factory do
    %PhoenixReact.User{
      first_name: Faker.Name.first_name,
      last_name: Faker.Name.last_name,
      email: Faker.Internet.email,
      o51_uid: 1,
      o51_username: Faker.Internet.user_name,
      o51_avatar_url: "avatar_url",
      o51_authentications: %{},
      o51_province: "province",
      o51_profile_completeness: 0.5,
      o51_authentication_token: "authentication_token",
      o51_refresh_token: "refresh_token",
      o51_token_type: "Bearer",
      o51_expires_at: 1,
      is_admin: false
    }
  end
end
