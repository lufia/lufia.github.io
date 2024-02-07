---
title: バンドデータ処理プログラム
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2009年9月30日更新
=バンドデータ処理プログラム

	\[Nizah Blogのお題|
	http://blog.nizah.net/nb/2007/12/13/band-code.html]を
	Limboで解いてみました。

	タプルと配列スライスが使えるから少し便利ですが、
	それ以外は、ほとんどCになってしまいました。。

	それから、ソートが言語に含まれなくて、関数ポインタを渡す方法が
	分からなかったので、ソートの比較はいっぱい無理してます。
	単純にYear: con 0;とかでもよかったけどね。

	.c
	!implement Band;
	!
	!include "sys.m";
	!	sys: Sys;
	!	print: import sys;
	!include "draw.m";
	!include "string.m";
	!	str: String;
	!
	!Band: module
	!{
	!	init: fn(ctxt: ref Draw->Context, argv: list of string);
	!};
	!
	!Order: adt {
	!	pick {
	!	Year or Name =>
	!	}
	!};
	!
	!init(nil: ref Draw->Context, nil: list of string)
	!{
	!	sys = load Sys Sys->PATH;
	!	str = load String String->PATH;
	!	name := array[] of { "The Beatles", "KRAFTWERK", "Queen", "B'z", "ThE Foo Bar" };
	!	year := array[] of { 60, 1970, 70, 88, 2007 };
	!	country := array[] of { "UK", "DE", "UK", "JP", "US" };
	!
	!	# ex 1
	!	band := array[len name] of (string, int, string);
	!	for(i := 0; i < len name; i++)
	!		band[i] = (name[i], year[i], country[i]);
	!
	!	# ex 2
	!	band2 := array[len band] of (string, int, string);
	!	band2[0:] = band;
	!	sort(band2, len band2, ref Order.Year);
	!	for(i = 0; i < len band2; i++){
	!		(b1, b2, b3) := band2[i];
	!		print("%s,%d,%s\n", b1, b2, b3);
	!	}
	!
	!	# ex 3
	!	sorted_band := array[len band] of (string, int, string);
	!	sorted_band[0:] = band;
	!	sort(sorted_band, len sorted_band, ref Order.Name);
	!
	!	# ex 4
	!	print("\n");
	!	for(i = 0; i < len sorted_band; i++){
	!		(b1, b2, b3) := correct(sorted_band[i]);
	!		the := "";
	!		if(str->tolower(b1[0:3]) == "the"){
	!			the = "(" + b1[0:3] + ")";
	!			b1 = b1[4:];
	!		}
	!		print("%-6s%-15s%d %s\n", the, b1, b2, b3);
	!	}
	!}
	!
	!sort(a: array of (string, int, string), r: int, order: ref Order)
	!{
	!	sort1(a, array[len a] of (string, int, string), r, order);
	!}
	!
	!sort1(a, b: array of (string, int, string), r: int, order: ref Order)
	!{
	!	if(r > 1){
	!		m := (r-1)/2 + 1;
	!		sort1(a[0:m], b[0:m], m, order);
	!		sort1(a[m:r], b[m:r], r-m, order);
	!		b[0:] = a[0:r];
	!		for((i, j, k) := (0, m, 0); i < m && j < r; k++){
	!			cmp: int;
	!			pick c := order {
	!			Year =>
	!				cmp = yearcmp(b[i], b[j]);
	!			Name =>
	!				cmp = namecmp(b[i], b[j]);
	!			* =>
	!				raise "fail:order";
	!			}
	!			if(cmp > 0)
	!				a[k] = b[j++];
	!			else
	!				a[k] = b[i++];
	!		}
	!		if(i < m)
	!			a[k:] = b[i:m];
	!		else if(j < r)
	!			a[k:] = b[j:r];
	!	}
	!}
	!
	!yearcmp(b1: (string, int, string), b2: (string, int, string)): int
	!{
	!	(nil, y1, c1) := correct(b1);
	!	(nil, y2, c2) := correct(b2);
	!	if(y1 > y2)
	!		return 1;
	!	else if(y1 < y2)
	!		return -1;
	!
	!	if(c1 > c2)
	!		return 1;
	!	else if(c1 == c2)
	!		return 0;
	!	else
	!		return -1;
	!}
	!
	!namecmp(b1: (string, int, string), b2: (string, int, string)): int
	!{
	!	name1 := namei(b1);
	!	name2 := namei(b2);
	!	if(name1 > name2)
	!		return 1;
	!	else if(name1 == name2)
	!		return 0;
	!	else
	!		return -1;
	!}
	!
	!correct(band: (string, int, string)): (string, int, string)
	!{
	!	(name, year, country) := band;
	!	if(year < 100)
	!		year += 1900;
	!	return (name, year, country);
	!}
	!
	!namei(band: (string, int, string)): string
	!{
	!	(name, nil, nil) := band;
	!	name = str->tolower(name);
	!	if(name[0:3] == "the")
	!		name = name[4:];
	!	return name;
	!}

	2文字以下のバンド名("X"など)が初期データにあると落ちる。
	theの判定のところでname[[0:3]]が配列境界を越えるから。

	=2009年9月30日追記
	関数ポインタは、ref fn()のように書くと渡せる。

	.c
	!implement Fn;
	!
	!include "sys.m";
	!	sys: Sys;
	!include "draw.m";
	!
	!Fn: module
	!{
	!	init: fn(ctxt: ref Draw->Context, argv: list of string);
	!};
	!
	!Int: adt
	!{
	!	n: int;
	!};
	!
	!init(nil: ref Draw->Context, nil: list of string)
	!{
	!	sys = load Sys Sys->PATH;
	!
	!	A1 := array[] of { "a1", "b2", "c3" };
	!	A2 := array[] of { ref Int(1), ref Int(2), ref Int(3) };
	!
	!	apply(A1, printstring);
	!	apply(A2, printint);
	!}
	!
	!apply[T](a: array of T, f: ref fn(p: T))
	!{
	!	for(i := 0; i < len a; i++)
	!		f(a[i]);
	!}
	!
	!printint(n: ref Int)
	!{
	!	sys->print("%d\n", n.n);
	!}
	!
	!printstring(s: string)
	!{
	!	sys->print("%s\n", s);
	!}

	qsortの比較関数プロトタイプなど、Cでvoid**を使う状況では、
	パラメトリック多相型というものが同じような目的に使える。
	上記の例でいえば、apply関数で使っているT型。
	これは、ref型しか扱えない(型の解決ができない)という制限があるので、
	intを直接扱うといったことはできない。

.aside
{
	=参考サイト
	*[Limboのパラメトリック多相|
	http://alohakun.blog7.fc2.com/blog-entry-730.html]
}
