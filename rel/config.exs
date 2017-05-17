# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"k.vA>Y$ne[|v}HL!~?=PL`Cv}%HHx|q2w3asd_6Wp~2uLl67c~x4L0Y=urv0E23.YJW.wL%"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"6XC,;hBhg?Y0W}~.<mt=Jasdi}7_S^t$b5r]|9_a9tAm;19NgjDmZyvZs)b<wXZ1Q4E"
end

environment :staging do
  set include_erts: true
  set include_src: false
  set cookie: :"CsOja4f68ZhHcQ2hy6N9B8CQ+pw5wSd+vk123asdiZTd/JcuA30Iij33RCVywyTMGyCxWE"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :phoenix_react do
  set version: current_version(:phoenix_react)
  set vm_args: "rel/templates/vm.args.eex"
  set overlay_vars: [node_name: "phoenix_react_#{Mix.env()}"]
end

# release :"phoenix_react_#{Mix.env()}" do
#   set version: current_version(:phoenix_react)
# end
