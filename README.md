# PhoenixReact

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Update js dependencies `nvm use` and then `npm install`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# Deploy

Use the script `deploy.sh`. It deploys only in production and is very simple so pay attention on error
that can be showed on console.

The list of commands is:

```shell
mix edeliver build release # or mix edeliver build release --skip-git-clean --skip-mix-clean
mix edeliver deploy release to production
mix edeliver restart production
mix edeliver migrate production
mix edeliver restart production
mix edeliver ping production
```
It 's important to remember that on doploy machine we need [react-stdio](https://github.com/mjackson/react-stdio) because we use it to render react components on server. I suggest to put it as **global dependency** and set the path in

The migration is now manually and should be automated now is set on deploy scripts, so pay attention.



## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
