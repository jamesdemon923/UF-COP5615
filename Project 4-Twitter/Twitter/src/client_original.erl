%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Nov 2022 1:37 PM
%%%-------------------------------------------------------------------
-module(client_original).
-author("13522").

%% API
-export([crateActor/3, createSocketConnect/1, msgClientLoop/1, msg/0, registerAccount/4,
  login/4, sendTweet/6, getTweet/5, subscribe/4, retweet/4, getCommand/2, init/0, startClient/2]).


crateActor(N,M,Server) when N > 0 ->
  %%Generate N actors by recursion N times
  process_flag(trap_exit,true),
  spawn_link(client_original, msgClientLoop,[Server]),
  crateActor(N-1,M,Server);
crateActor(0,_M,_Server)  ->
  io:format("All actors have been generated.\n"),
  done.

createSocketConnect(Host) ->
  %%Make a connection request to the server that specifies host
  {ok,IP} = Host,
  {_Statue,_Socket} = gen_tcp:connect(IP,8888,[binary,{packet,0}]).

startClient(M,Host) ->
  %%running in client mode,if the connection to the server is successfully established, the actor is generated to start mining
  {Statue,SocketORReason} = createSocketConnect(Host),
  if
    Statue == ok->
      Server = spawn_link(client_original, msgClientLoop,[SocketORReason]),
      crateActor(1000,M,Server);
    Statue == error ->
      io:format(""++SocketORReason),
      erlang:halt()
  end,
  msg().

msgClientLoop(Socket) ->
  %%receiving the coins from client's actors and send to server
  receive
    {"registerAccount"} ->
      io:format("user creat successfully!\n"),
      msgClientLoop(Socket);
    {"login"} ->
      io:format("user login successfully!\n"),
      msgClientLoop(Socket);
    {"sendTweet"} ->
      io:format("send tweet successfully!\n"),
      msgClientLoop(Socket);
    {Tweet} ->
      io:format("get tweet successfully!~p\n",[Tweet]),
      msgClientLoop(Socket);
    {"subcribe"} ->
      io:format("subcribe successfully!\n"),
      msgClientLoop(Socket);
    {"retweet"} ->
      io:format("retweet successfully!\n"),
      msgClientLoop(Socket);
    {"auto update",Tweet} ->
      io:format("auto update successfully!~p\n",[Tweet]),
      msgClientLoop(Socket)
  end,
  msgClientLoop(Socket).

msg()->
  %%Gets the error message and prints it
  receive
    {tcp_closed,_}-> io:format("tcp_closed"),
      erlang:halt();
    Msg -> io:format("Error ~p~n", [Msg])
  end,
  msg().
registerAccount(SelfSocket,Socket,Username,Password) ->
  %%register a new account
  gen_tcp:send(Socket,[registerAccount,SelfSocket,Username,Password]).
login(SelfSocket,Socket,Username,Password) ->
  %%login
  gen_tcp:send(Socket,[login, SelfSocket,Username,Password]).
sendTweet(SelfSocket,Socket,Username,TAG,AT,Tweet) ->
  %%send a tweet
  gen_tcp:send(Socket,[sendTweet, SelfSocket,TAG,AT,Username,Tweet]).
getTweet(SelfSocket,Socket,Username,TAG,AT) ->
  %%get a tweet
  gen_tcp:send(Socket,[getTweet, SelfSocket,Username,TAG,AT]).
subscribe(SelfSocket,Socket,Username, SubscribeUsername) ->
  %%subscribe a user
  gen_tcp:send(Socket,[subscribe, SelfSocket,Username, SubscribeUsername]).
retweet(SelfSocket,Socket,Username,Tweet) ->
  %%retweet a tweet
  gen_tcp:send(Socket,[retweet, SelfSocket,Username,Tweet]).


getCommand(SelfSocket,Socket)->
  %%Gets the command from the user
  io:format("Please enter the command:"),
  io:format("1. register\n"),
  io:format("2. login\n"),
  io:format("3. send tweet\n"),
  io:format("4. get tweet\n"),
  io:format("5. subcribe\n"),
  io:format("6. retweet\n"),
  io:format("Please enter the number of the mode you want to run:"),
  Mode = io:get_line(""),
  case Mode of
    "1" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the password:"),
      Password = io:get_line(""),
      registerAccount(SelfSocket,Socket,Username,Password);
    "2" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the password:"),
      Password = io:get_line(""),
      login(SelfSocket,Socket,Username,Password);
    "3" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the TAG:"),
      TAG = io:get_line(""),
      io:format("Please enter the AT:"),
      AT = io:get_line(""),
      io:format("Please enter the tweet:"),
      Tweet = io:get_line(""),
      sendTweet(SelfSocket,Socket,Username,TAG,AT,Tweet);
    "4" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the TAG:"),
      TAG = io:get_line(""),
      io:format("Please enter the AT:"),
      AT = io:get_line(""),
      getTweet(SelfSocket,Socket,Username,TAG,AT);
    "5" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the subcribe username:"),
      SubscribeUsername = io:get_line(""),
      subscribe(SelfSocket,Socket,Username,SubscribeUsername);
    "6" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the tweet:"),
      Tweet = io:get_line(""),
      retweet(SelfSocket,Socket,Username,Tweet)
  end,
  getCommand(SelfSocket,Socket).

init() ->
  SelfSocket = self(),
  Socket = client_original:createSocketConnect("127.0.0.1"),
  %%initialization
  io:format("Welcome to the Twitter system!\n"),
  getCommand(SelfSocket,Socket).

