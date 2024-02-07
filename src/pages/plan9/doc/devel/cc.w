---
title: Cコンパイラ
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2004年11月17日更新
=Cコンパイラ

	=配列の初期化

	C99のように、指示付きの初期化が使えます。
	ただし、C99とは書き方が微妙に異なるので注意。

	.c
	!char *array[] = {
	!	['<']	"&lt;",
	!	['>']	"&gt;",
	!	['&']	"&amp;",
	!	['"']	"&quot;",
	!};

	この場合、初期化していない添字の値は未定義。
	ただし、宣言を以下のようにすれば、
	明示的に初期化しない値は0。

	.c
	!char *array[1<<8] = {
	!	...
	!};

	=構造体の初期化

	構造体も、配列と同様に指示付きの初期化が使えます。

	.c
	!typedef struct Node Node;
	!struct Node {
	!	int type;
	!	Node *left;
	!	Node *right;
	!}

	Node構造体のうち、typeだけ初期化する場合は以下のように。

	.c
	!Node n = {
	!	.type = 0,
	!}

.aside
{
	=参考ページ
	*[2006-04-30 Plan9日記|
	https://oraccha.hatenadiary.org/archive/2006/04/30]
}
