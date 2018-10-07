-module(counter).

-behaviour(gen_server).

-export([start_link/1, create/1, delete/1, increment/2, count/1, reset/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {name, count}).

%% ===========================================================================
%% API
%% ===========================================================================

start_link(Name) ->
    gen_server:start_link(?MODULE, [Name], []).

create (Name) ->
    counters_sup:start_child(Name).

delete (Pid) ->
    gen_server:cast(Pid, delete).

increment (Pid, N) ->
    gen_server:cast(Pid, {increment, N}).

count (Pid) ->
    gen_server:call(Pid, count).

reset (Pid) ->
    gen_server:cast(Pid, reset).

%% ===========================================================================
%% Callbacks
%% ===========================================================================

init ([Name]) ->
    io:format("init on a counter called: ~p~n", [Name]),
    case counter_store:lookup(Name) of
        {ok, {_, Count}} -> 
            counter_store:insert(Name, self(), Count),
            {ok, #state{count=Count}};
        {error, _} ->
            counter_store:insert(Name, self(), 0),
            {ok, #state{name=Name, count=0}}
    end.    

handle_call (count, _From, State) ->
    Count = State#state.count,
    {reply, {ok, Count}, State}.

handle_cast (delete, State) ->
    {stop, normal, State};
handle_cast ({increment, N}, State) ->
    Count = State#state.count,
    Name = State#state.name,
    NewCount = Count + N,
    counter_store:insert(Name, self(), NewCount),
    {noreply, State#state{count = NewCount}};
handle_cast (reset, State) ->
    Name = State#state.name,
    counter_store:insert(Name, self(), 0),
    {noreply, State#state{count = 0}}.

handle_info(timeout,State) ->
    {stop, normal, State}.
 
terminate(normal, _State) ->
    counter_store:delete(self()),
    ok;
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extras) ->
    {ok, State}.

