---
title: 自動ログイン時のセキュリティ
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年11月4日作成
=自動ログイン時のセキュリティ

ログインが必要webサービスに、ログイン状態を保持する、
というようなオプションがありますよね。
たいてい、クッキーで実装していると思うのですが、ふと、
クッキーの値を盗聴されたら乗っ取られるのではないかなあ、と、
その実装方法とセキュリティについて疑問を持ったので、調べてみました。

「ログイン クッキー セキュリティ」で調べてた、[まちがった自動ログイン処理|
http://blog.ohgaki.net/espcs_if_a_fa_ia_a_pa_e_oa_a_sa_da_ca_sa]を
読むと、どうやらログインの度にクッキーを更新しているようです。
このあたり全く知らないので、ログインというのが言葉そのままの意味なのか
画面遷移のたびにログイン状態をチェックすることなのかは分かりませんが、
なるほどなあ、と思う反面、クッキーが更新されるまでは同じ値で
認証され続けてしまうので、セキュリティリスクは付いてくるのですね。
