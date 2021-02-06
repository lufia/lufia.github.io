@include u.i
%title メールサーバの設定

.revision
2009年10月20日更新
=メールサーバの設定

	=各種ファイルの設定
	\*/mail/lib*以下のファイルを書き換えます。

	.note
	これらはuid=upas gid=upasなので、
	upasグループに所属させておく。

	=smtpd.conf

	smtpdの基本的な設定を書きます。
	このうち、verifysenderdomは使われてないような。。

	!defaultdomain lufia.org
	!norelay on
	!verifysenderdom off
	!saveblockedmsg off
	!ournets xxx.xxx.xxx.xxx/xx
	!ourdomains wisp.lufia.org, lufia.org

	=rewrite(rewrite.directからコピーしたものを編集)

	初期状態ではrewriteが存在しないので、
	同じ場所にある*rewrite.direct*をコピーしてそれを書き換えます。
	通常であれば、以下の部分だけ書き換えればいいと思います。

	!# your local names
	!\l!(.*)   alias   \1
	!\l\.lufia.org!(.*)  alias  \1
	!lufia.org!(.*)  alias  \1

	.note
	上記の、\l\.lufia.org!(.**)は、\lがホスト名に置き換えられます。

	=names.local

	これはエイリアスファイルです。
	最初のカラムに別名を書き、次のカラムに転送するユーザ名を書きます。
	無ければとくに変更は不要です。

	!postmaster	glenda
	!webmaster	glenda

	=remotemail

	!fd=lufia.org

	=/cron/upas/cron

	mailserverとなっている部分を実際のサーバ名で置き換えます。
	cronの書式はUnixとほとんど同じみたい。
	\*cron.daily*みたいなものはありません。

	!# kick mail retries (replace mailserver with your system)
	!0,10,20,30,40,50 * * * *	wisp		/bin/upas/runq -a /mail/queue /mail/lib/remotemail
	!
	!# clean up after grey list
	!47 4 * * *	wisp	rm -rf /mail/grey/tmp/*/*

	テストして正しく送れていれば正解。

	*user→外部
	*外部→user
	*外部→webmaster

	=メールの転送
	転送したいアドレスを*/mail/box/$user/forward*に書きます。
	1行目だけ有効で、複数に転送する場合は空白で区切って書き、
	また、メールボックスにも残しておく場合は、local!$userを加えます。

	!glenda@anonymous.com local!glenda

	=スパム対策

	Plan 9のsmtpdでは、グレーリスト法が使えます。
	listen監視下のtcp25に、-gオプションを加えるだけです。
	whitelistなど必要なファイルはインストール時において
	すでに作られているので、特に気にしなくても問題ありません。

	.sh
	!#!/bin/rc
	!#smtp serv net incalldir user
	!
	!user=`{cat /dev/user}
	!exec upas/smtpd -g -n $3

	あとは、適当なフリーメールなどから送信テストして、
	\*/mail/grey/x.x.x.x/y.y.y.y/$user*が作成されていれば完了。
	詳しくは[スパム対策|http://p9.nyx.link/spam/]を参考に。

	=Outbound Port 25 Blocking

	tcp!**!25とtcp!**!587でupas/smtpdが動いている状態を作ります。
	また、SMTP Authが必要なので、smtpdに-aオプションを与えます。

	.console
	!% cat /cfg/$sysname/service/tcp587
	!#!/bin/rc
	!user=`{cat /dev/user}
	!exec upas/smtpd -a -g -n $3

	serviceに実行権を付けたファイルを追加すれば、自動的に反映されます。
	Plan 9サーバの再起動は必要ありませんし、起動コマンドも必要ありません。

	=送信者確認の流れ(メモ)
	+upas/smtpdが/mail/lib/validatesenderをfork&exec
	+validatesenderは、データを送らないモードでupas/smtpを実行
	+送信者メールアドレスが無効の場合、upas/smtpがエラーを返す

	upas/smtpの中はだいたいこんな感じ
	+ndb/dnsquery $domain mx   =>> $hosts
	+ndb/dnsquery ^ ($hosts) ^ ip =>> 見つからなければ$hostsから削除
	+dial /net/tcp! ^ ($hosts) ^ !smtp

	=トラブルシューティング

		=外部から受信したメールがconnection timed outする
		\*/sys/log*以下の*smtpd*, *smtp.fail*, *smtpd.mx*あたりに
		connection timed outが記録されている場合。

		\*cpurc*などでndb/dns実行より前にlistenしてしまうと、
		smtpdから見える名前空間に*/net/dns*が存在しないため、
		このようなエラーになることがあります。

		この場合、*/cfg/$sysname/cpurc*で、
		listenより先にndb/dnsを動かせばいいです。

		.note
		{
			当時、困ってた時のメモ。

			デバッグのために、*/mail/lib/validatesender*から呼ばれている
			upas/smtpに-dオプションを与えたかったが、
			配布ファイルのためになるべく書き換えたくなかった。
			これはbindすればごまかせる。

			デバッグオプションを加えると、ログ(*/sys/log/smtpd.mx*)に
			>mxlookup returns nothing
			というログが出る。

			\*/proc/$smtpd/ns*をみると、
			\*/lib/namespace*から実行しているはずの
			mount -a /srv/dns /netが見当たらない。
			でもbootesからは*/srv/dns*が見える。
			パーミッションは666なので問題ない。
		}

		=IPアドレスで送受信できない

		テストのとき、メールの開通確認が終わらないうちに
		DNSが新サーバを参照してしまうと困るので、
		MXレコードには現行のサーバのIPのままにしておいて
		user@xx.xx.xx.xxのようにIPアドレスで直接テストしていたのですが、
		\*smtpd.conf*のourdomainsにIPが登録されていなかったために
		\*/sys/log/smtpd*にBad Forwardエラーが吐かれていました。
		この場合、たぶんforwardにもIP直打ち規則を登録しないといけない。

		=/sys/log/cronに、upasの転送エラーが記録される

		>upas:  can't call mailserver: cs: can't translate service

		\*/cron/upas/cron*から、
		mailserverとなっている部分をメールサーバ名に置き換えます。

		smtpdを動かすつもりがないなら、runqの行を消すか、無効にする。
		bootesからbind upascron /cron/upas/cronでも大丈夫。

		=whitelist.starterに追加しても反映されない

		ソースを読んでも使われていないようなので、
		直接whitelistに追加するといいかもしれません。
		tip9ugメーリングリストはFreeMLを使っています。
		その場合はこのように。

		.console
		!% cat >>/mail/grey/whitelist
		!210.157.23.0/24 *.gmo-media.jp
		!211.125.95.0/24 *.gmo-media.jp
		!^D

.aside
{
	=関連情報
	*[listenについて|listen.w]
	*[メール環境の暗号化|securemail.w]

	=参考ページ
	*[Plan9 System Management|http://c.p9c.info/plan9/root.html]
	*[メールに関するファイルの設定|
	http://p9.nyx.link/admin/mail/config.html]
	*[スパム対策|http://p9.nyx.link/spam/]
	*[迷惑メール対策OP25Bについてお勉強|
	http://www.drk7.jp/MT/archives/001326.html]
	*[OP25Bは迷惑メール行為を防げるのか?|
	http://suzuki.tdiary.net/20080305.html#p01]
}

@include nav.i
