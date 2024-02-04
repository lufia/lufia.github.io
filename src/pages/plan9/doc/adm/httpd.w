---
title: httpdの立ち上げ
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2011年6月2日更新
=httpdの立ち上げ

まずは、*/usr/web*を作ります。
fsカーネルを使っているのでそっちで書きます。

.console
!dryad: newuser web :
!dryad: newuser web +lufia
!dryad: create /usr/web sys web 775 d

次に、*/lib/namespace.httpd*を編集。
特に凝ったこともしないので、内容を空にします。

.console
!cpu% echo -n >/lib/namespace.httpd

ip/httpd/httpdはデーモン型のプログラムなので、
ふつうに*/cfg/$sysname/cpustart*に追加。

.sh
!ip/httpd/httpd

\*mimetype*の追加もしておきます。

.console
!% ed /sys/lib/mimetype
!.xml  application  xml  -  m	# 変更
!.xslt  application  xml  -  m	# 追加

=https

以下で動きます。*cert.pem*の作成あたりは[メール環境の暗号化|
securemail.w]の最初をそのまま。

.sh
!ip/httpd/httpd -c /sys/lib/tls/cert.pem \
!	-C /sys/lib/tls/chain.pem \
!	-n /cfg/$sysname/namespace.https \
!	-w /usr/secureweb

.aside
{
	=参考ページ
}
