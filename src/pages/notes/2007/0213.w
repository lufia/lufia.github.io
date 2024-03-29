---
title: divの山はどうにもならないんでしょうか
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2007年2月13日作成
=divの山はどうにもならないんでしょうか

基本的にはXHTML1.1で書く人ですが、デザインを考えるときには
とても使いやすいとはいえません。これ。
でも、XHTML+CSSで書くとソースの見通しがよくなるので使っています。

さてさて、画面デザインするとき、
綺麗なサイトのソースを眺めてまわったりするのですが、
XHTML+CSSでデザインされたページではdivとclass属性がよく使われます。

.html
!<div class="line">
!	<div class="left">
!	左コンテンツ
!	</div>
!	<div class="right">
!	右コンテンツ
!	</div>
!</div>
!...

これってどうなんでしょう。HTMLからデザインを切り離すために
CSSを使っているのに、CSSを使うためにdivを使っているというのはなんだか。
こうするのがいちばん簡単なのは分かるけど。
