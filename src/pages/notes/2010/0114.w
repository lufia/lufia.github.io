---
title: Ciscoメモ
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2010年1月14日作成
=Ciscoメモ

	まず接続できなくて詰まった。
	最初はipが割り当てられていないので、付属のケーブルをAuxポートに接続。

	.note
	Vistaはハイパーターミナルが無いので、TeraTermからシリアル接続。

	!Would you like to enter the initial configuration dialog? [yes/no]: no

	yesを選んでも分からないためnoを選んだ。
	初期化の方法は[ルータの工場出荷時のデフォルト設定へのリセット|
	http://www.cisco.com/JP/support/public/ht/tac/100/1007902/factory-default-j.shtml]。

	=VLANを作成できない
	851Wは1つしかVLANを扱えません。

	=HTTP通信が途中で止まる
	フラグメントパケットを拒否している場合、
	ip tcp adjust-mssでパケットサイズを指示する。
	たぶんインターフェイスごとにしないといけない。

	!ip tcp adjust-mss 1454

  		=参考リンク
		*[MTUの謎|http://www.ne.jp/asahi/welcome/netland/newpage0840.htm]

	=DNS引けない問題
	Windowsでは.を含まないホスト名は名前解決しない。
	含まない場合、name.とするといける。

	=ドメイン名問題
	*[家庭内クライアントからドメイン名やグローバルIPアドレスでアクセスできない|http://www.aconus.com/~oyaji/faq/apache_html3.htm]

	うーん、Plan 9でDNSサーバ立てるかな？
	DNS自動取得など、ルータでやったほうが便利な気がするけど。

	.note
	{
		!ip name-server xx.xx.xx.xx

		これを、以下に置き換え。

		!ppp ipcp dns request
	}

	=SSIDステルス

	>アクセスポイントに指定できるゲストモードSSIDは1つ、またはゼロです。
	>ゲストモードSSIDは、ビーコンフレームと、
	>空のSSIDまたはワイルドカードSSIDを指定した要求をプローブする応答フレームで使用されます。
	>ゲストモードSSIDが存在しない場合、ビーコンにはSSIDが含まれず、
	>ワイルドカードSSIDが含まれるプローブ要求は無視されます。

	>ゲストモードを無効にすると、
	>ネットワークのセキュリティが多少向上します。

	>ゲストモードを有効にすると、
	>パッシブスキャン(送信しない)を実行するクライアントが
	>アクセスポイントにアソシエートしやすくなります。
	>また設定時にSSIDが指定されていないクライアントも
	>アクセスポイントにアソシエートできるようになります。

	!guest-mode

	=CBAC

		=CBACとUDP
		UDPは、セッションは存在しないが、
		擬似的にセッションがあるものとして扱う。

		=CBACの適用順序
		+通常のACL
		+CBAC

		この順で評価される。
		このため、ACLで拒否されているものはCBACの対象とならない。

.aside
{
	=Cisco日本語マニュアル
	*[Cisco 800シリーズ|http://www.cisco.com/japanese/warp/public/3/jp/service/manual_j/index_rt_800.shtml]
	*[ACLとIPフラグメント|http://www.cisco.com/JP/support/public/mt/tac/100/1000528/acl_wp.shtml]
	*[IPアドレッシングサービス|http://www.cisco.com/JP/support/public/nav/lll_268435930_10_236.shtml]
	*[GREトンネルを使用しているときにインターネットをブラウズできない理由|http://www.cisco.com/JP/support/public/ht/tac/100/1007842/56-j.shtml]

	=PPPoE
	*[GREの設定|http://www.infraexpert.com/study/rp8gre2.htm]
	*[Cisco IOSによるルータ設定|http://www.syns.net/7/4/]

	=よさげな情報
	*[Cisco1812Jで行こう！|http://kumo.chicappa.jp/wiki.cgi?page=Cisco1812J%A4%C7%B9%D4%A4%B3%A4%A6%A1%AA]
	*[Cisco 1712 Auto Secure 設定|http://ripo726.blog41.fc2.com/blog-entry-258.html]

	=メモ
	:[Ciscoルータでフレッツ光プレミアムに接続できない事象|http://www.kaztan.com/network/archives/2008/03/29-234543.php]
	-MRUを設定する場合はip mtuではなくmtuを使う

	=関連情報
	*[無線LANのセキュリティ|../../notes/2009/1019.w]
}
