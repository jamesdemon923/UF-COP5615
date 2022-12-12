%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Oct 2022 2:55 PM
%%%-------------------------------------------------------------------
-module(findKeys).
-author("13522").
-include("arguments.hrl").

%% API
-export([getRandomNumber/1, createAndFindKeys/3, goThroughFingerTable/4, buildFingerTable/4]).

getRandomNumber(Num) ->
  random:seed(erlang:phash2([node()]),
    erlang:monotonic_time(),
    erlang:unique_integer()),
  random:uniform(Num).

buildFingerTable(0, Name, FingerTable, NumNodesMaximum) ->

  NextFinger = Name + 1,
  NextNode = chordStart:findSuc(NextFinger, NumNodesMaximum),
  NewTable = FingerTable ++ [{NextFinger, NextNode}],

  Atom = list_to_atom(integer_to_list(Name)),
  whereis(Atom) ! {fingerTable, NewTable};
buildFingerTable(M, Name, FingerTable, NumNodesMaximum) ->
  NextFinger = Name + chordStart:pow(M),
  NextNode = chordStart:findSuc(NextFinger, NumNodesMaximum),
  NewTable = FingerTable ++ [{NextFinger, NextNode}],
  buildFingerTable(M - 1, Name, NewTable, NumNodesMaximum).

createAndFindKeys(0, _, _) ->
  done;
createAndFindKeys(NumRequests, NumNodesMaximum, Name) ->
  Key = getRandomNumber(NumNodesMaximum),
  %io:format("Node ~p has to find Key ~p !!!!!!!!!!!!!~n", [Name, Key]),
  Atom = list_to_atom(integer_to_list(Name)),
  whereis(Atom) ! {key, Name, Key, NumNodesMaximum, 0},
  createAndFindKeys(NumRequests - 1, NumNodesMaximum, Name).

goThroughFingerTable(FingerTable , _, 0, _) ->
  RealFingerTable = lists:nth(2, tuple_to_list(FingerTable)),
  FingerLine = tuple_to_list(lists:nth(1, RealFingerTable)),
  FingerNode = lists:nth(2, FingerLine),
  FingerNode;
goThroughFingerTable(FingerTable, Target, Pow, Name) when Pow > 0 ->
  RealFingerTable = lists:nth(2, tuple_to_list(FingerTable)),
  Num = ?M + 1 - Pow,
  NumNodeMaximum = chordStart:pow(?M),

  SucTarget = chordStart:findSuc(Target, NumNodeMaximum),
  %io:format("Key ~p Suc is ~p~n", [Target, SucTarget]),
  FingerLineTuple = lists:nth(Num, RealFingerTable),
  FingerLine = tuple_to_list(FingerLineTuple),

  FingerValue = lists:nth(1, FingerLine),
  FingerNode = lists:nth(2, FingerLine),
  %io:format("Node ~p has FingerTable on ~p th row : ~p  ~p~n", [Name, Num, FingerValue, FingerNode]),
  if
      SucTarget == FingerNode ->
        %io:format("Node ~p in finding Key ~p, jumping to Node ~p~n", [Name, Target, FingerNode]),
        chordStart:findPre(FingerNode, NumNodeMaximum);
      true ->
        goThroughFingerTable(FingerTable, Target, Pow - 1, Name)
  end.

