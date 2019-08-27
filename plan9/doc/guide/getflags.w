@include u.i
%title aux/getflagsの使い方

=aux/getflagsの使い方
.revision
2009年9月4日更新

flagfmtにオプション引数、
argsにオプション以外の引数(ファイルなど)を設定し、
getflagsをevalすればいい。
sedを例にとれば、以下のようになる。

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

@include nav.i
