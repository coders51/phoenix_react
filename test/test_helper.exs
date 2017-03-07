{:ok, _} = Application.ensure_all_started(:ex_machina)
Faker.start

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(PhoenixReact.Repo, :manual)
