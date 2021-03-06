-module (luminik).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
-include("records.hrl").

main() ->
  wf:redirect("/").

public_header() ->
  [
    #h1 { style="margin-bottom: 0;", text=blog_title() }
  ].

admin_header() ->
  [
    #h1 { style="margin-bottom: 0; text-align: middle;", text=luminik:blog_title() ++" - Admin Panel" }
  ].

footer() ->
  [
    #p { style="text-align: right; margin: 20px; font-size: 15px; clear: both; border-top: dashed 1px #DDD;", body=[
      #link { text="Home", url="/"},
      " :: ",
      #link { text="Meta", url="/admin" },
      " :: Proudly Powered by luminik :: Copyright by AquarHEAD."
    ]}
  ].

blog_title() ->
  case dets:lookup(luminik_settings, blog_title) of
    [{blog_title, BlogTitle}] -> BlogTitle;
    [] -> "Just another luminik Blog"
  end.
blog_title(BlogTitle) ->
  dets:insert(luminik_settings, {blog_title, BlogTitle}).

admin_username() ->
  dets:lookup(luminik_settings, admin_username).
admin_username(AdminUsername) ->
  dets:insert(luminik_settings, {admin_username, AdminUsername}).
admin_username_str() ->
  [{admin_username, AdminUsername}] = dets:lookup(luminik_settings, admin_username),
  AdminUsername.

admin_password() ->
  dets:lookup(luminik_settings, admin_password).
admin_password(AdminPassword) ->
  dets:insert(luminik_settings, {admin_password, AdminPassword}).

to_special_string(Int) when Int < 0 ->
  RestInt = -Int,
  "n" ++ to_string2(RestInt div 10) ++ [48+(RestInt rem 10)];
to_special_string(Int) -> to_string2(Int div 10) ++ [48+(Int rem 10)].
to_string(Int) when Int < 0 ->
  RestInt = -Int,
  "-" ++ to_string2(RestInt div 10) ++ [48+(RestInt rem 10)];
to_string(Int) -> to_string2(Int div 10) ++ [48+(Int rem 10)].
to_string2(0) -> [];
to_string2(Int) -> to_string2(Int div 10) ++ [48+(Int rem 10)].

get_categories() ->
  AllCategories = dets:match_object(luminik_categories, {'_', '_'}),
  make_category_options(AllCategories).
make_category_options([]) -> [];
make_category_options([{CategoryID, Category}|Rest]) ->
  [ #option { text=Category, value=io_lib:format("~p", [CategoryID]) } | make_category_options(Rest) ].