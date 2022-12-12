%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2022 4:56 PM
%%%-------------------------------------------------------------------
-module(gossipSimulation).
-author("13522").

%% API
-export([start/3]).

start(NumNodes, Topology, Algorithm) ->
  if
    Topology == "full" ->
      topologyFull:start(NumNodes, Algorithm);
    Topology == "2D" ->
      topology2D:start(NumNodes, Algorithm);
    Topology == "line" ->
      topologyLine:start(NumNodes, Algorithm);
    Topology == "imp2D" ->
      topologyImp2D:start(NumNodes, Algorithm);
    true ->
      done
  end.