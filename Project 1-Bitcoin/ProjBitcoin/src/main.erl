%%%-------------------------------------------------------------------
%%% @author 13522
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Sep 2022 2:30 PM
%%%-------------------------------------------------------------------
-module(main).
-author("jiangxu").

%% API
-export([client_1/2, client_2/2, client_3/2, client_4/2, client_5/2, client_6/2, client_7/2, client_8/2, client_9/2, client_10/2, client_11/2, client_12/2, client_13/2, client_14/2, client_15/2, client_16/2, server/2, start/2]).
%we have 16 different clients doing different jobs.
%we categorize them simply by the first char after name.
client_1(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_1(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "67890]\;'"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_1(N - 1, Server_PID).

client_2(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_2(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "12345~!@#$"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_2(N - 1, Server_PID).

client_3(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_3(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "qwertyuiopas"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_3(N - 1, Server_PID).

client_4(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_4(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "QWERTYUIOPAS"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_4(N - 1, Server_PID).

client_5(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_5(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "67890]\;'"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_5(N - 1, Server_PID).

client_6(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_6(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "12345~!@#$"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_6(N - 1, Server_PID).

client_7(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_7(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "qwertyuiopas"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_7(N - 1, Server_PID).

client_8(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_8(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "QWERTYUIOPAS"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_8(N - 1, Server_PID).

client_9(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_9(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, ",./{}|:<>?"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_9(N - 1, Server_PID).

client_10(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_10(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "%^&*()_+-=["),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_10(N - 1, Server_PID).

client_11(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_11(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "dfghjklzxcvbnm"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_11(N - 1, Server_PID).

client_12(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_12(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "DFGHJKLZXCVBNM"),
      String = "haolan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_12(N - 1, Server_PID).

client_13(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_13(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, ",./{}|:<>?"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_13(N - 1, Server_PID).

client_14(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_14(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "%^&*()_+-=["),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_14(N - 1, Server_PID).

client_15(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_15(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "dfghjklzxcvbnm"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_15(N - 1, Server_PID).

client_16(0, Server_PID) ->
  Server_PID ! finished,
  io:format("Client Closed~n");

client_16(N, Server_PID) ->
  Server_PID ! {hello, self()},
  receive
    [startWorking, NumOfZeros, IterationTime] ->
      Char = bitcoin:generateRandomString(1, "DFGHJKLZXCVBNM"),
      String = "jiangan" ++ Char,
      bitcoin:findKeyWithZeros(NumOfZeros, IterationTime, String)
  end,
  client_16(N - 1, Server_PID).

server(NumOfZeros, IterationTime) ->
  receive
    finished ->
      io:format("Server Closed~n", []);
    {hello, Client_PID} ->
      Client_PID ! [startWorking, NumOfZeros, IterationTime],
      server(NumOfZeros, IterationTime)
  end.

start(NumOfZeros, IterationTime) ->
  %here we can change the maximum iteration of the client and server.
  MaxIteration = 10000,
  Server_PID = spawn(main, server, [NumOfZeros, IterationTime]),
  spawn(main, client_1, [MaxIteration, Server_PID]),
  spawn(main, client_2, [MaxIteration, Server_PID]),
  spawn(main, client_3, [MaxIteration, Server_PID]),
  spawn(main, client_4, [MaxIteration, Server_PID]),
  spawn(main, client_5, [MaxIteration, Server_PID]),
  spawn(main, client_6, [MaxIteration, Server_PID]),
  spawn(main, client_7, [MaxIteration, Server_PID]),
  spawn(main, client_8, [MaxIteration, Server_PID]),
  spawn(main, client_9, [MaxIteration, Server_PID]),
  spawn(main, client_10, [MaxIteration, Server_PID]),
  spawn(main, client_11, [MaxIteration, Server_PID]),
  spawn(main, client_12, [MaxIteration, Server_PID]),
  spawn(main, client_13, [MaxIteration, Server_PID]),
  spawn(main, client_14, [MaxIteration, Server_PID]),
  spawn(main, client_15, [MaxIteration, Server_PID]),
  spawn(main, client_16, [MaxIteration, Server_PID]).