@include u.i
%title httpdの立ち上げ

=httpdの立ち上げ
.revision
2011年6月2日更新

まずは、/usr/webを作ります。
fsカーネルを使っているのでそっちで書きます。

!dryad: newuser web :
!dryad: newuser web +lufia
!dryad: create /usr/web sys web 775 d

次に、/lib/namespace.httpdを編集。
特に凝ったこともしないので、内容を空にします。

!cpu% echo -n >/lib/namespace.httpd

ip/httpd/httpdはデーモン型のプログラムなので、
ふつうに/cfg/$sysname/cpustartに追加。

!ip/httpd/httpd

mimetypeの追加もしておきます。

!% ed /sys/lib/mimetype
!.xml  application  xml  -  m	# 変更
!.xslt  application  xml  -  m	# 追加

=https

以下で動きます。cert.pemの作成あたりは[メール環境の暗号化|
securemail.w]の最初をそのまま。

!ip/httpd/httpd -c /sys/lib/tls/cert.pem \
!	-n /cfg/$sysname/namespace.https -w /usr/secureweb

.aside
{
	=参考ページ
}

@include nav.i
