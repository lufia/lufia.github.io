@include u.i
%title MobileMeでブックマークが同期しない

=MobileMeでブックマークが同期しない
.revision
2009年11月5日作成

iPhoneでMobileMeを使って同期しているのですが、
どうにもブックマークの同期がうまくいかなくて困る。
現象をみていると、通常使ってるぶんにはまったく同期せず、
iPhoneの電源を入れ直せば、そのときだけ同期されるようです。

うーん。[MobileMeによる同期|
http://chao16.seesaa.net/pages/user/iphone/article?article_id=103164705]
を読むと、UPnP、NAT Traversalに対応していないルータの下では
プッシュができないという情報があり、そのポート([Apple Discussions|
http://discussions.apple.com/thread.jspa?messageID=10246721]より)は
確かに開いていませんでした。以下に引用します。

!wap-push 2948/udp # WAP PUSH
!wap-push 2948/tcp # WAP PUSH
!wap-pushsecure 2949/udp # WAP PUSH SECURE
!wap-pushsecure 2949/tcp # WAP PUSH SECURE
!
!simple-push 3687/udp # simple-push
!simple-push 3687/tcp # simple-push
!simple-push-s 3688/udp # simple-push Secure
!simple-push-s 3688/tcp # simple-push Secure
!
!wap-push-http 4035/udp # WAP Push OTA-HTTP port
!wap-push-http 4035/tcp # WAP Push OTA-HTTP port
!wap-push-https 4036/udp # WAP Push OTA-HTTP secure
!wap-push-https 4036/tcp # WAP Push OTA-HTTP secure

しかし不思議なのは、3Gネットワークでも同期されないのですよねえ。。。

.aside
{
	*[Push Notificationの実装方法|
	http://iphone.longearth.net/2009/09/01/]
}

@include nav.i
