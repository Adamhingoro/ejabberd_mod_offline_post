-module(mod_offline_post).
-author('Push Mod By Adam').

-behaviour(gen_mod).

-export([
  start/2,
  stop/1,
  depends/2,
  mod_options/1,
  mod_opt_type/1,
  offline_message/1
]).

-include_lib("xmpp/include/xmpp.hrl").
-include("logger.hrl").
-include("mod_muc_room.hrl").


start(Host, _Opts) ->
  ejabberd_hooks:add(offline_message_hook, Host, ?MODULE, offline_message_hook, 20),
  ok.

stop(Host) ->
  ejabberd_hooks:delete(offline_message_hook, Host, ?MODULE, offline_message, 10),
  ok.

depends(_Host, _Opts) ->
  [].

mod_options(_Host) ->
  [post_url, auth_token].

mod_opt_type(post_url) -> fun(B) when is_binary(B) -> B end;
mod_opt_type(auth_token) -> fun(B) when is_binary(B) -> B end;
mod_opt_type(_) ->
  [post_url, auth_token].



-spec offline_message({_, message()}) -> {_, message()} | {stop, {drop, message()}}.
offline_message({_Action, #message{} = Msg} = Acc) ->
  ?DEBUG("~n#################################### ENTERING CHAT OFFLINE MESSAGE (2) ###################################~n", []),
  ok.
