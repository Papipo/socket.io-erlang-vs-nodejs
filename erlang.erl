#! /usr/bin/env escript
%%! -pa socket.io-erlang/ebin socket.io-erlang/deps/misultin/ebin socket.io-erlang/deps/ossp_uuid/ebin socket.io-erlang/deps/jsx/ebin socket.io-erlang/include -I ./socket.io-erlang
-mode(compile).
-include_lib("include/socketio.hrl").
-compile(export_all).
-behaviour(gen_event).

main(_) ->
    % appmon:start(),
    application:start(sasl),
    application:start(misultin),
    application:start(socketio),
    {ok, Pid} = socketio_listener:start([{http_port, 3000}, 
                                         {default_http_handler,?MODULE}]),
    EventMgr = socketio_listener:event_manager(Pid),
    ok = gen_event:add_handler(EventMgr, ?MODULE,[]),
    receive _ -> ok end.

%% gen_event
init([]) ->
    {ok, undefined}.

handle_event({client, Pid}, State) ->
    io:format("Connected: ~p~n",[Pid]),
    EventMgr = socketio_client:event_manager(Pid),
    ok = gen_event:add_handler(EventMgr, ?MODULE,[]),
    {ok, State};
handle_event({disconnect, Pid}, State) ->
    io:format("Disconnected: ~p~n",[Pid]),
    {ok, State};
handle_event({message, Client, #msg{ content = Content } = Msg}, State) ->
    % io:format("Received message: ~p~n",[Content]),
    socketio_client:send(Client, #msg{ content = ["PONG"]}),
    {ok, State};

handle_event(E, State) ->
    {ok, State}.

handle_call(_, State) ->
    {reply, ok, State}.

handle_info(_, State) ->
    {ok, State}.

terminate(_Reason, State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
%%

handle_request('GET', [], Req) ->
    Req:file(filename:join([filename:dirname(code:which(?MODULE)), "index.html"]));
handle_request(_Method, _Path, Req) ->
    Req:respond(200).
