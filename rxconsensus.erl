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
	    OutputProcess ! Vote
    end.


consensus(TrueVote, FalseVote, VoteList, 0) ->
    ConsensusResult = TrueVote > FalseVote,
    {VoteList, ConsensusResult};

consensus(TrueVote, FalseVote, VoteList, WaitingVoter) ->
    receive
	true ->
	    consensus(TrueVote+1, FalseVote,VoteList ++ [true], WaitingVoter - 1);
	false ->
	    consensus(TrueVote, FalseVote+1,VoteList ++ [false], WaitingVoter - 1)
    end.


start_vote() ->
    spawn(?MODULE, voter, [self()]),
    spawn(?MODULE, voter, [self()]),
    spawn(?MODULE, voter, [self()]),
    {VoteList, ConsensusResult} = consensus(0, 0, [], 3),
    io:format("Vote Result: ~p~n", [VoteList]),
    io:format("Consensus: [~p]~n", [ConsensusResult]).
