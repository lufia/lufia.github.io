@include u.i
%title document.writeのリダイレクト

.revision
2009年10月30日作成
=document.writeのリダイレクト

リダイレクトといってもHTTPのそれではなくて。

探してみると、いろいろなブログパーツが配布されていて楽しいのですが、
さて使うとなるとdocument.writeでベタ書きされているために
使いどころが難しいものが多い気がします。
原因は分かりませんがJavaScriptで動的に追加した場合に動きませんでしたし、
少なくともapplication/xhtml+xmlにおいては、
仕様としてdocument.writeは使えません。

そこで、document.writeの結果を文字列で返せれば便利かなあと考えました。

.js
!function wrap(write)
!{
!	var orig = document.write
!	var cout = ''
!	document.write = function(s){
!		cout += s
!	}
!	write()
!	document.write = orig
!	return cout
!}
!
!$(function(){
!	var s = wrap(function(){
!		writeSqexAvatarTag('', '', '', '', 'xxx')
!	})
!	$('aside>*:first').before(s)
!})

誰かが作っていてもおかしくないと思うのですが、
HTTPのリダイレクトばかり引っかかりやがります。

@include nav.i
