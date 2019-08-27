@include u.i
%title Win2008 R2でCドライブが肥大化

=Win2008 R2でCドライブが肥大化
.revision
2011年6月6日作成

	知らない間に40Gとか使っていた。
	さすがにこれはありえないだろうと調べてみた。

	=c:\windows\winsxs

	これが9Gとかあったので調べた。
	結論は、表面上9Gにみえるけど実際はハードリンクなので400M程度だそうで。
	本当の容量はフォルダではなく、ドライブのプロパティを見ればいいみたい。

	*[HDDバカ食いの理由|
	http://freesoft.tvbok.com/tips/win7rc64/windows7_winsxs.html]

	=c:\windows\sysmsi\ssee\mssql.**\mssql\data

	これも多くて、容量は20Gくらい。
	特にWSS_Content_log.ldfが15Gほど。
	なにかと思ったらSharePoint Services 3.0のデータらしい。
	原因(のひとつ)は、規定の設定でインストールすると[完全復旧モデル|
	http://msdn.microsoft.com/ja-jp/library/ms187048.aspx]になるため。
	そんなわけで[バックアップを取ってログを小さく|
	http://www.sswug.org/articles/viewarticle.aspx?id=43533]するか、
	または[ファイルの場所を移動|
	http://blogs.msdn.com/b/groupboard_blog/archive/2007/02/05/db.aspx]
	しないとですが、sqlcmdで接続しようにも、
	位置の特定に失敗(0xFFFFFFFF)というエラーになって、接続できなくて困る。
	こういった場合は、[名前付きパイプで接続|
	http://www.mssqltips.com/tip.asp?tip=1577]すればいい。

	!sqlcmd -E -S \\.\pipe\MSSQL$MICROSOFT##SSEE\sql\query

.aside
{
	=参考サイト
}

@include nav.i
