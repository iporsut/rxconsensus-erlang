-module(rx).
-export([future/1]).

future_receiver(0) ->
    ok;
future_receiver(LengthFuture) ->
    receive
        {Value, PID} ->
            put(PID, Value),
            future_receiver(LengthFuture - 1)
    end.

future(FutureList) ->
    future_receiver(length(FutureList)),
    lists:map(fun(PID) ->
                Value = get(PID),
                erase(PID),
                Value
        end,
        FutureList).
