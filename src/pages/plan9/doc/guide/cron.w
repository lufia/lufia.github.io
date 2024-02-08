---
title: cronの使い方
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2009年12月23日更新
=cronの使い方

	=初期設定
	設定したいユーザでログインして、以下を実行。

	.console
	!% cron -c

	これで、*/cron/$user/cron*が作られます。

.aside
{
	=関連情報
	*[メールサーバの設定|../adm/smtpd.w]
}
