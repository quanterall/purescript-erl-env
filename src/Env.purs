module Env
  ( getEnv
  , setEnv
  , GetEnvError(..)
  , ApplicationName(..)
  , EnvironmentKey(..)
  ) where

import Prelude

import Control.Monad.Except (ExceptT(..), except, runExceptT)
import Data.Bifunctor (lmap)
import Data.Either (Either, note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Erl.Atom (Atom, atom)
import Foreign (Foreign, MultipleErrors)
import Simple.JSON (class ReadForeign, class WriteForeign)
import Simple.JSON as Json

data GetEnvError
  = GetEnvNoValue { application :: Atom, key :: Atom }
  | GetEnvUnableToDecode { application :: Atom, key :: Atom, errors :: MultipleErrors }

derive instance eqGetEnvError :: Eq GetEnvError
derive instance ordGetEnvError :: Ord GetEnvError
derive instance genericGetEnvError :: Generic GetEnvError _

instance showGetEnvError :: Show GetEnvError where
  show = genericShow

newtype ApplicationName = ApplicationName String

derive instance eqApplicationName :: Eq ApplicationName
derive instance ordApplicationName :: Ord ApplicationName
derive instance genericApplicationName :: Generic ApplicationName _
derive instance newtypeApplicationName :: Newtype ApplicationName _

instance showApplicationName :: Show ApplicationName where
  show = genericShow

newtype EnvironmentKey = EnvironmentKey String

derive instance eqEnvironmentKey :: Eq EnvironmentKey
derive instance ordEnvironmentKey :: Ord EnvironmentKey
derive instance genericEnvironmentKey :: Generic EnvironmentKey _
derive instance newtypeEnvironmentKey :: Newtype EnvironmentKey _

instance showEnvironmentKey :: Show EnvironmentKey where
  show = genericShow

getEnv
  :: forall a. ReadForeign a => ApplicationName -> EnvironmentKey -> Effect (Either GetEnvError a)
getEnv applicationString keyString = runExceptT do
  let
    application = applicationString # unwrap # atom
    key = keyString # unwrap # atom
  envValue <- key # get_env application # map (note (GetEnvNoValue { application, key })) # ExceptT
  envValue
    # Json.read
    # lmap (\errors -> GetEnvUnableToDecode { application, key, errors })
    # except

setEnv :: forall a. WriteForeign a => ApplicationName -> EnvironmentKey -> a -> Effect Unit
setEnv applicationString keyString value = do
  let
    application = applicationString # unwrap # atom
    key = keyString # unwrap # atom
  value # Json.write # set_env application key

foreign import get_env :: Atom -> Atom -> Effect (Maybe Foreign)

foreign import set_env :: Atom -> Atom -> Foreign -> Effect Unit
