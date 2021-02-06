@include u.i
%title 64bit環境(9kカーネル)を構築する

.revision
2016年5月6日作成
=64bit環境(9kカーネル)を構築する

	Plan 9からforkしたプロジェクトがいくつかありますが、
	ここではベル研のPlan 9と9legacyを使います。

	=ソースコードの更新

	最初に、[replica/pullを使って|
	../adm/update.w]、本家最新のソースに更新しておいてください。

	2015年1月以降、本家が更新されていないので、[9legacyのパッチ集|
	https://9legacy.org/patch.html]から取得します。
	現時点で、[64bit環境の動作が確認できたパッチ一覧|
	https://github.com/lufia/9legacy-tool/blob/master/misc/patchlist]です。
	上から順番に適用すれば依存関係も解決します。
	このリポジトリには、9legacyのパッチ管理を少し便利にする、
	簡単なrcスクリプトも含んでいますので、よければどうぞ。

	.note
	{
		9legacy-toolを使う場合、

		.console
		!% 9legacy/installall misc/patchlist
		!% 9legacy/apply

		とすれば*/sys*以下のファイルに9legacyパッチ後のファイルをbindします。
	}

	また、以下の手順では*/amd64*以下にファイルを作成しますので、
	作業するユーザはsysグループに属する必要があります。
	fossilの場合は、

	.console
	!% con -l /srv/fscons
	!prompt: uname sys +bootes

	=6cコンパイラの更新

	Runeが、2013年頃に16bitから22bitへアップデートされていますが、
	配布物に含まれる6cコンパイラのバージョンは古いままです。
	古いままだとコンパイル時に

	> runebase.c:xx illegal rune string

	と言って怒られるので先にコンパイラの更新が必要です。
	この時は、objtypeは現在使っている値(例えば386)のままで構いません。

	.console
	!% cd /sys/src/cmd/6c
	!% mk install
	!
	!# 後処理
	!% mk nuke
	!% cd ../cc
	!% mk nuke

	9legacyのパッチでアセンブラがサポートする命令も増えているので、
	アセンブラとリンカも更新します。

	.console
	!# アセンブラ
	!% cd /sys/src/cmd/6a
	!% mk install
	!% mk nuke
	!
	!# リンカ
	!% cd /sys/src/cmd/6l
	!% mk install
	!% mk nuke

	=各種ライブラリの作成

	amd64環境のコマンド等からリンクされるライブラリを作成します。
	ライブラリは、mk nukeすると
	作成された*/$objtype/lib/**.a*ファイルも消えてしまうため、
	コンパイル時の中間ファイルを掃除するのはmk cleanを使いましょう。

	.note
	objtype環境変数を切り替えると、コンパイラが生成するオブジェクトの
	ターゲットとなるアーキテクチャを切り替えられます。

	.console
	!% cd /sys/src
	!% objtype=amd64
	!% mk libs  # installとcleanを実行します

	=APE環境の作成

	gs等、いくつかのコマンドをコンパイルする時に
	ape/pcc等を使うので用意しておきましょう。

	.console
	!# apeライブラリ
	!% mkdir /amd64/lib/ape
	!% cd /sys/src/ape
	!% mk lib.install
	!% mk lib.clean
	!
	!# apeコマンド等
	!% mkdir /amd64/lib/ape
	!% mk cmd.install
	!% mk cmd.nuke
	!% mk 9src.install
	!% mk 9src.nuke

	=acme用コマンド

	ほとんどのコマンドは*/sys/src*以下にソースがありますけど、
	acme用のコマンドは*/acme/**/src*に配置されています。

	.console
	!% mkdir /acme/bin/amd64
	!% cd /acme
	!% mk install
	!% mk nuke

	=コマンド類

	ライブラリの準備ができたので、コマンドをビルドします。
	カーネルの内部に一部のコマンドを埋め込むため、
	先にコマンドのインストールが必要です。

	.console
	!% mkdir -p /amd64/bin/ ^ (aux auth dial disk fossil fs ip/httpd ndb replica upas usb venti)
	!% cd /sys/src/cmd
	!
	!# upasグループに作業ユーザを追加するか、
	!# 以下2ファイルに/tmpをbindする等で書き込み可能にしておく
	!# /mail/lib/gone.msg
	!# /mail/lib/gone.fishing
	!
	!% mk install
	!% mk nuke

	.note
	{
		9legacy-toolを使った場合、initだけはbind先に作成されてしまうので、
		mk後に手動で移動させておきましょう。

		.console
		!% unmount /amd64
		!% cp $home/9legacy/plan9/amd64/init /amd64/init
	}

	=ゲーム(不要なら飛ばす)

	.console
	!% mkdir /amd64/bin/games
	!% cd /sys/src/games
	!% mk install
	!% mk nuke

	=カーネル

	ブートローダの更新が必要なら*/sys/src/9k/boot*にソースがありますけれど、
	\*/sys/src/9*以下の内容と同じなので何もしなくても構いません。

	CPUサーバカーネルの場合は*k10cpu*コンフィグを使います。
	ただ、*k10cpu*にはsdドライバが含まれていないので*/dev/sd**/nvram*を読めません。
	通常それは困るため、sdドライバを入れましょう。

	!dev +dev
	!	root
	!	...
	!	sd		# 追加
	!
	!sd +dev	# 追加
	!	sdata	pci sdscsi
	!	sdiahci	pci sdscsi
	!...
	!rootdir
	!	bootk10f.out boot
	!	/amd64/bin/auth/factotum factotum
	!	/amd64/bin/ip/ipconfig ipconfig
	!#	../root/nvram nvram	# 削除

	最後にコンパイルして終わり。

	.console
	!% cd /sys/src/9k/k10
	!% chmod +x ../mk/mkrootall
	!% mk 'CONF=k10cpu'
	!% 9fat:
	!% cp 9k10cpu /n/9fat
	!% mk 'CONF=k10cpu' nuke

@include nav.i
