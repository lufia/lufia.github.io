@include u.i
%title Plan 9カーネルのブートまわり自分用まとめ

.revision
2012年10月14日作成
=Plan 9カーネルのブートまわり自分用まとめ

	Plan 9のブートまわりは、思ったよりいろいろな動きをしていたので、
	調べた範囲でメモ。

	=ブート全体の動き

	Plan 9のブートは、カーネルだけじゃなくて、
	bootというプログラム(ソースは/sys/src/9/bootあたり)が動いています。
	bootには引数として、plan9.iniのbootargsがbargc, bargvになって渡されます。
	何をしているのかというと、最低限必要なファイルツリーを作ったり、
	factotumなど必要なプロセスを立ち上げているようです。

	もう少し細かくいうと、bootは、boot/boot.c:authenticate()の中で
	factotumを実行します。このとき、カーネルコンフィグ(CONF=pcauthとか)により
	呼び出し方法が変わります。
	具体的には、cpu/authサーバならコンフィグにcpuflagが立つのですが、
	cpuflagが立っていると、bootはfactotumを-Sオプション付きで実行します。
	その結果、factotumはサーバモードになって、nvramを読むようになります。

	また、bootが実行するfactotumには、条件は忘れましたが-aオプションにより
	plan9.iniのauth=値が認証サーバのIPアドレスとして渡されます。
	auth=がなければブート時に訪ねられます。たとえばILの場合は、
	オプションとして"-a il!xxx.xxx.xxx.xxx!566"となります。

	次に、bootはルートファイルシステムをマウントします。
	ここで面白いのは、まだルートファイルシステムを得ていないのに
	すでにbootがfactotumを実行しているのですが(もっと言えばboot自体もですね)、
	じゃあこのfactotumはどこから持ってきたのかという話。

	これは、カーネルコンフィグのbootdirセクションに挙げたファイルを、
	カーネルが最初からもってビルドされているようです。
	実際に/bootをみれば、ビルドした時点のファイルが入っているはずです。

	ルートファイルシステムのマウントに戻すと、
	bootは、plan9.iniのbootargsがlocal!で始まっていない場合、
	bootargsの値を使ってipconfigを実行し、ネットワーク設定を行います。
	次に、bootはネットワークからファイルシステムをマウントしようとします。
	ファイルサーバのIPアドレスは、plan9.iniのfs=を使って、
	もしfs=がなければブート時に入力を受け付けます。
	ファイルサーバは、それが認証を必要とするなら、マウント時に接続元へ伝えます。
	fauth()の結果が0以上なら認証が必要です。

	.note
	{
		あまり使わないと思いますが、Ken fsの場合、
		以下のコマンドで認証が不要になります。

		!fs: flag authdisable

		再度有効にしたい場合は同じコマンドをもう一度。
	}

	bootは、認証が必要と分かったので、factotumを経由してp9anyプロトコルで
	通信をはじめます。p9anyはそれ自体が認証をするわけではなく、
	どの認証プロトコルを使って認証するかを決めるためのものです。
	このプロトコルはとても簡単で、
	サーバ(この場合はファイルサーバ)が理解できる認証プロトコルをリストで返して、
	共通して使えるものをクライアント(ブート中のシステム)が選択するだけです。
	ファイルサーバをマウントする場合はだいたいp9sk1が選ばれます。
	p9sk1はPlan 9の共有鍵認証なのでまあ普通ですね。

	具体的な認証プロトコルが決まったら、p9anyはリレー状態に入って、
	あとはp9sk1が認証を行います。このあたりは、factotumのソースコードの
	p9any.c, p9sk1.cあたりに書かれています。

	.note
	plan9.iniにfactotumopts=-dと書いておくと、bootがfactotumを起動するときに
	引数として渡してくれているので、認証の動きが見れて楽しい。

	続いて、factotumはp9sk1で共有鍵認証を開始しますが、
	ブートしている対象(ファイルサーバからみて接続元)が認証サーバの場合、
	ファイルサーバは認証しろと言っているのに、認証サーバが立ち上がりきっていなくて、
	認証するための情報(/admやkeyfs)はファイルサーバにある、という状況になります。
	具体的には、(ILの場合)il566をlistenするのはcpurcの中なので、
	この時点ではまだlistenしていません。この場合、誰が認証するのか、という話。

	答えは、認証サーバとなるサーバのfactotumが、自分で認証チケットを作っています。
	認証サーバとなるべきサーバは、bootから-aオプションで渡されたIPアドレス(自分)と
	通信しますが、このときlistenをしていないので、il566はrejectします。
	なのでil.cのilrejectが呼ばれて、接続拒否されます。
	factotumは接続拒否を受けて、かつ自分自身がブート中だと判断されれば、
	自分でチケットを生成して、そのチケットで認証を行います。
	チケット生成にはサーバキーを使っているんでしょうけど、詳しくは追ってません。
	ソースコードでいうと、factotum/util.c:_authdialあたり。

	その後、9dosとかinitとかを実行して、cpurcへ進みます。

	=カーネルコンフィグ

		上でちょっと出たので、カーネルコンフィグについて少しメモ。

		=dev, link, misc, ipセクション

		普通にデバイスドライバのソースコード名。
		書けばビルド対象ファイルに含まれます。

		=bootセクション

		boot/mkboot, port/mkextractを使って、Method構造体の配列を作る。
		文字列"xx", configxx, connectxx(xxはbootセクションの各行)な関数と、
		2個目のフィールドを持つ構造体。

		Method構造体の配列は、plan9.iniに書かれているbootargsと比較して、
		bootargsの最初の'!'まで、またはMethod分だけ一致したものを使います。
		plan9.iniにnobootpromptがあれば、bootargsの代わりに
		nobootpromptの値を使います(boot/boot.c:rootserver())。

		それと、bootセクション開始行はいくつかパターンがあり、非常にわかりづらい。

		|*conf*	*cpuflag*	*bootprog*	*bootdisk*	*rootdir*
		|boot cpu		1	boot	#S/sdC0/	/root
		|boot cpu boot xxxx	1	boot	xxxx		/root
		|boot rootdir xxxx	0	boot	#S/sdC0/	xxxx
		|boot bboot		1	bboot	#S/sdC0/	/root
		|boot romboot		1	romboot	#S/sdC0/	/root
		|boot dosboot		1	dosboot	#S/sdC0/	/root
		|boot boot xxxx		0	boot	xxxx		/root

		cpuflagは、1ならfactotum -Sで動作します。

	=plan9.ini

	ブートにかかわるplan9.iniのエントリ。

	:bootargs
	-ネットワーク設定と、どこからルートをマウントするかなど
	:nobootprompt
	-bootargsに代わって、プロンプトを出さない版
	:fs
	-マウントするファイルサーバのIPアドレス
	:auth
	-認証サーバのIPアドレス
	:factotumopts
	-bootが実行するfactotumに渡すオプション
	:debugboot
	-1なら、デバッグ出力を有効にする

@include nav.i
