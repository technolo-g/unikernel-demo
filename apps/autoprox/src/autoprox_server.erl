-module(autoprox_server).

-behaviour(gen_server).

-export([start_link/1, create/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-record(state, {listen_socket,
  port,
  acceptor}).

%%--------------------------------------------------------------------
start_link(Port) when is_integer(Port) ->
  Name = list_to_atom(lists:flatten(io_lib:format("autoprox_~w", [Port]))),
  gen_server:start_link({local, Name}, ?MODULE, Port, []).

%% Send message to cause a new acceptor to be created
create(ServerPid, Pid) ->
  gen_server:cast(ServerPid, {create, Pid}).


%% Called by gen_server framework at process startup. Create listening socket
init(Port) ->
  process_flag(trap_exit, true),
  case gen_tcp:listen(Port,[binary, {packet, http},
    {reuseaddr, true},
    {active, false},
    {backlog, 30}]) of
    {ok, Listen_socket} ->
      %%Create first accepting process
      Pid = autoprox_socket:start_link(self(), Listen_socket, Port),
      {ok, #state{listen_socket = Listen_socket,
        port = Port,
        acceptor = Pid}};
    {error, Reason} ->
      {stop, Reason}
  end.


handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

%% Called by gen_server framework when the cast message from create/2 is received
handle_cast({create, _Pid}, #state{listen_socket = Listen_socket} = State) ->
  New_pid = autoprox_socket:start_link(self(), Listen_socket, State#state.port),
  {noreply, State#state{acceptor=New_pid}};

handle_cast(_Msg, State) ->
  {noreply, State}.


handle_info({'EXIT', Pid, normal}, #state{acceptor=Pid} = State) ->
  {noreply, State};

%% The current acceptor has died, wait a little and try again
handle_info({'EXIT', Pid, _Abnormal}, #state{acceptor=Pid} = State) ->
  timer:sleep(2000),
  autoprox_socket:start_link(self(), State#state.listen_socket, State#state.port),
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, State) ->
  gen_tcp:close(State#state.listen_socket),
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.