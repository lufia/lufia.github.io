---
title: CSSをJavaScriptから扱う場合のメモ
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2006年12月22日作成
=CSSをJavaScriptから扱う場合のメモ

JavaScriptでもう1つのサイトのほうを新しくしているのですが、
テスト環境ではうまくいくのに、実際のサイトに適用させると
style.leftとstyle.topが設定されない(空文字列になる)現象が発生しました。
IE7だと問題なく、Sylera(Gecko)だと空文字です。

この現象が、どのような状況で発生するか調べてみると、
どうやらHTMLファイルにDOCTYPE宣言があるものだと空文字列、
なければ数値に設定されるようです。

なんでも、Geckoエンジンには超厳密モードというのがあり、
そのモードでは、style.left等は単位をつけないと不正な値とみなされるようです。
今回はそれに引っかかったみたいでした。pxをつけてやると正しく動きました。
