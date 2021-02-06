@include u.i
%title libbio tips

.revision
2009年9月5日更新
=libbio tips

	=Bgetline
	Biobuf(Biobufhdr)にバッファを持っていて、
	Brdlineはそのポインタを返します。
	このため、次の呼び出し時には別の内容に書き換わってしまいます。
	恒久的に文字列を維持したい場合は、自分でコピーします。

	.c
	!Binit(&fin, fd, OREAD);
	!while(s = Brdline(&fin)){
	!	s[Blinelen(&fin)-1] = '\0';
	!	file[nline++] = strdup(s);
	!}

.aside
{
	=関連情報
	*[bio(2)]
}

@include nav.i
