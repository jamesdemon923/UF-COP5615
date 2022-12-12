%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Sep 2022 1:40 PM
%%%-------------------------------------------------------------------
-module(bitcoin).
-author("jiangxu").

%% API
-export([generateRandomString/2]).
-export([encode/1]).
-export([hash/1]).
-export([generateStringAndSHA256/2]).
-export([loop/4]).
-export([findKeyWithZeros/3]).
-export([printTime/1]).

%here given length and range of chars, generateRandomString can generate a random String.
%This function here I looked up the website https://tsharju.github.io/2009/11/07/generating-random-strings-in-erlang/.
generateRandomString(Length, AllowedChars) ->
  lists:foldl(fun(_, Acc) ->
    [lists:nth(random:uniform(length(AllowedChars)), AllowedChars)] ++ Acc
              end, [], lists:seq(1, Length)).

%function hash hashes the String into a series of numbers using SHA256.
hash(String) ->
  <<Hash:256>> = crypto:hash(sha256, String),
  Hash.

%function encode encodes the output of function hash and gets the final SHA256 result of a given String.
%I've compared this result to the result of https://xorbin.com/tools/sha256-hash-calculator, which is correct.
encode(String) ->
  Key = string:right(integer_to_list(hash(String), 16), 64, $0),
  string:to_lower(Key).

findKeyWithZeros(NumOfZeros, NumOfLoops, Names) ->
  io:fwrite("*******processing*******\n"),
  ListOfCorrectKeys = [],
  loop(NumOfLoops, ListOfCorrectKeys, NumOfZeros, Names).


loop(0, _, _, _) ->
  done;
loop(Num, List, NumOfZeros, Names) when Num > 0 ->
  %here we have the argument Length as 12, which means the generated random string won't be longer than 12
  StrGen = generateStringAndSHA256(12, Names),
  SubStringFront = string:substr(StrGen, 1, NumOfZeros),
  MultipleZeros = lists:concat(lists:duplicate(NumOfZeros, "0")),
  if
    SubStringFront == MultipleZeros ->
      io:fwrite("Yes!!\n"),
      {ok, Fd} = file:open("D:/Erlang/ProjBitcoin/Keys.txt", [append]),
      io:format(Fd, "~p~n", [StrGen]),
      printTime(Fd),
      file:close(Fd);
    true ->
      ct:continue()
  end,
  loop(Num - 1, List, NumOfZeros, Names).

printTime(Fd) ->
  {_,Time} = statistics(runtime),
  {_,Time2} = statistics(wall_clock),

  timer:sleep(2000),
  CPU_time = Time / 1000,
  Run_time = Time2 / 1000,
  Time3 = CPU_time / Run_time,
  io:format(Fd, "CPU time: ~p seconds\n", [CPU_time]),
  io:format(Fd, "real time: ~p seconds\n", [Run_time]),
  io:format(Fd, "Ratio: ~p \n", [Time3]).

generateStringAndSHA256(MaximumLengthOfString, Names) ->
  %AllowedChars is the range of all the chars that's gonna appear in the randomly generated String.
  %We can always change the range here.
  AllowedChars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890~!@#$%^&*()_+-=[]\;',./{}|:<>?",
  LengthOfGeneratedString = random:uniform(MaximumLengthOfString),
  GeneratedString = generateRandomString(LengthOfGeneratedString, AllowedChars),
  StringWithName = string:concat(Names, GeneratedString),
  KeySHA256 = encode(StringWithName),
  ReturnKey = KeySHA256 ++ "            " ++ StringWithName,
  io:format("~p~n", [ReturnKey]),
  ReturnKey.
