-module(rxconsensus_test).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

consensus_test() ->
    {Time, _ } = timer:tc(rxconsensus, start_vote, []),
    ?assert(Time =< 3100000).
