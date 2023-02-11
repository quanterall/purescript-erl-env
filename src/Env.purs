module Env
  ( getEnv
  , GetEnvError(..)
  ) where

import Prelude

import Control.Monad.Except (ExceptT(..), except, runExceptT)
import Data.Bifunctor (lmap)
import Data.Either (Either, note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Erl.Atom (Atom)
import Foreign (Foreign, MultipleErrors)
import Simple.JSON (class ReadForeign)
import Simple.JSON as Json

data GetEnvError
  = GetEnvNoValue { application :: Atom, key :: Atom }
  | GetEnvUnableToDecode { application :: Atom, key :: Atom, errors :: MultipleErrors }

derive instance eqGetEnvError :: Eq GetEnvError
derive instance ordGetEnvError :: Ord GetEnvError
derive instance genericGetEnvError :: Generic GetEnvError _

instance showGetEnvError :: Show GetEnvError where
  show = genericShow

getEnv :: forall a. ReadForeign a => Atom -> Atom -> Effect (Either GetEnvError a)
getEnv application key = runExceptT do
  envValue <- key # get_env application # map (note (GetEnvNoValue { application, key })) # ExceptT
  envValue
    # Json.read
    # lmap (\errors -> GetEnvUnableToDecode { application, key, errors })
    # except

foreign import get_env :: Atom -> Atom -> Effect (Maybe Foreign)
