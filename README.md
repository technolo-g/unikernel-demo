## Where this is from:
https://erlangcentral.org/wiki/index.php?title=A_fast_web_server_demonstrating_some_undocumented_Erlang_features

# How to start this server (manually)
```
%% Compile our modules
c(autoprox).
c(autoprox_app).
c(autoprox_server).
c(autoprox_socket).
c(autoprox_sup).
c(test_autoprox_app).
c(rpc_sup).
c(rpc_server).

%% Create the Mnesia schema
mnesia:create_schema([node()]).

%% Start Mnesia
mnesia:start().

%% Create the Mnesia table for our node
autoprox:create_table([node()]).

%% Add a route
autoprox:add_callback(8080, 'GET', "/r", test_autoprox_app, do_get).

%% Start the server
autoprox_sup:start_link().

%% Start the RPC server for configuration
rpc_sup:start_link().

%% Test it out!
curl -vvv localhost:8080/r?245
```

### Build rebar
```
rebar clean get-deps compile
```

### Create a release and run it
```
rebar generate
cd rel/autoproxnode
./bin/autoprox console
```