module Test.Main where

import Prelude

import Data.Either (Either(..))
import Data.Newtype (wrap)
import Effect (Effect)
import Env as Env
import Erl.Test.EUnit (suite, test)
import Erl.Test.EUnit as EUnit
import Test.Assert (assertEqual)

main :: Effect Unit
main = do
  void $ EUnit.runTests do
    suite "Env" do
      test "`setEnv` -> `getEnv`" do
        Env.setEnv (wrap "applicationName") (wrap "stringKey") "stringValue"
        retrievedString <- Env.getEnv (wrap "applicationName") (wrap "stringKey")
        assertEqual { expected: Right "stringValue", actual: retrievedString }

        Env.setEnv (wrap "applicationName") (wrap "intKey") 42
        retrievedInt <- Env.getEnv (wrap "applicationName") (wrap "intKey")
        assertEqual { expected: Right 42, actual: retrievedInt }

        Env.setEnv (wrap "applicationName") (wrap "boolKey") true
        retrievedBool <- Env.getEnv (wrap "applicationName") (wrap "boolKey")
        assertEqual { expected: Right true, actual: retrievedBool }

        Env.setEnv (wrap "applicationName") (wrap "arrayKey") [ 1, 2, 3 ]
        retrievedArray <- Env.getEnv (wrap "applicationName") (wrap "arrayKey")
        assertEqual { expected: Right [ 1, 2, 3 ], actual: retrievedArray }

        Env.setEnv (wrap "applicationName") (wrap "objectKey") { foo: "bar" }
        retrievedObject <- Env.getEnv (wrap "applicationName") (wrap "objectKey")
        assertEqual { expected: Right { foo: "bar" }, actual: retrievedObject }
