@include u.i
%title 時計合わせ

.revision
2006年9月4日更新
=時計合わせ

	=timezoneの変更

	\*/adm/timezone/local*を、各地域のファイルで上書きします。
	admグループの権限が必要になります。

	.console
	!% cp /adm/timezone/Japan /adm/timezone/local

	=sntpから時刻を受信

	aux/timesyncを使えばいいです。

	.sh
	!# ローカルの時間に合わせる場合
	!aux/timesync -rL
	!
	!# sntpサーバを指定する場合
	!aux/timesync ntp.domain.dom
	!
	!# ファイルサーバの時刻にあわせる場合
	!aux/timesync -f
	
	fオプションとデフォルト動作の違いがいまいち分かりません。

	.note
	{
		ファイルサーバの時刻に合わせるというのは、
		何か特別に通信するわけではなく、
		単純に、*/*を開いて、そのアクセス時刻を調べているだけです。
		なので、ファイルサーバにあわせる場合は、
		必ずfsカーネルのtimezoneを変更しておきます。
		そうしないと17時間進んでしまいますし、
		対処療法として*/adm/timezone/local*を-22800と変更しても、
		メールの送信時刻が17時間ずれたままです。

		これは、なぜ17時間なのかよく分かりません。
		upas/marshalによって作られるヘッダ

		!Date: xxxxxx -8

		これとtimezoneのJSTが関係してそうですが。。
	}

	=fsカーネルのtimezone変更

	fs64/fs64.cから、以下2つの値を変更してコンパイル。
	これをしないと、dumpが22:00にスケジュールされてしまいます。

	.c
	!conf.minuteswest = -9*60;
	!conf.dsttime = 0;

	ファイルサーバのRTCをGMTに調整(日本時間-9)して、
	新しいカーネルでブート。
	このとき、fsがすでに稼働中だったのですが、
	新しいカーネルに切り替えてもファイルシステムの整合性が取れないといって
	異常終了するようようなエラーは無かったです。

	.note
	{
		時刻周りのデータと関数について調べてみました。

		=fsカーネルのデータ構造

		:mktime
		-カーネルのコンパイルされた時間
		-versionコマンドで表示可能
		:toytime()
		-mktime + ファイルサーバをブートしてからの時間
		:Time.bias
		-げた
		-dateコマンドで+Nとして表示される
		:Time.offset
		-コンパイル時間からブートタイムまでの差分
		-now - lasttoy
		:Time.lasttoy
		-最後に調べたtoytime()の結果
		:time()
		-Timeから計算した現在時刻を返す
		:settime(t)
		-tとtime()の差分を、bias, offsetに反映する
		:rtctime()
		-RTCの値を返す
		:setrtc(t)
		-settime()と似ている
		-RTCに保存する(BIOS時刻を更新する)
		:conf.minuteswest
		-GMTからの差分
		-fs64の初期値では、8**60となっている
		-日本時間にするには-9**60
		:conf.dsttime
		-サマータイム有無
		-fs64の初期値 = 1(あり)
		:localtime()
		-dateで表示する時刻
		-time() - conf.minuteswest**60

		=各データ更新のタイミング

		:ブート時
		-settime(rtctime())
		:date [[+-=]] xxxx
		-settime(xxxx)
		-setrtc(xxxx)
		:sntpから時刻が届いたとき
		-settime(sntp)
		-setrtc(sntp)
	}

	=fsカーネルのsntpサーバ設定

	configモードで、ipsntpを使います。

	.console
	!config: ipsntp xxx.xxx.xxx.xxx

	1時間に1回、自動的に確認を行い、
	正しく受信すると、コンソールにログが流れます。

	!sntp 1254076626
	!sntp 1254080226
	!sntp 1254083826

	また、sntpコマンドを使えば、手動でも動きます。

	.console
	!dryad: sntp kick
	!sntp 1254076819

	=トラブルシューティング

		=timesyncが延々と終わらない

		aux/timesyncにデバッグオプションを与えた場合には、
		timesyncはその場合に限り[fork(2)]しないので、
		延々とカレントで実行を続ける。

.aside
{
	=参考ページ
	*[時刻合わせ|http://p9.nyx.link/admin/timezone.html]
}

@include nav.i
