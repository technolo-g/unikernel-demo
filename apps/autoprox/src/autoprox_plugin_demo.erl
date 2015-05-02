%%%-----------------------------------------------------------------------------
%%% @author Matt Bajor <mbajor@rallydev.com>
%%%  [https://github.com/technolo-g]
%%% @copyright 2015 Rally Software
%%% @doc Just a demo :D
%%% @end
%%%-----------------------------------------------------------------------------
-module(autoprox_plugin_demo).
-include("../include/autoprox.hrl").

%% API
-export([do_get/2]).

%%%=============================================================================
%%% API
%%%=============================================================================

do_get(#req{} = _Req, Args) ->
  {200, [], gen_response()}.

%%%=============================================================================
%%% Private Functions
%%%=============================================================================

%% Take the querystring and genrate a response
gen_response() ->
  Header = <<"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
<html><head>
  <title>Hi there!</title>
</head>
<body>
Denver Erlang / Elixir is the coolest meetup eva!<br />
The pid generating this response is: ">>,
  R= io_lib:format("~p",[self()]),
  Body = list_to_binary(R),
  Footer = <<"</body></html>">>,
  <<Header/binary, Body/binary, Footer/binary>>.
