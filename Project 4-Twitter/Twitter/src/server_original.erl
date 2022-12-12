%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Nov 2022 2:03 PM
%%%-------------------------------------------------------------------
-module(server_original).
-author("13522").

%% API
-export([createSocketServer/1, getIP/0, startServer/0, msgClient2ServerLoop/1, init/0]).

getIP() ->
  %%Get the IP address of the current machine
  {ok, [{_, _, _, {A, B, C, D}}]} = inet:getifaddrs(),
  io:format("IP: ~p.~p.~p.~p~n", [A, B, C, D]).

createSocketServer(ListenSocket) ->
  %%Listens for and accepts connection requests from clients
  {ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
  io:format("Client ~p connected!\n",[AcceptSocket]),
  spawn_link(fun()-> createSocketServer(ListenSocket) end),
  spawn_link(fun()-> msgClient2ServerLoop(AcceptSocket) end).

startServer() ->

  %%running in server mode, generating an msg loop actor loop that outputs the coins mined by the actor and client
  {ok,ListenSocket} = gen_tcp:listen(8888,[binary,{packet,0},
    {reuseaddr,true},
    {active,true}]),
  spawn_link(fun()-> createSocketServer(ListenSocket) end),
  msg().

msgClient2ServerLoop(AcceptSocket) ->
  receive
    {registerAccount,AcceptSocket,Username,Password}-> io:format("new user register\n"),
      gen_tcp:send(AcceptSocket,["registerAccount"]),
      ets:new(Username++subscribe,[bag,public,named_table]),
      ets:insert(user, {AcceptSocket, "newUser"}),
      msgClient2ServerLoop(AcceptSocket);
    {login,AcceptSocket,Username,Password}-> io:format("user login\n"),
      User = array:from_list(ets:match(tweet, {Username,Password})),
      gen_tcp:send(AcceptSocket,["login"]),
      msgClient2ServerLoop(AcceptSocket);
    {sendTweet,AcceptSocket,TAG,AT,Username,Tweet}-> io:format("user send tweet\n"),
      gen_tcp:send([AcceptSocket],["sendTweet",TAG,AT]),
      ets:insert(tweet, {Username, TAG, AT}),
      msgClient2ServerLoop(AcceptSocket);
    {getTweet,AcceptSocket,Username,TAG,AT}-> io:format("user gettweet\n"),
      Tweet = array:from_list(ets:match(tweet, {Username,TAG,AT})),
      gen_tcp:send(AcceptSocket,[Tweet]),
      msgClient2ServerLoop(AcceptSocket);
    {subscribe,AcceptSocket,Username, SubscribedUsername}-> io:format("user subcribe\n"),
      gen_tcp:send(AcceptSocket,["subcribe"]),
      ets:insert(Username++subscribe, {AcceptSocket, SubscribedUsername}),
      msgClient2ServerLoop(AcceptSocket);
    {retweet,AcceptSocket,Username,Tweet}-> io:format("user retweet\n"),
      ets:insert(tweet, {AcceptSocket, Tweet}),
      gen_tcp:send(AcceptSocket,["retweet"]),
      msgClient2ServerLoop(AcceptSocket);

    Msg -> io:format("Error ~p~n", [Msg])
  after 10000 ->
    io:format("logined user gettweet\n"),
    Tweet = array:from_list(ets:match(tweet, {AcceptSocket})),
    gen_tcp:send(AcceptSocket,["auto update",Tweet]),
    msgClient2ServerLoop(AcceptSocket)
  end,
  msgClient2ServerLoop(AcceptSocket).

msg()->
  %%Gets the error message and prints it
  receive
    {tcp_closed,_}-> io:format("tcp_closed"),
      erlang:halt();
    Msg -> io:format("Error ~p~n", [Msg])

  end,
  msg().

init() ->
  %%Initializes the server
  io:format("Server started~n"),
  ets:new(user,[bag,public,named_table]),
  ets:new(tweet,[bag,public,named_table]),
  %getIP(),
  startServer().
