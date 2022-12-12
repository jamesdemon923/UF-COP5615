%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2022 7:31 PM
%%%-------------------------------------------------------------------
-module(topologyFull).
-author("13522").

%% API
-export([start/2, getRandomNeighbor/1]).
-export([goGossip/1, goPushSum/1]).
-export([spawnGossipNodes/1, spawnPushSumNodes/1]).
-export([gossipNodes/1, pushSumNodes/3]).

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
  Pid ! {rumors, NumNodes}.

goPushSum(NumNodes) ->
  %set timer
  TimeStart = erlang:monotonic_time()/10000,
  register(terminate, spawn(terminate, terminateEverything, [TimeStart])),

  RumorStarter = random:uniform(NumNodes),
  Name = list_to_atom("pushSumNodes" ++ integer_to_list(RumorStarter)),
  Pid = whereis(Name),
  Pid ! {rumors, 0, 1, NumNodes}.

spawnGossipNodes(0) ->
  done;
spawnGossipNodes(NumNodes) when NumNodes > 0 ->
  Pid = spawn(topologyFull, gossipNodes, [0]),
  Name = list_to_atom("gossipNodes" ++ integer_to_list(NumNodes)),
  register(Name, Pid),

  %Notice! Here if we generated 30 nodes, and we want to retest the simulator and set the NumNodes to 100,
  %we have to stop the whole program and restart, simply because of the way nodes are generated.
  %Every node generated has a unique NodeName, and Pid is generated according to this name.

  spawnGossipNodes(NumNodes - 1).

spawnPushSumNodes(0) ->
  done;
spawnPushSumNodes(NumNodes) when NumNodes > 0 ->
  Pid = spawn(topologyFull, pushSumNodes, [NumNodes, 1, 0]),
  Name = list_to_atom("pushSumNodes" ++ integer_to_list(NumNodes)),
  register(Name, Pid),

  %Notice! Here if we generated 30 nodes, and we want to retest the simulator and set the NumNodes to 100,
  %we have to stop the whole program and restart, simply because of the way nodes are generated.
  %Every node generated has a unique NodeName, and Pid is generated according to this name.

  spawnPushSumNodes(NumNodes - 1).

gossipNodes(TimeOfReceiveRumors) ->
  %io:format("I'm Node ~p~n", [self()]),
  receive
    {rumors, N} ->
      io:format("Rumors received!! I'm Node ~p~n", [self()]),

      if
        TimeOfReceiveRumors == 10 ->
          whereis(terminate) ! over;
        true ->
          done
      end,

      NeighborName = list_to_atom("gossipNodes" ++ integer_to_list(getRandomNeighbor(N))),
      NeighborPid = whereis(NeighborName),
      io:format("sending to ~p~n", [NeighborPid]),
      NeighborPid ! {rumors, N},
      gossipNodes(TimeOfReceiveRumors + 1)
  end.

pushSumNodes(S, W, Rounds) ->
  if
    Rounds == 3 ->
      whereis(terminate) ! over;
    true ->
      done
  end,

  receive
    {rumors, S_send, W_send, N} ->
      io:format("Rumors received!! I'm Node ~p~n", [self()]),
      Ratio = (S + S_send)/(W + W_send) - S / W,
      io:format("~p~n", [abs(Ratio)]),

      io:format("~p~n", [Rounds]),

      NeighborName = list_to_atom("pushSumNodes" ++ integer_to_list(getRandomNeighbor(N))),
      NeighborPid = whereis(NeighborName),
      %io:format("sending to ~p~n", [NeighborPid]),
      NeighborPid ! {rumors, S / 2, W / 2, N},
      if
        abs(Ratio) < 0.0000000001 ->
          pushSumNodes((S + S_send) / 2, (W + W_send) / 2, Rounds + 1);
        true ->
          pushSumNodes((S + S_send) / 2, (W + W_send) / 2, 0)
      end
  end.