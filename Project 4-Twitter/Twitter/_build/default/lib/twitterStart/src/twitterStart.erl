%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Nov 2022 12:46 PM
%%%-------------------------------------------------------------------
-module(twitterStart).
-author("13522").

%% API
-export([start/0]).

start() ->
  server:init(),
  client:init().