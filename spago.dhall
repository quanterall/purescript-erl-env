{ name = "purescript-erl-env"
, dependencies =
  [ "assert"
  , "bifunctors"
  , "effect"
  , "either"
  , "erl-atom"
  , "erl-test-eunit"
  , "erl-test-eunit-discovery"
  , "foldable-traversable"
  , "foreign"
  , "maybe"
  , "newtype"
  , "prelude"
  , "simple-json"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, backend = "purerl"
}
