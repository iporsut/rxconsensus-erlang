-module(rxconsensus).

-compile(export_all).

voter(OutputProcess) ->
    {S1,S2,S3} = now(),
    random:seed(S1,S2,S3),
    N = random:uniform(3),
    T = random:uniform(2),
    Vote = (T rem 2) =:= 0,
    receive
    after N ->
	    OutputProcess ! Vote
    end.


consensus(TrueVote, FalseVote, 1) ->
    receive
	true ->
        LastTrueVote = TrueVote + 1,
	    io:format("true]~n"),
        ConsensusResult = LastTrueVote > FalseVote,
        io:format("Consensus: [~p]~n",[ConsensusResult]);
	false ->
        LastFalseVote = FalseVote + 1,
	    io:format("false]~n"),
        ConsensusResult = TrueVote > LastFalseVote,
        io:format("Consensus: [~p]~n",[ConsensusResult])
    end;

consensus(TrueVote, FalseVote, WaitingVoter) ->
    receive
	true ->
	    io:format("true, "),
	    consensus(TrueVote+1, FalseVote, WaitingVoter - 1);
	false ->
	    io:format("false, "),
	    consensus(TrueVote, FalseVote+1, WaitingVoter - 1)
    end.

start_vote() ->
    io:format("Vote Result: ["),
    spawn(?MODULE, voter, [self()]),
    spawn(?MODULE, voter, [self()]),
    spawn(?MODULE, voter, [self()]),
    consensus(0, 0, 3).
