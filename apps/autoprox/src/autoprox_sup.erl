-module(autoprox_sup).
-behaviour(supervisor).
-export([
    start_link/0,
    init/1
]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    %% Adding dev init stuff
    MnesiaDir = "/tmp",
    try del_dir(MnesiaDir) of
        _ -> ok
    catch
        error:Error -> {error, caught, Error}
    end,
    application:set_env(mnesia, dir, MnesiaDir),
    mnesia:create_schema([node()]),
    mnesia:start(),
    autoprox:create_table([node()]),
    autoprox:add_callback(8080, 'GET', "/demo", autoprox_plugin_demo, do_get),
    inets:start(),
    ssl:start(),
    Port = get_config(),
    Server = {autoprox_server, {autoprox_server, start_link, [Port]},
        permanent, 2000, worker, [autoprox_server]},
    {ok, {{one_for_one, 10, 1}, [Server]}}.

get_config() ->
    8080.

del_dir(Dir) ->
    lists:foreach(fun(D) ->
        ok = file:del_dir(D)
    end, del_all_files([Dir], [])).

del_all_files([], EmptyDirs) ->
    EmptyDirs;
del_all_files([Dir | T], EmptyDirs) ->
    {ok, FilesInDir} = file:list_dir(Dir),
    {Files, Dirs} = lists:foldl(fun(F, {Fs, Ds}) ->
        Path = Dir ++ "/" ++ F,
        case filelib:is_dir(Path) of
            true ->
                {Fs, [Path | Ds]};
            false ->
                {[Path | Fs], Ds}
        end
    end, {[],[]}, FilesInDir),
    lists:foreach(fun(F) ->
        ok = file:delete(F)
    end, Files),
    del_all_files(T ++ Dirs, [Dir | EmptyDirs]).
