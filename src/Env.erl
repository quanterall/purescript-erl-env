-module(env@foreign).

-export([get_env/2]).

get_env(Application, Key) ->
  fun() ->
     case application:get_env(Application, Key, undefined) of
       undefined -> {nothing};
       Value -> {just, Value}
     end
  end.
