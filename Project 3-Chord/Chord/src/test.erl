%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Oct 2022 3:25 PM
%%%-------------------------------------------------------------------
-module(test).
-author("13522").

%% API
-export([start/0]).

start() ->
  List = {1, 2},
  List2 = tuple_to_list(List),
  List2.