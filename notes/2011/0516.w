@include u.i
%title fsオープンファイルの管理

.revision
2011年5月16日作成
=fsオープンファイルの管理

ファイルサーバは、いま開いているファイルについて、
チャネル(chan)とFIDにもとづいたリストを持っています。
ここで開いているというのは、9pのattach、cloneからclunkまでのことです。
ファイルサーバはいろいろな処理(dumpとか)で読み書きしていますが、
それらとオープンファイルは関係ありません。

.note
ファイルサーバコンソールからのcreateなどは9p扱いになりますので、
それはまた別。

各オープンファイルはFile構造体で表します。
Fileはファイルツリーを遡るために、Wpathのリストを持っています。
Wpathには自分自身を含めません。
なので、/のWpathはnilですし、/adm/usersのWpathは/とadmのリストです。
また、Wpathは9pでcloneしたとき、もとのオープンファイルが持っていた
Wpathの参照カウントを増やし、それを共有します。

.note
FIDは9pクライアントが管理しているIDなので、
チャネルごとに同じファイルは開けないといったことは起こりません。
ファイルサーバ内でユニークなファイルのIDはqidのほうです。

Dentryなど他のデータと異なり、File.slotとWpath.slotは、
ブロック内でのインデックスではありません。
ファイル全体を通してのインデックスです。
ここで、なぜブロックアドレスを使わないのかというと、
dumpのときに変更のあったブロックアドレスが変わります。
で、そのときのオープンファイルについても
ブロックアドレスを新しいものに更新するのですが、
アドレスをそのまま持たせていると、
新しいアドレスを探索するのが大変になるのですね。
なので、オープンファイルのDentryが保存されている
ブロックアドレスを、そのDentryが親Dentryブロックの中で
直接+間接ブロックを通していくつめのブロックにあるか(off)と置き換えて、
off**DIRPERBUF+slotのように、ひとつにまとめているわけですね。
これにより、

.c
!p = getbuf(target->parent->addr)
!d = getdir(p, target->parent->slot%DIRPERBUF)
!p1 = dnodebuf(p, d, target->slot/DIRPERBUF)

こんなふうに使えます。

いつものように/adm/usersを開いたときの動作予測。

!DIRPERBUF = 10
![cw root] = 106
!
!# f_attachで
!File = {
!	wpath = nil,
!	addr = 106,		# /のDentryがあるブロック
!	slot = 0,		# /のスロット
!	open = 0
!}
!
!# f_walk("adm")すると
!File = {
!	wpath = {addr = 106, slot = 0} :: nil,
!	addr = 6,				# admのDentryがあるブロック
!	slot = off(0)*DIRPERBUF+slot(0) = 0,	# admのスロット
!}
!
!# 続いてf_walk("users")
!File = {
!	wpath = {addr = 6, slot =  0} :: {addr = 106, slot = 0} :: nil,
!	addr = 7,				# usersのDentryがあるブロック
!	slot = off(1)*DIRPERBUF+slot(1)=11,	# usersのスロット
!}

.note
{
	f_openのときに、
	open = OREAD||OWRITE||OTRUNCをFREAD/FWRITEに加工して設定

	f_clunkまたはf_removeでfree
}

概要図。

\<FileとWpathの動き|0516.png>

.aside
{
	=参考サイト
	*[cwfsの研究|http://plan9.aichi-u.ac.jp/cwfs/]
}

@include nav.i
