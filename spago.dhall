{ name = "purescript-erl-env"
, dependencies = [ "effect", "prelude", "simple-json", "simple-json-generics" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, backend = "purerl"
}
