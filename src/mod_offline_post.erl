-module(mod_offline_post).
-author('Push Mod By Adam').

-behaviour(gen_mod).

%% Required by ?INFO_MSG macros
-include("logger.hrl").

%% Required by ?T macro
-include("translate.hrl").

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
  #{desc =>
      ?T("This is an example module.")}.