%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Nov 2022 2:51 PM
%%%-------------------------------------------------------------------
-module(client).
-author("13522").
-include("arguments.hrl").

%% API
-export([registerAccount/2, login/2, sendTweet/4,
  logout/1, getCommand/0, init/0]).

registerAccount(UserName, Password) ->
  whereis(theServer) ! {registerAccount, UserName, Password}.

login(UserName, Password) ->
  whereis(theServer) ! {login, UserName, Password}.

sendTweet(UserName, HashTag, Mention, Tweet) ->
  whereis(theServer) ! {sendTweet, UserName, HashTag, Mention, Tweet}.

query(UserName, HashTag, Mention) ->
  whereis(theServer) ! {query, UserName, HashTag, Mention}.

subscribe(UserName, SubscribeUserName) ->
  whereis(theServer) ! {subscribe, UserName, SubscribeUserName}.

logout(UserName) ->
  whereis(theServer) ! {logout, UserName}.

getCommand()->
  %%Gets the command from the user
  io:format("Please enter command:\n"),
  io:format("1. register\n"),
  io:format("2. login\n"),
  io:format("3. send tweet\n"),
  io:format("4. query\n"),
  io:format("5. subscribe\n"),
  io:format("6. retweet\n"),
  io:format("7. logout\n"),
  io:format("Please enter the number of the mode you want to run:"),
  Mode = io:get_line(""),
  case Mode of
    "1\n" ->
      io:format("Please enter username:"),
      Username = io:get_line(""),
      io:format("Please enter password:"),
      Password = io:get_line(""),
      registerAccount(Username,Password);
    "2\n" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the password:"),
      Password = io:get_line(""),
      login(Username,Password);
    "3\n" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter hashtag, if none enter NA:"),
      HashTag = io:get_line(""),
      io:format("Please enter your mentions, if none enter NA:"),
      Mention = io:get_line(""),
      io:format("Please enter the tweet:"),
      Tweet = io:get_line(""),
      sendTweet(Username, HashTag, Mention, Tweet);
    "4\n" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter hashtag you wanna query, if none enter NA:"),
      HashTag = io:get_line(""),
      io:format("Please enter mentions you wanna query, if none enter NA:"),
      Mention = io:get_line(""),
      query(Username, HashTag, Mention);
    "5\n" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the subcribe username:"),
      SubscribeUsername = io:get_line(""),
      subscribe(Username, SubscribeUsername);
    "6" ->
      io:format("Please enter the username:"),
      Username = io:get_line(""),
      io:format("Please enter the tweet:"),
      Tweet = io:get_line("");
      %retweet(Username,Tweet)
    "7\n" ->
      io:format("Please enter the username:"),
      UserName = io:get_line(""),
      io:format("logging out...\n"),
      logout(UserName)
  end,
  receive
    {done} ->
      getCommand()
  end.

init() ->
  io:format("Welcome to the Twitter system!\n"),
  Pid = spawn(client, getCommand, []),
  ProcessName = getCommand,
  register(ProcessName, Pid),
  getCommand().