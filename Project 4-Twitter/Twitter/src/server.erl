%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Nov 2022 3:02 PM
%%%-------------------------------------------------------------------
-module(server).
-author("13522").
-include("arguments.hrl").

%% API
-export([init/0, theServer/6, loopGoThroughClientList/4, loopGoThroughTweetListFindHashTag/3]).

theServer(ClientList, OnlineList, LenClient, LenOnline, TweetList, LenTweet) ->
  receive
    {registerAccount, UserName, Password} ->
      io:format("new user ~p registered!\n", [UserName]),
      NewClientList = ClientList ++ [{UserName, Password}],
      Pid = whereis(getCommand),
      if
        is_pid(Pid) ->
          Pid ! {done};
        true ->
          done
      end,
      theServer(NewClientList, OnlineList, LenClient + 1, LenOnline, TweetList, LenTweet);
    {login, UserName, Password} ->
      io:format("logging in...\n"),
      loopGoThroughClientList(ClientList, LenClient, UserName, Password),
      receive
        {loginCorrect, UserName} ->
          io:format("~p logged in successfully!\n", [UserName]),
          if
            UserName == "admin\n" ->
              io:format("ADMIN MODE\n"),
              io:format("Client List:\n"),
              io:format("~p\n", [ClientList]),
              io:format("Online List:\n"),
              io:format("~p\n", [OnlineList]),
              io:format("Tweet List:\n"),
              io:format("~p\n", [TweetList]);
            true ->
              done
          end,
          NewOnlineList = OnlineList ++ [UserName],
          theServer(ClientList, NewOnlineList, LenClient, LenOnline + 1, TweetList, LenTweet);
        {loginWrongPassword, UserName} ->
          io:format("wrong password!\n"),
          theServer(ClientList, OnlineList, LenClient, LenOnline, TweetList, LenTweet);
        {loginWrongUserName, UserName} ->
          io:format("wrong user name!\n"),
          theServer(ClientList, OnlineList, LenClient, LenOnline, TweetList, LenTweet)
      end,
      Pid = whereis(getCommand),
      if
        is_pid(Pid) ->
          Pid ! {done};
        true ->
          done
      end;
    {logout, UserName} ->
      NewOnlineList = lists:delete(UserName, OnlineList),
      io:format("logged out successfully\n"),
      Pid = whereis(getCommand),
      if
        is_pid(Pid) ->
          Pid ! {done};
        true ->
          done
      end,
      theServer(ClientList, NewOnlineList, LenClient, LenOnline - 1, TweetList, LenTweet);
    {sendTweet, UserName, HashTag, Mention, Tweet} ->
      io:format("<Tweet> ~p : ~p ", [UserName, Tweet]),
      if
        HashTag /= "NA\n" ->
          io:format("#~p ", [HashTag]);
        Mention /= "NA\n" ->
          io:format("@~p ", [Mention]);
        true ->
          done
      end,
      NewTweetList = TweetList ++ [{UserName, HashTag, Mention, Tweet}],
      io:format("\n"),
      Pid = whereis(getCommand),
      if
        is_pid(Pid) ->
          Pid ! {done};
        true ->
          done
      end,
      theServer(ClientList, OnlineList, LenClient, LenOnline, NewTweetList, LenTweet + 1);
    {query, UserName, HashTag, Mention} ->
      io:format("Querying...\n"),
      if
        Mention == "NA\n" ->
          io:format("Looking for HashTag ~p\n", [HashTag]),
          loopGoThroughTweetListFindHashTag(TweetList, LenTweet, HashTag);
        HashTag == "NA\n" ->
          io:format("Looking for Mention ~p\n", [Mention]),
          loopGoThroughTweetListFindMention(TweetList, LenTweet, Mention);
        true ->
          done
      end,
      Pid = whereis(getCommand),
      if
        is_pid(Pid) ->
          Pid ! {done};
        true ->
          done
      end;
    {subscribe, UserName, SubscribeUserName} ->
      io:format("User ~p followed user ~p!\n", [UserName, SubscribeUserName]),
      PidSimulatorControl = whereis(simulatorControl),
      if
        is_pid(PidSimulatorControl) ->
          PidSimulatorControl ! {done};
        true ->
          done
      end

  end,
  theServer(ClientList, OnlineList, LenClient, LenOnline, TweetList, LenTweet).

loopGoThroughClientList(_, -1, _, _) ->
  done;
loopGoThroughClientList(_, 0, UserName, _) ->
  whereis(theServer) ! {loginWrongUserName, UserName},
  done;
loopGoThroughClientList(ClientList, Len, UserName, Password) when Len > 0 ->
  ListLine = lists:nth(Len, ClientList),
  ListUserName = lists:nth(1, tuple_to_list(ListLine)),
  ListPassword = lists:nth(2, tuple_to_list(ListLine)),
  if
    (ListUserName == UserName) and (ListPassword == Password) ->
      whereis(theServer) ! {loginCorrect, UserName},
      loopGoThroughClientList(ClientList, -1, UserName, Password);
    (ListUserName == UserName) and (ListPassword /= Password) ->
      whereis(theServer) ! {loginWrongPassword, UserName},
      loopGoThroughClientList(ClientList, -1, UserName, Password);
    true ->
      loopGoThroughClientList(ClientList, Len - 1, UserName, Password)
  end.

loopGoThroughTweetListFindHashTag(_, 0, _) ->
  done;
loopGoThroughTweetListFindHashTag(TweetList, Len, HashTag) when Len > 0 ->
  ListLine = lists:nth(Len, TweetList),
  ListHashTag = lists:nth(2, tuple_to_list(ListLine)),
  ListTweet = lists:nth(4, tuple_to_list(ListLine)),
  NewString = string:concat(ListHashTag, "\n"),
  %io:format("~p ~p\n", [NewString, HashTag]),
  if
    NewString == HashTag ->
      whereis(theServer) ! {queryCorrect, HashTag},
      io:format("<query># ~p ~p\n", [ListHashTag, ListTweet]),
      loopGoThroughTweetListFindHashTag(TweetList, Len - 1, HashTag);
    true ->
      loopGoThroughTweetListFindHashTag(TweetList, Len - 1, HashTag)
  end.

loopGoThroughTweetListFindMention(_, 0, _) ->
  done;
loopGoThroughTweetListFindMention(TweetList, Len, Mention) when Len > 0 ->
  ListLine = lists:nth(Len, TweetList),
  ListMention = lists:nth(3, tuple_to_list(ListLine)),
  ListTweet = lists:nth(4, tuple_to_list(ListLine)),
  NewString = string:concat(ListMention, "\n"),
  if
    NewString == Mention ->
      whereis(theServer) ! {queryCorrect, Mention},
      io:format("<query># ~p ~p\n", [ListMention, ListTweet]),
      loopGoThroughTweetListFindMention(TweetList, Len - 1, Mention);
    true ->
      loopGoThroughTweetListFindMention(TweetList, Len - 1, Mention)
  end.

init() ->
  Pid = spawn(server, theServer, [[{"admin\n", "phil0\n"}], [], 1, 0, [], 0]),
  ServerName = theServer,
  register(ServerName, Pid),
  io:format("Server initialized\n").
