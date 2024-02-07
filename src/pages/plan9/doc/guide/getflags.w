---
title: aux/getflagsの使い方
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2009年9月4日更新
=aux/getflagsの使い方

flagfmtにオプション引数、
argsにオプション以外の引数(ファイルなど)を設定し、
getflagsをevalすればいい。
sedを例にとれば、以下のようになる。

.sh
!flagfmt='n,g,e script, f sfile'
!args='[file ...]'
!
!if(! ifs=() eval `{aux/getflags $*}){
!	aux/usage
!	exit usage
!}
!
!if(~ $#flagg 1)
!	global=1
!if(~ $#flagf 1)
!	file=$flagf
!
!...

.aside
{
	=関連情報
	*[getflags(8)]
}
