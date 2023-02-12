-module(env@foreign).

-export([get_env/2, set_env/3]).

get_env(Application, Key) ->
  fun() ->
     case application:get_env(Application, Key, undefined) of
       undefined -> {nothing};
       Value -> {just, Value}
     end
  end.

set_env(Application, Key, Value) ->
  fun() -> application:set_env(Application, Key, Value) end.
