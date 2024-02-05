---
title: ファイルサーバを読む
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年5月17日更新
=ファイルサーバを読む

	=ブロック

	以下でいうブロックとは論理ブロックで、
	特定の場合を除いて、ディスクの物理ブロックとは異なります。
	キャッシュもWORMも同じ大きさで8KB。

	=チャネル

	ファイルサーバに9pで接続しているコネクション。
	ファイルサーバのコンソールも含みます。

	=バッファ

	ディスクブロックにアクセスする際、
	ファイルサーバは必ずバッファを通して読み書きします。
	getbufはデバイスとアドレスを取り、
	それのバッファを用意してロックします。
	putbufはその逆です。

	Cache-WORMデバイスの場合は、
	キャッシュディスクにWORMのデータを読み込んだり、
	dumpの時にキャッシュのデータをWORMへ反映したりします。
	バッファの詳細は下のほうで。

	=デバイス

	:Cache-WORM(cw)
	-キャッシュとWORMを両方持つデバイス
	:dump(ro)
	-9fs dumpしたときに見えるデバイス(2011/0411とか)
	-リードオンリー
	:Cache(c)
	-キャッシュ
	:WORM(w)
	-WORM
	-だいたいCache-WORMの一部分

	別の記事で[fsバックアップメモ|../2010/0705.w]も参考に。

	=アドレス

	ファイルサーバのなかで管理しているアドレスは、
	デバイスごとに違うものとして扱われます。
	なので、getbuf(cw, 2)をマップした結果、
	そのキャッシュブロックアドレスが10としても、
	それとgetbuf(c, 10)は異なるアドレスとして扱われます。

	=アドレス変換

	Cache-WORMデバイスを扱う場合は、
	WORMアドレスからキャッシュのデータブロックへマップするため、
	アドレス変換が発生します。
	このとき、getbufに与えるアドレスはWORMアドレスです。

	詳細は[ファイルサーバのディスクレイアウト|04282.w]に。

	=データ構造

		=ブロックアドレス関連の定数

		:CACHE_ADDR
		-Cacheディスク構成情報などが配置されるブロックアドレス
		-2
		:SUPER_ADDR
		-WORMにある最初のスーパーブロックアドレス
		-2
		:ROOT_ADDR
		-WORMのルートブロックアドレス
		:RBUFSIZE
		-論理ブロックの大きさ
		-具体的には8KB(8192)
		:BUFSIZE
		-RBUFSIZEからタグのぶんを除いた、データを持てる大きさ
		-BUFSIZE+sizeof(Tag) == RBUFSIZE
		:BKPERBLK
		-1つのブロックに含まれるBucket数
		-10
		:CEPERBK
		-Bucketに含まれるCentry数
		-だいたい50
		:ADDFREE
		-grow時に増えるWORMブロック数
		-100
		:DIRPERBUF
		-1論理ブロックに保存できるDentry数

		=ブロックの種類

		:Tfile
		-ファイル
		:Tdir
		-ディレクトリ
		:Tsuper
		-WORMのスーパーブロック
		:Tind1
		-1段目の間接参照ブロック
		-2段目、3段目はTind1+1, Tind1+2となる
		:Tfree
		-フリーリスト
		:Tbuck
		-キャッシュディスクのマップブロック

		=ブロックの状態

		:Cread
		-WORMに書き込み後、変更がまだないブロック
		:Cwrite
		-WORMに書き込み後、変更のあったブロック
		:Cdirty
		-新しく確保されたブロックで、WORMにもない
		:Cdump
		-dumpキューに入っているブロック
		:Cdump1
		-dumpエラーのブロック?
		:Cnone
		-未確保

		=Centry

		WORMアドレスとキャッシュディスクのブロックを関連付けするもの。
		詳細は下のほうに。

		:waddr
		-WORMブロックのアドレス
		:state
		-ブロックの状態

		=Bucket

		Centryの配列を持つ。
		これが1ブロックにBKPERBLK個数格納される。
		このあたりは[ファイルサーバのディスクレイアウト|
		04282.w]を参照。

		=Cache

		キャッシュの状態と、一部、WORMの状態を持つ。
		常にキャッシュディスクのCACHE_ADDRに置かれる。

		:msize
		-Bucket数
		-msizeとなっているがブロック数ではない
		:maddr
		-マップ領域(Bucket)の開始アドレス
		-常にCACHE_ADDR+1 = 3
		:caddr
		-データ領域の先頭ブロックアドレス
		:csize
		-キャッシュディスクの使用可能なfs論理ブロック数
		-マップ領域分(msize/BKPERBLK)は含まない
		:sbaddr
		:cwraddr
		:roraddr
		:next
		:fsize
		:wsize
		-これらはSuperbの同名変数と同じ値を維持している

		=Superb

		WORMに保存されるスーパーブロック。

		:last
		-そのSuperbからみて前回のスーパーブロックアドレス
		-最初は2
		:cwraddr
		-ルートブロックのアドレス
		-最初は3
		:roraddr
		-dumpデバイスのルートアドレス
		-最初は4
		:next
		-次のスーパーブロックアドレス
		-最初は5
		:fstart
		-2
		:fsize
		-使用中WORMブロック数
		-最初は6
		-fsgrow()のときにADDFREEだけまとめて増える
		-dumpのときにもCwriteブロックの場合に1増える
		:wsize
		-WORMブロック数
		:fbuf
		-フリーブロック

		=Fbuf

		フリーブロックアドレスの配列。
		新しいブロックが割り当てられる(Cdirty)時に後ろから使われる。

		これがFEPERBUFを超えると、超えたFbufをブロックへ書き、
		新しいフリーブロックの先頭に書きこんだアドレスを設定する。
		このため、間接参照みたいな扱いになる。
		このときのtagはTfree。

		:nfree
		-ブロックの個数
		:free
		-フリーブロックのアドレス配列
		-0のみ特別

		=Cw

		キャッシュWORM

		:fsize
		-dumpのときに共有変数っぽく使う
		-意味はCacheなどのそれと同じ
		:daddr
		-dump対象となったブロックアドレスっぽい

		=Wren

		物理的な磁気ディスク。

		:nblock
		-SCSI論理ブロック数
		:block
		-SCSIブロック長
		-単位はバイト
		:mult
		-RBUFSIZEを確保するのに必要なSCSI論理ブロック数
		:max
		-最大ブロック数
		-ブロックのサイズはRBUFSIZE

		=Iobuf

		各種ブロック操作を行うときに使うバッファ。
		getbufにより空いているバッファがロックされ使用中になり、
		putbufによってロック解除され未使用状態に戻る。

		:addr
		-WORMアドレス
		:dev
		-デバイス
		:flags
		-BmodとかBreadとかのフラグ
		-これはputbufで処理(キャッシュに書き込むなど)
		:iobuf
		-各種操作を行うためのバッファ
		-Iobufが使われていない場合はnilになっている
		-read/writeなどで使う
		:xiobuf
		-実際のバッファ
		-事前にメモリを確保していて、iobufmapによりこれをiobufへ設定

		=Dentry

		ディレクトリエントリ。
		直接ブロック6個、間接ブロック4個などの情報が保存されている。
		fs64の場合、1つのブロックに47個入るらしい。

		ディレクトリがブロックをまたいで分断されることはない。
		なので(mode&DDIR)なら、
		dblock[[0]]もdblock[[1]]もgetdir(block, i)が使える。

		:mode
		-パーミッション
		:dblock
		-直接ブロックのアドレス配列
		:iblocks
		-間接ブロックのアドレス配列
		:slot
		-バッファ中のインデックス
		-同じ親ディレクトリでも、ブロックが異なればまた0からはじまる

		=File

		オープンファイル。
		詳細は[fsオープンファイルの管理|0516.w]を参照。

		:cp
		-ファイルを扱っているチャネル
		-未使用ならnil
		:wpath
		-親ディレクトリを指すリスト
		:addr
		-ファイルのDentryが保存されているブロックアドレス
		:slot
		-ファイルのDentry中で、何番目のDentryかを指すオフセット

		=Wpath

		オープンファイルについて、その親ディレクトリを指す。

		:up
		-さらに上位ディレクトリ
		-Wpathが/の場合はnil
		:refs
		-参照カウント
		:addr
		:slot
		-Fileのそれと同じ

		=グローバル変数

		:flist
		-オープンファイルのリスト
		:sdevs
		-たぶんディスクコントローラ

	=各種操作

		=バッファ

		ファイルサーバは、ディスクのブロックにアクセスする場合、
		getbufとputbufを使って、必ずバッファを通して扱います。

		.c
		!getbuf(dev, addr)

		単純にするため引数を一部省略していますが、getbufは、
		デバイスとWORMアドレスを使ってバッファを使用可能にします。
		必要ならWORMからバッファへ読み込んだりもします。
		次のはあくまで疑似コード。実際は全然違うけど雰囲気だけ。

		.c
		!mem: array of list of ref Iobuf
		!
		!getbuf(dev: ref Device, addr: Off): ref Iobuf
		!{
		!	list = mem[hash(addr)].find(a => !a.used);
		!	c = list.find(a => a.dev == dev && a.addr == addr);
		!	if(c == nil)
		!		c = list.last;
		!	lock(c);
		!	c.dev = dev;
		!	c.addr = addr;
		!	必要なデータの準備(c);
		!	return c;
		!}

		必要なデータの準備のところで、
		実際にブロックへ読み書きをします。
		Cache-WORMデバイスの場合は以下のように呼び出しします。

		.c
		!getbuf(cw->dev, up->addr, Bread|Bmod)
		!devread(cw->dev, up->addr, buf)	# 0なら正常終了
		!cwread(cw->dev, up->addr, buf)
		!cwio(cw->dev, up->addr, buf, Oread)

		ここから下はふつうにSCSIコマンド。

		=ream

		Cache, Superb, 2つのルート(cwとro)を設定します。
		これも[fsバックアップメモ|../2010/0705.w]のほうに。

		=grow

		必要に応じてWORMの容量を増加させます。
		増加したブロックは、フリーブロックリストに移ります。

		.c
		!cwgrow: fn(dev: ref Device, sb: ref Superb, uid: int): int
		!{
		!	h: ref Cache;
		!	h = getbuf(CDEV(dev), CACHE_ADDR, ...);
		!	h.fsize += ADDFREE;
		!	if(h.fsize >= h.wsize)
		!		h.fsize = h.wsize;
		!
		!	sb->fsize = h.fsize;
		!	for(waddr in 増えたブロックについて){
		!		cwio(dev, waddr, 0, Ogrow);
		!		addfree(dev, waddr, sb);
		!	}
		!}

		=remove

		ファイルを削除したとき、
		そのファイルが使用しているブロックをみて、
		それがCdirtyならフリーリストへ戻します。
		Cwriteなどの場合は再利用すると整合性が取れなくなるので、
		フリーリストへは戻しません。

		=recover

		いちばん新しいdumpの状態に戻します。
		実際の動きは[fsバックアップメモ|../2010/0705.w]を参照。

		=dump(queue)

		ファイルサーバは朝5:00に、
		その時点のバックアップをWORMへ書き込むのですが、
		それは変更のあったブロックをdumpキューへ入れる部分と、
		キューのブロックを実際に書き込む部分に分かれています。
		ここではキューに入れるところについて。

		まず、ファイルサーバは、ファイルの操作ができないように
		全体をロックします。
		変更のあったブロックは必ずキャッシュに残っているので、
		キャッシュディスクから変更のあったブロックをみて、
		その状態をCdumpに書き換えます。
		ここで、実際はデータ領域ではなくマップ領域をみて、
		そのブロックが変更されていなければ飛ばします。

		変更のあったブロックで、その状態がCwriteの場合、
		新しいブロックアドレスを割り当てます。
		これはフリーブロックを使いません。
		WORMディスクの容量(fsize)を増やしながら割り当てます。

		.c
		!na = cw->fsize++
		!cwio(cw->dev, na, 0, Ogrow)
		!cwio(cw->dev, na, p->iobuf, Owrite)
		!cwio(cw->dev, na, 0, Odump)
		!cwio(cw->dev, addr, 0, Orele)

		Cdirtyの場合はまだ未使用なのでそのままです。

		!cwio(cw->dev, addr, 0, Odump)

		この再割り当てはcwrecur関数が処理しています。
		これは深さ優先で探索するので、
		深い場所のほうが小さいアドレスになるみたい。
		で、どこかに変更があった場合はrootがwriteになっているので、
		最後の戻り値が新しいルートの値(最大アドレス)となっている。
		ちなみに、cwrecurの戻り値は、変更がなければ0。

		アドレスの再割り当てが終わったら、
		rewalk関数により、オープンファイルが
		持っているアドレスを新しいアドレスに更新して、
		サーバの処理を再開します。

		.note
		{
			OreleとOfreeの違いは、

			:rele
			-writeならnoneに
			:free
			-writeまたはreadならnone
		}

		=dump(copy)

		キューに入れられたブロックについて、
		その内容をWORMに書き込むプロセスをwcpといいます。
		これは朝5:00に限らず動いていて、
		ブロックの状態がCdumpのものを
		小さいアドレスから順に探して書き込みます。
		その処理はdumpblock関数あたり。

		全部処理が終われば、cw->>nodump = 1として停止。
		次にdumpキューへ入れられればまたnodump = 0となり
		プロセスが活性化します。

	=メモ

		=SCSIドライバのロード

		pc/scsi.cに、名前と関数(reset)を登録するテーブルがある。
		これをpc/scsi.c:scsiinitから調べて、
		一致すれば関数の戻り値をコントローラ構造体のioに入れる。
		関数(reset)は、scsiの入出力を処理する関数(Scsiio)を
		返すようになっているので、
		デバイスドライバ依存の処理は全部これを通して扱うみたい。
		ちなみに同名の関数がいくつかあるけど、#ifdef FSのものが有効。

.aside
{
	=関連ページ
	*[ファイルサーバのディスクレイアウト|04282.w]
	*[fsバックアップメモ|../2010/0705.w]

	=参考サイト
	*[cwfsの研究|http://plan9.aichi-u.ac.jp/cwfs/]
}
