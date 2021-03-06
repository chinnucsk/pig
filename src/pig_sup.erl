
-module(pig_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_db/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    ets:new(ets_session, [ordered_set, public, named_table]),
    ChildSpec1 = {player_sup, {player_sup, start_link, []}, temporary, brutal_kill, supervisor, [player_sup]},
    {ok, { {one_for_one, 5, 10}, [ChildSpec1]}}.


start_db() ->
	ChildSpec = ?CHILD(eredis, worker),
	supervisor:start_child(?MODULE, ChildSpec).