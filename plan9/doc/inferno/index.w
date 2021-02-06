@include u.i
%title Infernoメモ

.revision
2011年2月14日更新
=Infernoメモ

	=ユーザ名を指定してログイン
	.sh
	!emu -g 1024x768 wm/wm wm/logon -u username

	=ユーザの作成
	\*/usr/inferno*をコピー。

	.console
	!% cd /usr
	!% cp -r inferno username

	=起動スクリプト
	\*/sh/lib/profile*に書く。

	=初期設定
	\*$home/lib/wmsetup*に書く。

	.sh
	!#plumber
	!ndb/cs
	!ndb/dns -r
	!auth/factutum
	!auth/feedkey

	=ホストOSとのクリップボード共有

	.console
	!% bind -b '#^' /chan

	wmsetupあたりに記述しておくといいかもしれない。

	=DNSが引けない
	dnsが起動していない。$home/lib/wmsetupに以下を追加する。

	.sh
	!ndb/dns -r

	=drawtermっぽいこと

	inferno-listにあった[drawterm equivalent in inferno|
	http://permalink.gmane.org/gmane.os.inferno.general/1416]より。

	.console
	!% mount {wmexport} /mnt/wm
	!% cpu tcp!board
	!; wmimport -w /n/client/mnt/wm wm/wm&

	=Mounting Plan 9 fs on Inferno

	*[9fans|http://groups.google.com/group/comp.os.plan9/browse_thread/thread/f5b23e0fa87119de#]

	=acmeのフォント

	どうやら[Plan9他からコピーすればいい|
	http://d.hatena.ne.jp/kayn_koen/20110202]みたい。
	WindowsのInfernoを使っていますが、コピーしただけでは
	なぜかSegmentation Violationだったのですが、
	/fonts/lucidasans/euro.8.fontの最後から
	以下の行を削除したところ動きました。

	!0xFFFD 0xFFFD 0x80 lsr.14

	原因は調べてないけどまあいいか。

	=日記から

	*[InfernoからホストOSをマウントする|../../../notes/2006/1015.w]
	*[Limboでお題|../../../notes/2007/1216.w]
	*[Plan 9 to Inferno translation|../../../notes/2008/0801.w]
	*[Inferno httpdとマルチバイト|../../../notes/2010/0420.w]
	*[Inferno Wiki|../../../notes/2010/0512.w]

.aside
{
	=参考ページ
	*[Inferno log|http://c.p9c.info/inferno/ilog.html]
}

@include nav.i
