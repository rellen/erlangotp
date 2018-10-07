-module(counters_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    counter_store:init(),
    case counters_sup:start_link() of %starts root supervisor
        {ok, Pid} ->
            {ok,Pid};
        Other ->
            {error, Other}
    end.

stop(_State) -> 
    ok.