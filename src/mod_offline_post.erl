-module(mod_offline_post).
-author('Push Mod By Adam').

-behaviour(gen_mod).

-export([
  start/2,
  init/2,
  stop/1,
  depends/2,
  mod_options/1,
  mod_opt_type/1,
  muc_filter_message/5,
  muc_filter_message/3,
  %offline_message/3,
  offline_message/1
]).

-define(PROCNAME, ?MODULE).

%-include("ejabberd.hrl").
%-include("jlib.hrl").
-include("xmpp.hrl").
-include("logger.hrl").
-include("mod_muc_room.hrl").


start(Host, _Opts) ->
  ?INFO_MSG("Starting mod_offline_post", []),
  ejabberd_hooks:add(offline_message_hook, Host, ?MODULE, offline_message_hook, 20),
  ok.

stop(Host) ->
  ?INFO_MSG("Stopping mod_offline_post", []),
  ejabberd_hooks:delete(offline_message_hook, Host, ?MODULE, offline_message, 10),
  ok.

reload(_Host, _NewOpts, _OldOpts) ->
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
  Token = gen_mod:get_module_opt(Message#message.from#jid.lserver, ?MODULE, auth_token),
  PostUrl = gen_mod:get_module_opt(Message#message.from#jid.lserver, ?MODULE, post_url),
  case Message#message.body of
    [] -> ok;
    [BodyTxt] ->
      BodyText = BodyTxt#text.data,
      ?DEBUG("mod_offline_post1: TOKEN: ~p ", [Token]),
      ?DEBUG("mod_offline_post1: PostURL: ~p ", [PostUrl]),
      ?DEBUG("mod_offline_post1: Text: ~p ", [BodyText]),
      Sep = "&",
      Post = [
        "type=chat", Sep,
        "to=", Message#message.to#jid.luser, Sep,
        "from=", Message#message.from#jid.luser, Sep,
        "body=", BodyText, Sep,
        "access_token=", Token
      ],
      ?DEBUG("~n####################################~nSending post request to ~s with body \"~s\"", [PostUrl, Post]),
      httpc:request(post, {binary_to_list(PostUrl), [], "application/x-www-form-urlencoded", list_to_binary(Post)}, [], [])
  end,
  Recv.
