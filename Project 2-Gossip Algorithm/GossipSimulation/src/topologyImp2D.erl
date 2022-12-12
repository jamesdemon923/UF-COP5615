%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2022 7:31 PM
%%%-------------------------------------------------------------------
-module(topologyImp2D).
-author("13522").

%% API
-export([start/2]).
-export([goGossip/1, goPushSum/1]).
-export([loop2DGossipNodes/3, loopGetExistingNeighbor2D/3, spawn2DGossipNodes/1, spawn2DPushSumNodes/1,gossipNodes2D/1]).
-export([getRandomNeighbor2D/1, loop2DPushSumNodes/4, loopGetExistingNeighborPushSum2D/5,pushSumNodes2D/4, getRandomNeighbor/1]).

start(NumNodes, Algorithm) ->
  if
    Algorithm == "gossip" ->
      spawn2DGossipNodes(NumNodes),
      goGossip(NumNodes);
    Algorithm == "push-sum" ->
      spawn2DPushSumNodes(NumNodes),
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

  R = trunc(math:sqrt(NumNodes)),
  RumorStarter_X = random:uniform(R),
  RumorStarter_Y = random:uniform(R),

  Name = list_to_atom("gossipNodes2D" ++ integer_to_list(RumorStarter_X) ++ "_" ++ integer_to_list(RumorStarter_Y)),
  Pid = whereis(Name),
  Pid ! {rumors, [RumorStarter_X, RumorStarter_Y], NumNodes}.

spawn2DGossipNodes(NumNodes) ->
  R = trunc(math:sqrt(NumNodes)),
  loop2DGossipNodes(R, R, R).

loop2DGossipNodes(0, 0, _) ->
  done;
loop2DGossipNodes(X, Y, R) ->
  Pid = spawn(topologyImp2D, gossipNodes2D, [0]),
  Name = list_to_atom("gossipNodes2D" ++ integer_to_list(X) ++ "_" ++ integer_to_list(Y)),
  register(Name, Pid),
  if
    X > 0 ->
      loop2DGossipNodes(X - 1, Y, R);
    Y > 0 ->
      loop2DGossipNodes(R, Y - 1, R);
    true ->
      done
  end.

gossipNodes2D(TimeOfReceiveRumors) ->
  %io:format("I'm Node ~p~n", [self()]),
  receive
    {rumors, [X, Y], N} ->
      io:format("Rumors received!! I'm Node ~p_~p~n", [X, Y]),

      if
        TimeOfReceiveRumors == 10 ->
          whereis(terminate) ! over;
        true ->
          done
      end,

      Rand = getRandomNeighbor(2),
      if
        Rand == 1 ->
          loopGetExistingNeighbor2D(X, Y, N);
        true ->
          R = trunc(math:sqrt(N)),
          GoingTo_X = random:uniform(R),
          GoingTo_Y = random:uniform(R),

          Name = list_to_atom("gossipNodes2D" ++ integer_to_list(GoingTo_X) ++ "_" ++ integer_to_list(GoingTo_Y)),
          Pid = whereis(Name),
          Pid ! {rumors, [GoingTo_X, GoingTo_Y], N},
          io:format("sending to ~p~p~n", [GoingTo_X, GoingTo_Y])
      end,

      gossipNodes2D(TimeOfReceiveRumors + 1)
  end.

loopGetExistingNeighbor2D(X, Y, N) ->
  NeighborCoordinate = getRandomNeighbor2D([X, Y]),
  Neighbor_X = lists:nth(1, NeighborCoordinate),
  Neighbor_Y = lists:nth(2, NeighborCoordinate),

  NeighborName = list_to_atom("gossipNodes2D" ++ integer_to_list(Neighbor_X) ++ "_" ++ integer_to_list(Neighbor_Y)),
  NeighborPid = whereis(NeighborName),

  if
    is_pid(NeighborPid) ->
      io:format("sending to ~p~n", [NeighborName]),
      NeighborPid ! {rumors, [Neighbor_X, Neighbor_Y], N},
      done;
    true ->
      loopGetExistingNeighbor2D(X, Y, N)
  end.

getRandomNeighbor2D([X, Y]) ->
  random:seed(erlang:phash2([node()]),
    erlang:monotonic_time(),
    erlang:unique_integer()),

  List = [[0, -1], [0, 1], [-1, 0], [1, 0], [-1 ,-1], [1, 1], [-1, 1], [1, -1]],
  NeighborCoordinate = lists:nth(random:uniform(8), List),
  Neighbor_X = lists:nth(1, NeighborCoordinate) + X,
  Neighbor_Y = lists:nth(2, NeighborCoordinate) + Y,
  [Neighbor_X, Neighbor_Y].

%%%%%%%%%
%PushSum%
%%%%%%%%%

goPushSum(NumNodes) ->
  %set timer
  TimeStart = erlang:monotonic_time()/10000,
  register(terminate, spawn(terminate, terminateEverything, [TimeStart])),

  R = trunc(math:sqrt(NumNodes)),
  RumorStarter_X = random:uniform(R),
  RumorStarter_Y = random:uniform(R),

  Name = list_to_atom("pushSumNodes2D" ++ integer_to_list(RumorStarter_X) ++ "_" ++ integer_to_list(RumorStarter_Y)),
  Pid = whereis(Name),
  Pid ! {rumors, 0, 1, [RumorStarter_X, RumorStarter_Y], NumNodes}.

spawn2DPushSumNodes(NumNodes) ->
  io:format("2DPushSumNodes!"),
  R = trunc(math:sqrt(NumNodes)),
  loop2DPushSumNodes(R, R, R, NumNodes).

loop2DPushSumNodes(0, 0, _, _) ->
  done;
loop2DPushSumNodes(X, Y, R, NumNodes) ->
  Pid = spawn(topologyImp2D, pushSumNodes2D, [NumNodes, 1, [X, Y], 0]),
  Name = list_to_atom("pushSumNodes2D" ++ integer_to_list(X) ++ "_" ++ integer_to_list(Y)),
  register(Name, Pid),
  if
    X > 0 ->
      loop2DPushSumNodes(X - 1, Y, R, NumNodes - 1);
    Y > 0 ->
      loop2DPushSumNodes(R, Y - 1, R, NumNodes - 1);
    true ->
      done
  end.

loopGetExistingNeighborPushSum2D(X, Y, S, W, N) ->
  NeighborCoordinate = getRandomNeighbor2D([X, Y]),
  Neighbor_X = lists:nth(1, NeighborCoordinate),
  Neighbor_Y = lists:nth(2, NeighborCoordinate),

  NeighborName = list_to_atom("pushSumNodes2D" ++ integer_to_list(Neighbor_X) ++ "_" ++ integer_to_list(Neighbor_Y)),
  NeighborPid = whereis(NeighborName),

  if
    is_pid(NeighborPid) ->
      io:format("sending to ~p~n", [NeighborName]),
      NeighborPid ! {rumors, S, W, [Neighbor_X, Neighbor_Y], N},
      done;
    true ->
      loopGetExistingNeighborPushSum2D(X, Y, S, W, N)
  end.


pushSumNodes2D(S, W, [X, Y], Rounds) ->
  if
    Rounds == 3 ->
      whereis(terminate) ! over;
    true ->
      done
  end,

  receive
    {rumors, S_send, W_send, [X, Y], N} ->
      io:format("Rumors received!! I'm Node ~p~n", [self()]),
      Ratio = (S + S_send)/(W + W_send) - S / W,
      io:format("~p~n", [abs(Ratio)]),

      io:format("~p~n", [Rounds]),

      Rand = getRandomNeighbor(2),
      if
        Rand == 1 ->
          loopGetExistingNeighborPushSum2D(X, Y, S, W, N);
        true ->
          R = trunc(math:sqrt(N)),
          GoingTo_X = random:uniform(R),
          GoingTo_Y = random:uniform(R),

          Name = list_to_atom("pushSumNodes2D" ++ integer_to_list(GoingTo_X) ++ "_" ++ integer_to_list(GoingTo_Y)),
          Pid = whereis(Name),
          Pid ! {rumors, S, W, [GoingTo_X, GoingTo_Y], N},
          io:format("sending to ~p~p~n", [GoingTo_X, GoingTo_Y])
      end,


      if
        abs(Ratio) < 0.0000000001 ->
          pushSumNodes2D((S + S_send) / 2, (W + W_send) / 2, [X, Y], Rounds + 1);
        true ->
          pushSumNodes2D((S + S_send) / 2, (W + W_send) / 2, [X, Y], 0)
      end
  end.