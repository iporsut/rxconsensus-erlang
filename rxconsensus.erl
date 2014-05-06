-module(rxconsensus).

-compile(export_all).

voter(OutputProcess) ->
    {S1,S2,S3} = now(),
    random:seed(S1,S2,S3),
    N = random:uniform(3) * 1000,
    T = random:uniform(2),
    Vote = (T rem 2) =:= 0,
    receive
    after N ->
            OutputProcess ! {Vote, self()}
    end.


consensus(VoteList) ->
    TrueVote = length([True || True <- VoteList, True =:= true]),
    FalseVote = length([False || False <- VoteList, False =:= false]),
    TrueVote > FalseVote.

start_vote() ->
    VoteList = rx:future([
        spawn(?MODULE, voter, [self()]),
        spawn(?MODULE, voter, [self()]),
        spawn(?MODULE, voter, [self()])
    ]),
    ConsensusResult = consensus(VoteList),
    io:format("Vote Result: ~p~n", [VoteList]),
    io:format("Consensus: [~p]~n", [ConsensusResult]).
