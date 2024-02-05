---
title: Disqus解除
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年10月30日作成
=Disqus解除

Disqusというサービスを一時的に使っていましたが、
好みのレイアウトにするのが意外と大変ということと、
ページの読み込みがもっさりするという理由で外しました。

とりあえず使い方のメモだけでも残しておきます。
HTMLには一切手を入れず、JavaScriptだけで
必要なタグを追加するようにしています。

以下jQueryに依存していますので、HTMLのヘッダで取り込んでおいて。

.html
!<script src="jquery.js"></script>

まず中心となる関数から。

.js
!function disqus(sname)
!{
!	var name = encodeURIComponent(sname)
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

使うときは、少々手間ですが4行ほど書きます。

.js
!disqus_url = location.href
!if(disqus_url.search(/\/$/) >= 0)
!	disqus_url += 'index.html'
!disqus('shortname')

これは、Disqusは通常window.locationをキーとして扱いますが、
このときindex.htmlのあるなしで別のページとして扱われてしまいます。
それでは困りますので、調整しているわけですね。

.note
細かいことを気にすれば、/path/#idstring等も考えられますが、
使っていませんでしたので気にしていません。
