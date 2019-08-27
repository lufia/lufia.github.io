@include u.i
%title week of month

=week of month
.revision
2009年6月28日更新

	いま作ってるプログラムで週計算する機能が必要になったため、
	英語でweek of monthと検索。
	日本語では一般的に、何て呼ぶんでしょうね。

	>ISOでは、ISO8601で定義されていますが
	>「月曜を第一日として4日以上含む週」を第一週とみなします。
	>[WeekOfMonth|http://www.microsoft.com/japan/msdn/community/gdn/ShowPost-17973.htm]

	うわあ、、めんどくさい。。

	カレンダーの行で、1行目が第1週、2行目が第2週、と思っていました。
	まあでも、今作ではISO仕様だと使いにくいので、無視してもいいかなあ。
	calendar(1)のthe nth weekもISO仕様じゃないし、ね。

	そういえば、[/sys/src/cmd/calendar.c|
	http://cm.bell-labs.com/sources/plan9/sys/src/cmd/calendar.c]で
	使われている式はこちら。

	!nth[tm->mday/7]

	でもこれ、

	!nth[(tm->mday-1)/7]

	じゃないのかなあ。これもカルチャー?

	=2009/06/28追記
	パッチを投げたら採用されました。
	パッチの送り方については[patchを送る|
	/plan9/doc/prog/patch.w]に書きました。

@include nav.i
