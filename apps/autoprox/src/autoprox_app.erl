-module(autoprox_app).
-behaviour(application).
-export([
    start/2,
    stop/1
]).

start(_Type, _StartArgs) ->
    case autoprox_sup:start_link() of
        {ok, Pid} ->
            alarm_handler:clear_alarm({application_stopped, autoprox}),
            {ok, Pid};
        Error ->
            alarm_handler:set_alarm({{application_stopped, autoprox}, []}),
            Error
    end.

stop(_State) ->
    alarm_handler:set_alarm({{application_stopped, autoprox}, []}),
    ok.