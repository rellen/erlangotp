-module(counters_sup).

-behaviour(supervisor).

-export([start_link/0, start_child/1, start_test/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Name) ->
    supervisor:start_child(?SERVER, [Name]).

start_test() ->
    counter_store:init(),
    {ok, Pid} = supervisor:start_link({local, ?SERVER}, ?MODULE, []),
    unlink(Pid).

init([]) ->
    Counter = {counter, {counter, start_link, []}, permanent, 1000, worker, [counter]},
    Children = [Counter],
    RestartStrategy  = {simple_one_for_one, 10 , 10},
    {ok, {RestartStrategy, Children}}.