%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2022 7:31 PM
%%%-------------------------------------------------------------------
-module(topologyLine).
-author("13522").

%% API
-export([start/2, getRandomNeighbor/1]).
-export([goGossip/1, goPushSum/1]).
-export([spawnGossipNodes/1, spawnPushSumNodes/1]).
-export([gossipNodes/1, pushSumNodes/3, loopGetLineNeighbor/3]).

start(NumNodes, Algorithm) ->
  if
    Algorithm == "gossip" ->
      spawnGossipNodes(NumNodes),
      goGossip(NumNodes);
    Algorithm == "push-sum" ->
      spawnPushSumNodes(NumNodes),
      goPushSum(NumNodes)
  end.

getRandomNeighbor(Num) ->
  random:seed(erlang:phash2([node()]),
    erlang:monotonic_time(),
    erlang:unique_integer()),
  random:uniform(Num).

goGossip(NumNodes) ->
  %set timer
  TimeStart = erlang:monotonic_time()/10000,
  register(terminate, spawn(terminate, terminateEverything, [TimeStart])),

  RumorStarter = random:uniform(NumNodes),
  Name = list_to_atom("gossipNodes" ++ integer_to_list(RumorStarter)),
  Pid = whereis(Name),
  Pid ! {rumors, RumorStarter}.

goPushSum(NumNodes) ->
  %set timer
  TimeStart = erlang:monotonic_time()/10000,
  register(terminate, spawn(terminate, terminateEverything, [TimeStart])),

  RumorStarter = random:uniform(NumNodes),
  Name = list_to_atom("pushSumNodes" ++ integer_to_list(RumorStarter)),
  Pid = whereis(Name),
  Pid ! {rumors, 0, 1, RumorStarter}.

spawnGossipNodes(0) ->
  done;
spawnGossipNodes(NumNodes) when NumNodes > 0 ->
  Pid = spawn(topologyLine, gossipNodes, [0]),
  Name = list_to_atom("gossipNodes" ++ integer_to_list(NumNodes)),
  register(Name, Pid),

  %Notice! Here if we generated 30 nodes, and we want to retest the simulator and set the NumNodes to 100,
  %we have to stop the whole program and restart, simply because of the way nodes are generated.
  %Every node generated has a unique NodeName, and Pid is generated according to this name.

  spawnGossipNodes(NumNodes - 1).

spawnPushSumNodes(0) ->
  done;
spawnPushSumNodes(NumNodes) when NumNodes > 0 ->
  Pid = spawn(topologyLine, pushSumNodes, [NumNodes, 1, 0]),
  Name = list_to_atom("pushSumNodes" ++ integer_to_list(NumNodes)),
  register(Name, Pid),

  %Notice! Here if we generated 30 nodes, and we want to retest the simulator and set the NumNodes to 100,
  %we have to stop the whole program and restart, simply because of the way nodes are generated.
  %Every node generated has a unique NodeName, and Pid is generated according to this name.

  spawnPushSumNodes(NumNodes - 1).

gossipNodes(TimeOfReceiveRumors) ->
  %io:format("I'm Node ~p~n", [self()]),
  receive
    {rumors, Position} ->
      io:format("Rumors received!! I'm Node ~p~n", [Position]),

      if
        TimeOfReceiveRumors == 10 ->
          whereis(terminate) ! over;
        true ->
          done
      end,

      Rand = getRandomNeighbor(2),
      if
        Rand == 2 ->
          GoingPosition = Position + 1;
        true ->
          GoingPosition = Position - 1
      end,

      NeighborName = list_to_atom("gossipNodes" ++ integer_to_list(GoingPosition)),
      NeighborPid = whereis(NeighborName),
      io:format("sending to ~p~n", [GoingPosition]),
      NeighborPid ! {rumors, GoingPosition},
      gossipNodes(TimeOfReceiveRumors + 1)
  end.


loopGetLineNeighbor(Position, S, W) ->
  Rand = getRandomNeighbor(2),
  if
    Rand == 2 ->
      GoingPosition = Position + 1;
    true ->
      GoingPosition = Position - 1
  end,

  NeighborName = list_to_atom("pushSumNodes" ++ integer_to_list(GoingPosition)),
  NeighborPid = whereis(NeighborName),

  if
    is_pid(NeighborPid) ->
      io:format("sending to ~p~n", [GoingPosition]),
      NeighborPid ! {rumors, S / 2, W / 2, GoingPosition};
    true ->
      loopGetLineNeighbor(Position, S, W)
  end.

pushSumNodes(S, W, Rounds) ->
  if
    Rounds == 3 ->
      whereis(terminate) ! over;
    true ->
      done
  end,

  receive
    {rumors, S_send, W_send, Position} ->
      io:format("Rumors received!! I'm Node ~p~n", [Position]),
      Ratio = (S + S_send)/(W + W_send) - S / W,
      io:format("~p~n", [abs(Ratio)]),

      io:format("~p~n", [Rounds]),

      loopGetLineNeighbor(Position, S, W),

      if
        abs(Ratio) < 0.0000000001 ->
          pushSumNodes((S + S_send) / 2, (W + W_send) / 2, Rounds + 1);
        true ->
          pushSumNodes((S + S_send) / 2, (W + W_send) / 2, 0)
      end
  end.