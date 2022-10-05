-module(mod_offline_post).
-behaviour(gen_mod).

-include_lib("xmpp/include/xmpp.hrl").

%% Required by ?INFO_MSG macros
-include("logger.hrl").

%% gen_mod API callbacks
-export([start/2, stop/1, depends/2, reload/3, mod_options/1, mod_doc/0]).

start(_Host, _Opts) ->
  ?INFO_MSG("Hello, ejabberd world!", []),
  ok.

stop(_Host) ->
  ?INFO_MSG("Bye bye, ejabberd world!", []),
  ok.

depends(_Host, _Opts) ->
  [].

reload(_Host, _NewOpts, _OldOpts) ->
  ok.

mod_options(_Host) ->
  [].

mod_doc() ->
  #{}.