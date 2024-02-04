@include u.i
%title HHKBを快適に使う

.revision
2015年7月18日作成
=HHKBを快適に使う

	自宅と職場で、Windows(BootCamp)とMacを交互に使っていると、
	ちょっとした違いが気になるようになったのでいろいろ変更しました。

	=自宅環境

	* Windows(BootCamp) + Mac併用
	* どちらかというとWindowsの頻度が高い
	* HHKB Professional 2
	* ホイール付きマウス

	=職場環境

	* Windows(Remote Desktop) + Mac併用
	* 圧倒的にMacの頻度が高い
	* Happy Hacking Keyboard(PS/2の古いやつ)
	* 3ボタンマウス
	* トラックパッド

	=職場MacにHHKPS2USBDriverを入れる

	古いHayyp Hacking Keyboardは◇キーが「変換」「無変換」として扱われています。
	Windowsの場合、キーボードドライバをkbdlk41A.dllに変更しなければ、
	キーボードはキーコードを発してもOSがうまく扱えませんが、
	Winキーがなくてもそれほど困りません。

	ただし、Macの場合、Commandキーが無いのはとても不愉快なので、
	「変換」「無変換」をCommandキーに置き換えるドライバを入れます。
	OS X 10.10(Yosemite)からは、
	適切な署名をしていないKernel Extensionをロードしませんので、[署名済みのドライバ|
	https://github.com/lufia/HHKPS2USBDriver]を作成しました。

	=自宅のHHKB Pro2をMacモードにする

	HHKB Pro2は[Macintoshモード|
	http://www.pfu.fujitsu.com/hhkeyboard/leaflet/hhkb_backview.html#pro2]に
	設定しなければ、◇キーをCommandキーとして扱ってくれません。
	そのため、MacでCommandキーを扱う必要がある以上、Macintoshモードが必須です。

	=職場のHappy Hacking KeyboardをMode 3にする

	上記で、HHKB Pro2をMacintoshモードに設定しましたが、
	このモードの場合、DeleteキーをBackspaceとして扱うようになり、
	なぜかDIP SW3をONにしても変更ができません。
	そのため、職場環境でも同じように、DeleteをBackspaceとして、
	Fn+DeleteをDeleteと扱うように変更します。

	Backspaceなモードは2つありますが、
	HHKBPS2USBDriverは無変換キーを取り扱う必要があるため、[Mode 3|
	http://www.pfu.fujitsu.com/hhkeyboard/leaflet/hhkb_backview.html#hhkb]に
	設定しました。

	.note
	Happy Hacking Keyboardの説明にあるMacは、ADBポートを使うような古いMacです。
	Intel以降のMacは、表中の「PC(PS/2)」に該当します。

	=自宅Windowsのホイールスクロールを逆向きにする

	どちらに合わせようか迷いましたが、Macデフォルトに合わせました。
	\[余計なアプリケーションを使わずに Windows のホイールスクロール方向を逆にする|
	http://blog.daichisakota.com/?p=625]を参考に、以下レジストリの値を変更します。

	!HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\xxxx\yyyy\Device Parameters
	!	FlipFlopWheel = 1

	USBレシーバ等を使っている場合は、
	レシーバ側のxxxx\yyyyに設定してあげる必要があります。

	=(おまけ)HHKモードで◇キーを「変換」「無変換」と扱う

	HHKB Pro2をMacで快適に使うため、Macintoshモードが必須になったので、
	現在この設定は入れていません。
	HHKB Pro2をHHKモードで使う場合、
	または、Happy Hacking KeyboardをWindowsで使う場合は便利なので
	メモとして残しています。

	\[公式のFAQ|
	https://www.pfu.fujitsu.com/hhkeyboard/hhkb_support/faq_pro.html]から、

	>左右◇キーを、無変換 / 変換に設定するのはどうすればいいでしょうか？

	の通りに実施すればOSはキーを正しく認識してくれるようになります。
	レジストリファイルは以下の通り。

	.ini
	!Windows Registry Editor Version 5.00
	!
	![HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters]
	!"PollingIterations"=dword:00002ee0
	!"PollingIterationsMaximum"=dword:00002ee0
	!"ResendIterations"=dword:00000003
	!"LayerDriver JPN"="kbdlk41a.dll"
	!"LayerDriver KOR"="kbd101a.dll"
	!"OverrideKeyboardIdentifier"="PCAT_101KEY"
	!"OverrideKeyboardType"=dword:00000007
	!"OverrideKeyboardSubtype"=dword:00000000

	また、IMEのプロパティから、

	+全般タブ
	+編集操作グループの変更
	+キー設定タブ

	を開いて、

	|*キー*		*入力/変換済み文字なし*
	|無変換		IME-オフ
	|変換  		IME-オン

	とすると、便利に使えます。

.aside
{
	=関連情報
	*[Mac移行まとめ|../2009/1223.w]
}

@include nav.i
