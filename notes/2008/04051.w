@include u.i
%title 使ってないサービスの停止

.revision
2008年4月5日作成
=使ってないサービスの停止

	CPUサーバの使ってないサービスを止めました。
	もともと外部には公開してなかったので、結局何も変わらない感じ。

	=service.auth
	*tcp22(ssh)
	*tcp110(pop3)
	*tcp995(pop3s)

	.note
	4/8にreplica/pullしたところ、
	これらは/rc/bin/serviceに移動されていました。

	=service
	*tcp7(echo)
	*tcp9(discard)
	*tcp19(chargen)
	*tcp21(ftp)
	*tcp23(telnet)
	*tcp53(dnstcp)
	*tcp113(ident)
	*tcp143(imap4)
	*tcp513(rlogin)
	*tcp565(whoami)
	*tcp993(imap4s)
	*tcp17005(ocpu -f -R)
	*tcp17006(ocpu -N)
	*tcp17013(cpu -O)

	=不明なもの
	*service/tcp17005
	*service/tcp17006

	これらは/bin/ocpuというコマンドを実行していますが、
	ocpuが見つかりません。なので、何が動いているか不明。

	=メモ
	:tcp7
	-送信されたデータを単に送り返すサービス
	:tcp9
	-受信したデータを単に捨てるサービス
	:tcp19
	-入力に関わらず単にデータを送り返すサービス
	:tcp113
	-接続したサーバのユーザー情報を返すサービス
	:tcp565
	-i am $x sysname $x you are $x port $x

	\*/sys/src/cmd/aux/listen.c*を読んだので、あとでまとめ書く。

	=参考
	*[サバカン 技術情報|http://www.sabakan.info/techinfo/echoping1.html]
	*[TCP/113 AUTH/IDENT に関して|http://unixluser.org/techmemo/ident/]

@include nav.i
