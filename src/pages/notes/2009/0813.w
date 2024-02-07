---
title: 自動リンク
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2009年8月13日作成
=自動リンク

2chの書き込みでリンクの張られていないURLらしき文字に
自動でリンクを張るブックマークレットを作りました。
Safariでしかテストしていません。

.js
!javascript:(function(){
!
!var a = document.getElementsByTagName('dd')
!for(var i = 0; i < a.length; i++){
!	m = a[i].firstChild
!	while(m){
!		switch(m.nodeName){
!		case '#text':
!			var s = m.nodeValue
!			var r
!			while(r = s.match(/h?t?(tp:\/\/[\x21-\x7e]+)/)){
!				var s1 = s.substring(0, r.index)
!				if(s1 != ''){
!					var t = document.createTextNode(s1)
!					m.parentNode.insertBefore(t, m)
!				}
!				var t = document.createElement('a')
!				t.href = 'ht'+RegExp.$1
!				t.target = '_blank'
!				var t1 = document.createTextNode(RegExp.$1)
!				t.appendChild(t1)
!				m.parentNode.insertBefore(t, m)
!				s = s.substring(r.index+r[0].length, s.length)
!			}
!			if(s != ''){
!				var t = document.createTextNode(s)
!				m.parentNode.insertBefore(t, m)
!			}
!			var prev = m.previousSibling
!			m.parentNode.removeChild(m)
!			m = prev
!			break
!		case 'A':
!			m.href = m.href.replace(/ime.nu\//, '')
!			break
!		}
!		m = m.nextSibling
!	}
!}
!
!})();
