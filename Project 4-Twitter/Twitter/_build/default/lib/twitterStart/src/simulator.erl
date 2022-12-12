%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Nov 2022 4:45 PM
%%%-------------------------------------------------------------------
-module(simulator).
-author("13522").

%% API
-export([generateVirtualUsers/2, init/1, simulatorControl/2 %need fixes%
, terminate/1, loginVirtualUsers/1, getRandomNumber/1,
  virtualUsersQuery/4, virtualUsersSubscribe/2, virtualUsersSentTweet/7]).

init(NumOfUsers) ->
  LoopNumber = getRandomNumber(NumOfUsers), %Need fixes
  Pid = spawn(simulator, simulatorControl, [0, LoopNumber]),
  ProcessName = simulatorControl,
  register(ProcessName, Pid),

  %set timer
  TimeStart = erlang:monotonic_time()/10000,
  PidTerminate = spawn(simulator, terminate, [TimeStart]),
  register(terminate, PidTerminate),

  whereis(simulatorControl) ! {generate, NumOfUsers}.

terminate(TimeStart) ->
  receive
    over ->
      TimeEnd = erlang:monotonic_time()/10000,
      RunTime = TimeEnd - TimeStart,
      io:format("total time: ~f milliseconds~n", [RunTime]),
      erlang:halt()
  end,
  terminate(TimeStart).

getRandomNumber(Num) ->
  random:seed(erlang:phash2([node()]),
    erlang:monotonic_time(),
    erlang:unique_integer()),
  random:uniform(Num).

simulatorControl(TimesOfTweets, LoopNumber) ->
  if
    TimesOfTweets == LoopNumber ->
      whereis(terminate) ! over;
    true ->
      done
  end,
  DefaultTweets = ["DOSP is a great class!", "I like playing League of Legends.",
    "California is a fun state!", "I like UF.", "You are my best friend.", "This thing is bullshit", "I love it"],
  DefaultTweetsNumber = 7,
  DefaultHashTags = ["COT5615", "DOSPproject4", "UniversityOfFlorida", "China", "Florida", "USA"],
  DefaultHashTagsNumber = 6,
  receive
    {generate, NumOfUsers} ->
      generateVirtualUsers([], NumOfUsers);
    {login, ListOfVirtualUsers} ->
      loginVirtualUsers(ListOfVirtualUsers),
      Length = length(ListOfVirtualUsers),
      %LoopNumber = getRandomNumber(Length),
      LoopNumberVirtualUsersSentTweet = getRandomNumber(Length),
      LoopNumberVirtualUsersQuery = getRandomNumber(Length),
      %LoopNumberVirtualUsersSubscribe = getRandomNumber(Length),
      virtualUsersSentTweet(DefaultTweets, DefaultTweetsNumber, DefaultHashTags,
        DefaultHashTagsNumber, ListOfVirtualUsers, LoopNumberVirtualUsersSentTweet, Length),
      virtualUsersQuery(DefaultHashTags, DefaultHashTagsNumber, ListOfVirtualUsers, LoopNumberVirtualUsersQuery),
      virtualUsersSubscribe(ListOfVirtualUsers, LoopNumber);
    {done} ->
      simulatorControl(TimesOfTweets + 1, LoopNumber)
  end,
  simulatorControl(TimesOfTweets, LoopNumber).

virtualUsersQuery(_, _, _, 0) ->
  done;
virtualUsersQuery(DefaultHashTags, DefaultHashTagsNumber, ListOfVirtualUsers,
    LoopNumberVirtualUsersQuery) when LoopNumberVirtualUsersQuery > 0 ->
  RandomNumber1 = getRandomNumber(LoopNumberVirtualUsersQuery),
  UserName = lists:nth(RandomNumber1, ListOfVirtualUsers),
  RandomNumber2 = getRandomNumber(DefaultHashTagsNumber),
  QueryHashTag = lists:nth(RandomNumber2, DefaultHashTags),
  NewString = string:concat(QueryHashTag, "\n"),
  Mention = "NA\n",
  whereis(theServer) ! {query, UserName, NewString, Mention},
  virtualUsersQuery(DefaultHashTags, DefaultHashTagsNumber, ListOfVirtualUsers,
    LoopNumberVirtualUsersQuery - 1).

virtualUsersSubscribe(_, 0) ->
  done;
virtualUsersSubscribe(ListOfVirtualUsers, LoopNumber) when LoopNumber > 0 ->
  RandomNumber1 = getRandomNumber(LoopNumber),
  UserName = lists:nth(RandomNumber1, ListOfVirtualUsers),
  RandomNumber2 = getRandomNumber(LoopNumber),
  SubscribeUserName = lists:nth(RandomNumber2, ListOfVirtualUsers),
  whereis(theServer) ! {subscribe, UserName, SubscribeUserName},
  virtualUsersSubscribe(ListOfVirtualUsers, LoopNumber - 1).

virtualUsersSentTweet(_, _, _, _, _, 0, _) ->
  done;
virtualUsersSentTweet(DefaultTweets, DefaultTweetsNumber, DefaultHashTags,
    DefaultHashTagsNumber, ListOfVirtualUsers, LoopNumber, Length) when LoopNumber > 0 ->
  RandomNumber1 = getRandomNumber(LoopNumber),
  UserName = lists:nth(RandomNumber1, ListOfVirtualUsers),
  RandomNumber2 = getRandomNumber(DefaultTweetsNumber),
  RandomNumber3 = getRandomNumber(DefaultHashTagsNumber),
  Tweet = lists:nth(RandomNumber2, DefaultTweets),
  HashTag = lists:nth(RandomNumber3, DefaultHashTags),
  RandomNumber4 = getRandomNumber(Length),
  Mention = lists:nth(RandomNumber4, ListOfVirtualUsers),
  whereis(theServer) ! {sendTweet, UserName, HashTag, Mention, Tweet},
  virtualUsersSentTweet(DefaultTweets, DefaultTweetsNumber, DefaultHashTags,
    DefaultHashTagsNumber, ListOfVirtualUsers, LoopNumber - 1, Length).

loginVirtualUsers([]) ->
  done;
loginVirtualUsers(ListOfVirtualUsers) ->
  FakeUserName = lists:nth(1, ListOfVirtualUsers),
  whereis(theServer) ! {login, FakeUserName, FakeUserName},
  NewListOfVirtualUsers = lists:delete(FakeUserName, ListOfVirtualUsers),
  loginVirtualUsers(NewListOfVirtualUsers).

generateVirtualUsers(ListOfVirtualUsers, 0) ->
  whereis(simulatorControl) ! {login, ListOfVirtualUsers},
  done;
generateVirtualUsers(ListOfVirtualUsers, NumOfUsers) when NumOfUsers > 0 ->
  AllowedChars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890",
  LengthOfFakeUserName = random:uniform(12),
  FakeUserName = lists:foldl(fun(_, Acc) ->
    [lists:nth(random:uniform(length(AllowedChars)), AllowedChars)] ++ Acc
                             end, [], lists:seq(1, LengthOfFakeUserName)),
  FakePassword = FakeUserName,
  whereis(theServer) ! {registerAccount, FakeUserName, FakePassword},
  NewListOfVirtualUsers = ListOfVirtualUsers ++ [FakeUserName],
  generateVirtualUsers(NewListOfVirtualUsers, NumOfUsers - 1).
