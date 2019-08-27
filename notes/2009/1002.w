@include u.i
%title DISQUS導入テスト

=DISQUS導入テスト
.revision
2009年10月2日作成

更新ミスなどがあったとき、すぐ直せる場合はいいのですが、
そうでないとき、忘れてしまうことが多いので、
コメント機能を使ってみることにしました。

とりあえず表示まではできたのでここにメモ。
全部JavaScriptで完結する形でまとめています。
このためだけに無駄なdiv要素を用意するなんてばからしいしね。

基本的に[MovableTypeコメントをDISQUSに置き換えてFacebook Connect対応|
http://blog.matake.jp/archives/_disqus]を参考に、
jQueryを使って省略してみたり、divまで動的生成してみたりしています。

以下ソース。

!function disqus(shortname)
!{
!	var name = encodeURIComponent(shortname)
!	$('footer').after('<div id="disqus_thread"></div>')
!	var disqus = 'http://disqus.com/forums/'+name
!	var q = ''
!	$('a[href$=#disqus_thread]').each(function(i, a){
!		q += '&url'+i+'=' + encodeURIComponent(a.href)
!	})
!	var url = disqus + '/get_num_replies.js?' + q.substring(1)
!	$('head').append('<script src="'+url+'"></script>')
!	disqus_no_style = 1
!	$('head').append('<script src="'+disqus+'/embed.js'+'"></script>')
!}

これを、onloadイベントなどで呼び出せば、footer要素の後に追加されます。

!$(function(){
!	disqus('shortname')
!})

当面の問題は、どこに置くかだなあ。
現状footerの前に置いていますが、うーん。
かといってfooterにはセクショニングコンテンツは置けないし、
articleの末尾でもないしなあ。。。

@include nav.i
