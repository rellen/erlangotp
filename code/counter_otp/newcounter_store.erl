-module(counter_store).
% adapted from Logan, Merritt & Carlsson, Erlang & OTP in Action, Manning, 2011

-export([init/0, insert/3, lookup/1, delete/1]).

-define(TABLE_ID, ?MODULE).

init() ->
    ets:new(?TABLE_ID,[public,named_table]),
    ok.

insert(Name, Pid, Count) ->
    ets:insert(?TABLE_ID, {Name, {Pid, Count}}).

lookup(Name) ->
    case ets:lookup(?TABLE_ID, Name) of
        [{Name, {Pid, Count}}] -> {ok, {Pid, Count}};
        [] -> {error, not_found}
    end.

delete(Pid) ->
    ets:match_delete(?TABLE_ID, {'_', {Pid, '_'}}).
