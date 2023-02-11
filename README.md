# purescript-erl-env

Library for fetching values set with, for example, `Config` in Elixir.

## Examples

With `Config` setting the following

```elixir
config :my_app, my_key: "my_value"
```

You can fetch the value with

```purescript
import Env as Env

fetchesValue :: Effect String
fetchesValue = Env.getEnv (atom "my_app") (atom "my_key")
```
