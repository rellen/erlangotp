-module(counters).

-export([create/1, delete/1, increment/1, increment/2,
            decrement/1, decrement/2, count/1, reset/1]).

create (Name) ->
    case counter_store:lookup(Name) of
        {ok, _Pid} -> 
            {error, counter_exists};
        {error, _} ->
            {ok, Pid} = counter:create(Name),
            {ok, Pid}
    end.

delete (Name) ->
    case counter_store:lookup(Name) of
        {ok, {Pid, _}} -> 
            counter:delete(Pid),
            counter_store:delete(Pid);
        {error, _} ->
            ok
    end.

increment (Name) ->
    increment_impl (Name, 1).

increment (Name, N) ->
    increment_impl (Name, N).

decrement (Name) ->
    increment_impl (Name, -1).

decrement (Name, N) ->
    increment_impl (Name, -1 * N).

count (Name) ->
    try
        {ok, Pid} = counter_store:lookup(Name),
        {ok, Count} = counter:count(Pid)
    catch
        _Class:_Exception ->
            {error, not_found}
    end.

reset (Name) ->
    case counter_store:lookup(Name) of
        {ok, {Pid, _}} -> 
            counter:reset(Pid);
        {error, _} ->
            ok
    end.

increment_impl(Name, N) ->
    try
        {ok, Pid} = counter_store:lookup(Name),
        counter:increment(Pid, N),
        ok
    catch
        _Class:_Exception ->
            {error, not_found}
    end.
