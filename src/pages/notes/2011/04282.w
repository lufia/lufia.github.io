---
title: ファイルサーバのディスクレイアウト
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年5月13日更新
=ファイルサーバのディスクレイアウト

	=キャッシュディスク

	キャッシュディスクは、ディスクの構成、
	データブロックとWORMアドレスをマップする領域、
	データ領域の3つに大きく分かれます。

	マップ領域とデータ領域の容量は、
	ディスク全体容量によって自動的に構成されます。
	それを実際に計算しているのはcacheinit()関数。

	\<キャッシュディスクのレイアウト|04282.png>

	!0:
	!1:
	!2: Cacheな情報が入っている; cacheinit()で設定
	!3..M: マップ管理領域; Mはcaddr-1で、だいたいmaddr+msize/BKPERBLK
	!N...: データ領域; Nはcaddrで、あとはだらだら続く

	.note
	インデックス領域のタグはTbuck

	Limbo風に書くと、ざっくりこんな雰囲気。

	.c
	!CacheDisk: dt
	!{
	!	h: Cache;
	!	map: array[M] of array[BKPERBLK] of array[CEPERBK] of Centry;
	!	block: array[M*BKPERBLK*CEPERBK] of Block;
	!
	!	get: fn(addr: big): ref Iobuf;
	!}

	マップアルゴリズムは、対象となるWORMアドレスのハッシュを取り、
	そのハッシュでマップ領域のブロックとBucketインデックスを決定します。
	次に、Bucketのなかをみて、空いているCentryを探します。
	Centryが定まれば、対応するデータ領域のアドレスは
	単純な式で計算できます。いろいろ省略してこんな感じ。

	.c
	!h = (Cache*)getbuf(cw->cdev, CACHE_ADDR);
	!bn = addr % h->msize;			// Bucketインデックス
	!a1 = h->maddr + bn/BKPERBLK;		// Bucketが格納されているアドレス
	!p = (Bucket*)getbuf(cw->cdev, a1)->iobuf;
	!b = &p[bn%BKPERBLK];
	!c = getcentry(b, addr);
	!a2 = bn*CEPERBK + h->caddr;		// addrのデータ領域ブロックアドレス
	!a2 += c - b->entry;			// オフセットを加算して一意に
	!data = getbuf(cw->cdev, a2);

	=WORMディスク

		=ディレクトリレイアウト

		\<一般的なファイル図|04282-3.png>

		図は、一般的なファイル1つ(Dentry[[2]])を表現したものです。
		このあたりはほとんどUNIXファイルシステムと同じみたい。
		この図で、Dentry[[2]]がファイルの場合、
		Block[[4]]とBlock[[7]]にはファイルの内容が格納されています。
		または、Dentry[[2]]がディレクトリの場合、
		上図と同様にDentryの束が格納されます。
		ブロック中のDentry数は決まっているので、
		途中でブロックをまたがることはありません。

		Dentry[[2]]を削除すると、そのブロックから
		DALLOCフラグが消えて未割当てな状態になります。
		空きができますが、そのままです。詰めません。

		.note
		ブロックレイアウトからみれば、
		ディレクトリの途中で空きができますが、
		9pで読むときに、f_read関数が空きを見せないようになっています。

		Dentryの左下にある数字はslotと呼ばれます。
		これは、ブロック中の何個目にあるエントリかを表します。
		複数ブロックにまたがるほど大きなディレクトリの場合では、
		次のブロックになるとまた0からはじまります。

		=最初の状態

		以下はream後のWORMレイアウト。

		.c
		!0:
		!1:
		!2: super addr(tag:Tsuper, state=Cdump)
		!@Superb{
		!	last = 2,
		!	cwraddr = 3,
		!	roraddr = 4,
		!	next = 5,
		!	fstart = 2,
		!	fsize = 6,
		!	fbuf = { nfree = 1, free = [0] }
		!}
		!3: cw root(tag:Tdir, state=Cdump)
		!@array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!4: ro root(tag:Tdir, state=Cdump)
		!@array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!5: next sb

		頭に@がついているものは、
		キャッシュのみ変更があったということです。
		なので、この時点ではWORMには何も書き込まれていない。

		=初回dump

		これは朝5:00の定期dumpではなく、ream直後に起こります。

		.c
		!0:
		!1:
		!2: super addr(tag:Tsuper, state=Cread)
		!Superb{
		!	last = 2,
		!	cwraddr = 3,
		!	roraddr = 4,
		!	next = 5,
		!	fstart = 2,
		!	fsize = 6,
		!	fbuf = { nfree = 1, free = [0] }
		!}
		!3: cw root(tag:Tdir, state=Cread)
		!array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!4: ro root(tag:Tdir, state=Cread)
		!array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!5: next sb

		\<WORMのレイアウト|04282-1.png>

		=WORMディスクの伸長

		最初は小さいディスク(6ブロック)です。

		新しいブロックが使われるときはフリーリストから取ります。
		フリーリストがなくなればディスクのまとめて伸ばし、
		伸びただけフリーリストを確保します。
		また、既存のブロックが更新された場合は、
		dumpの際にディスクを1ブロックだけ伸ばして割り当てます。
		このとき、フリーリストが残っていても使いません。
		使用状況に応じて、WORMディスクを拡張(grow)します。

		ファイルを削除すると、そのブロックはフリーリストに戻ります。
		メモ: Cdirtyの場合だけ?

		.note
		上で、freeの先頭に0が入っているのは、
		残り0でアドレスが0なら空き無しと判断しgrowするためみたい。

		=ファイルの作成

		create /adm/usersすると、新しいブロックが割り当てられて
		ファイルが作られます。空きがなければgrowが起こります。
		以下はgrowした後、/adm/usersを作り終わった場合。

		.c
		!0:
		!1:
		!2: super addr(tag:Tsuper, state=Cwrite)
		!@Superb{
		!	last = 2,
		!	cwraddr = 3,
		!	roraddr = 4,
		!	next = 5,
		!	fstart = 2,
		!	fsize = 106,
		!	fbuf = { nfree = 99, free = [0,105,104...8] }
		!}
		!3: cw root(tag:Tdir, state=Cwrite)
		!@array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0,
		!	dblock = [6]
		!}
		!4: ro root(tag:Tdir, state=Cread)
		!array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!5: next sb
		!6: /(tag:Tdir, state=Cdirty)
		!@array[] of Dentry{
		![0]	name = "adm",
		!	slot = 0
		!	dblock = [7]
		!}
		!7: adm(tag:Tfile, state=Cdirty)
		!@array[] of Dentry{
		![0]	name = "users",
		!	slot = 0
		!}

		.note
		{
			.console
			!create /adm adm adm 755 d

			このときのコールフロー。

			.c
			!con_create(FID2, "adm", -1, -1, PDIR&0755, 0)
			!call9p1[Tcreate](message)
			!f_create()
			!dnodebuf()
			!rel2abs()

			dnodebufのなかで呼び出されるrel2absは、
			n個目のブロック番号を実際のアドレスへ変換し、
			そのバッファを返す。
			NDBLOCK以上なら間接ブロックのどこか。
			nが未確保なブロックなら
			bufalloc()でフリーブロックを後ろから確保。
		}

		そのままdumpすると、WORMに書き込まれる対象となります。
		ここで、前回のdump時に書き込まれたブロックは
		変更されていない点に注意です。

		.c
		!0:
		!1:
		!2: super addr(tag:Tsuper, state=Cread)
		!Superb{
		!	last = 2,
		!	cwraddr = 3,
		!	roraddr = 4,
		!	next = 5,
		!	fstart = 2,
		!	fsize = 6,
		!	fbuf = { nfree = 1, free = [0] }
		!}
		!3: cw root(tag:Tdir, state=Cread)
		!array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!4: ro root(tag:Tdir, state=Cread)
		!array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!}
		!5: super addr(tag:Tsuper, state=Cdump, ver2)
		!@Superb{
		!	last = 2,
		!	cwraddr = 106,
		!	roraddr = 107,
		!	next = 108,
		!	fstart = 2,
		!	fsize = 109,
		!	fbuf = { nfree = 97, free = [0,105,104...10] }
		!}
		!6: /(tag:Tdir, state=Cdump)
		!@array[] of Dentry{
		![0]	name = "adm",
		!	slot = 0
		!	dblock = [7]
		!}
		!7: adm(tag:Tfile, state=Cdump)
		!@array[] of Dentry{
		![0]	name = "users",
		!	slot = 0
		!}
		!8: /(ro)(tag:Tdir, state=Cdump)
		!@array[] of Dentry {
		![0]	name = "2011"
		!	slot = 0
		!	dblock = [9]
		!}
		!9: 2011(tag:Tdir, state=Cdump)
		!@array[] of Dentry {
		![0]	name = "0411"
		!	slot = 0
		!	dblock = [6]		# from rba(current cw root)
		!}
		!106: cw root(tag:Tdir, state=Cdump, ver2)
		!@array[DIRPERBUF] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!	dblock = [6]
		!}
		!107: ro root(tag:Tdir, state=Cdump, ver2)
		!@array[] of Dentry {
		![0]	name = "/",
		!	slot = 0
		!	dblock = [8]
		!}

		この後、しばらくすればwcpプロセスにより
		CdumpのものがWORMへ書き込まれます。

		\<WORMのレイアウト|04282-2.png>

		=ファイルの更新

		ブロックの一部分だけ更新された場合、
		変更のあったブロックだけ切り替わります。
		以下は疑似コードですが、だいたいこんな感じ。

		.c
		!na = cwrecur(addr)
		!if(na){
		!	block[i] = na;
		!	p->flags |= Bmod;
		!}

		めんどくさいので図は省略。

		=おまけ

		ファイルサーバのconfigは、
		nvramとディスクの0ブロックに分かれて保存されます。
		具体的には

		!config w0
		!service fs
		!ip 192.168...

		この場合、w0という文字列がフロッピーのplan9.nvrに、
		構造体でいえばNvsafe.configに保存され、
		残りの部分はw0ディスクのブロック0に書き込まれます。
		このとき、個々の行は改行(\n)で区切られます。

.aside
{
	=参考サイト
	*[cwfsの研究|http://plan9.aichi-u.ac.jp/cwfs/]
}
