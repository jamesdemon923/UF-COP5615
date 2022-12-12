%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Oct 2022 1:55 PM
%%%-------------------------------------------------------------------
-module(chordStart).
-author("13522").
-include("arguments.hrl").

%% API
-import(lists,[member/2]).
-export([start/2, pow/1, hash/1, createNodes/4, chordNodes/1, createKeys/2]).
-export([findSuc/2, findPre/2, loopNodes/4, chordServer/3]).

start(NumNodes, NumRequests) ->
  NumNodesMaximum = pow(?M),
  createNodes(NumNodes, NumNodesMaximum, [], NumRequests).
  %createKeys(?NumKeys, NumNodesMaximum).

pow(1) -> 2;
pow(Num) -> 2 * pow(Num - 1).

createNodes(0, NumNodesMaximum, NodeList, NumRequests) ->
  Len = length(NodeList),
  loopNodes(Len, NodeList, NumRequests, NumNodesMaximum),
  Len2 = length(NodeList),
  loopFindKeys(Len2, NodeList, NumRequests, NumNodesMaximum);
createNodes(NumNodes, NumNodesMaximum, NodeList, NumRequests) when NumNodes > 0 ->
  Pid =spawn(chordStart, chordNodes, [[]]),
  Name = hash(pid_to_list(Pid)) rem NumNodesMaximum,

  NameAtom = list_to_atom(integer_to_list(Name)),
  register(NameAtom, Pid),
  whereis(NameAtom) ! {Name, NumNodesMaximum},

  NewList = NodeList ++ [Name],
  createNodes(NumNodes - 1, NumNodesMaximum, NewList, NumRequests).

createKeys(0, _) ->
  done;
createKeys(NumKeys, NumNodesMaximum) when NumKeys > 0 ->
  Key = random:uniform(NumNodesMaximum),
  io:format("Key! ~p~n", [Key]),
  createKeys(NumKeys - 1, NumNodesMaximum).

loopFindKeys(0, _, _, _) ->
  done;
loopFindKeys(Len, NodeList, NumRequests, NumNodesMaximum) when Len > 0->
  Name = lists:nth(Len, NodeList),
  AtomOfNode = list_to_atom(integer_to_list(Name)),
  whereis(AtomOfNode) ! {findKeys, NumRequests, Name, NumNodesMaximum},
  loopFindKeys(Len - 1, NodeList, NumRequests, NumNodesMaximum).

loopNodes(0, _, NumRequests, _) ->
  Pid = spawn(chordStart, chordServer, [0, 0, NumRequests]),
  ServerName = serverChord,
  register(ServerName, Pid);
loopNodes(Len, NodeList, NumRequests, NumNodesMaximum) when Len > 0->
  Name = lists:nth(Len, NodeList),
  AtomOfNode = list_to_atom(integer_to_list(Name)),
  whereis(AtomOfNode) ! {buildFingerTable, Name, NumNodesMaximum},
  loopNodes(Len - 1, NodeList, NumRequests, NumNodesMaximum).

hash(String) ->
  <<Hash:160>> = crypto:hash(sha, String),
  Hash.

%findSuc(NumNodesMaximum, NumNodesMaximum) ->
 % findSuc(0, NumNodesMaximum);
findSuc(Pos, NumNodesMaximum) ->
  %io:format("going through suc: ~p~n", [Pos]),
  if
    Pos >= NumNodesMaximum ->
      findSuc(Pos rem NumNodesMaximum, NumNodesMaximum);
    true ->
      CheckPid = whereis(list_to_atom(integer_to_list(Pos))),
      if
        is_pid(CheckPid) ->
          Pos;
        true ->
          findSuc(Pos + 1, NumNodesMaximum)
      end
  end.

findPre(0, NumNodesMaximum) ->
  findPre(NumNodesMaximum, NumNodesMaximum);
findPre(Pos, NumNodesMaximum) when Pos > 0 ->
  CheckPid = whereis(list_to_atom(integer_to_list(Pos))),
  if
    is_pid(CheckPid) ->
      Pos;
    true ->
      findPre(Pos - 1, NumNodesMaximum)
  end.

chordServer(Num, TotalHop, NumRequests) ->
  receive
    {hop, Hop} ->
      if
        Num < NumRequests ->
          chordServer(Num + 1, TotalHop + Hop, NumRequests);
        true ->
          io:format("************************ Hop Average: ~p ************************~n", [TotalHop / Num]),
          chordServer(0, 0, NumRequests)
      end
  end.

chordNodes(FingerTable) ->
  receive
    {buildFingerTable, Name, NumNodesMaximum} ->
      FixFingerTable = findKeys:buildFingerTable(?M - 1, Name, [], NumNodesMaximum),
      io:format("I'm node ~p~n", [Name]),
      %io:format("I'm Node ~p and my finger table is ~p~n", [Name, FixFingerTable]),
      chordNodes(FixFingerTable);
    {findKeys, NumRequests, Name, NumNodesMaximum} ->
      findKeys:createAndFindKeys(NumRequests, NumNodesMaximum, Name),
      chordNodes(FingerTable);
    {key, Name, Key, NumNodesMaximum, Hop} ->
      %io:format("Node ~p has to find Key ~p~n", [Name, Key]),
      Suc = findSuc(Name + 1, NumNodesMaximum),
      SucKey = findSuc(Key, NumNodesMaximum),
      if
        Key == Name ->
          io:format("Key ~p is located in Node ~p~n", [Key, Name]),
          %io:format("************************ Total Hop: 1 ************************~n"),
          whereis(chordServer) ! {hop, 1};
        true ->
          if
            (Key =< Suc) and (Key > Name) ->
              io:format("Key ~p is located in Node ~p~n", [Key, Suc]),
              %io:format("************************ Total Hop: ~p ************************~n", [Hop + 1]),
              whereis(serverChord) ! {hop, Hop + 1},
              chordNodes(FingerTable);
            true ->
              NextFinger = findKeys:goThroughFingerTable(FingerTable, Key, ?M, Name),
              %io:format("!!!!!Key~p NextFinger in Node ~p~n", [Key, NextFinger]),
              if
                SucKey == NextFinger ->
                  io:format("Key ~p is located in Node ~p~n", [Key, NextFinger]),
                  %io:format("************************ Total Hop: ~p ************************~n", [Hop + 1]),
                  whereis(serverChord) ! {hop, Hop + 1},
                  chordNodes(FingerTable);
                true ->
                  whereis(list_to_atom(integer_to_list(NextFinger))) ! {key, NextFinger, Key, NumNodesMaximum, Hop + 1}
              end
          end
      end,
      timer:sleep(100)
  end,
  chordNodes(FingerTable).