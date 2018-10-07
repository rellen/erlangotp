-module(counter).

-export([create/0, start/0, delete/1, increment/1, increment/2, decrement/1, decrement/2, count/1, reset/1]).

create () ->
    spawn(?MODULE, start, []).

start () -> loop(0).

delete (Pid) ->
    Pid ! delete,
    ok.

increment (Pid) ->
    Pid ! {increment, 1},
    ok.

increment (Pid, N) ->
    Pid ! {increment, N}
    ok.

decrement (Pid) ->
    Pid ! {increment, -1},
    ok.

decrement (Pid, N) ->
    Pid ! {increment, N * -1}
    ok.

count (Pid) ->
    Pid ! {count, self()},
    receive
        {Pid,{count, Count}} ->
            Count;
        _ -> error
    end.

reset (Pid) ->
    Pid ! reset,
    ok.


loop(Count) ->
    receive
        delete ->
            ok;
        {increment, By} ->
            loop (Count+By);
        {count, Pid} ->
            Pid ! {self(),{count, Count}},
            loop(Count);
        reset ->
            loop(0);
        Unexpected ->
            io:format("Unexpected message: ~p~n", [Unexpected]),
            loop(Count)
    end.
