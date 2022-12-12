%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2022 5:43 PM
%%%-------------------------------------------------------------------
-module(terminate).
-author("13522").

%% API
-export([terminateEverything/1]).

terminateEverything(TimeStart) ->
  receive
    over ->
      TimeEnd = erlang:monotonic_time()/10000,
      RunTime = TimeEnd - TimeStart,
      io:format("total time: ~f milliseconds~n", [RunTime]),
      erlang:halt()
  end,
  terminateEverything(TimeStart).
