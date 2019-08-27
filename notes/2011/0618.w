@include u.i
%title il.cを読む

=il.cを読む
.revision
2011年6月18日作成

	.note
	{
		TCPの場合は、受信側がSeqを加算してAckに設定するが、
		ILでは送信側がSeqを加算しているようにみえる。
		Ackは最後に受信した相手側のSeqをそのまま送り返す？
	}

	=定数

		:Nqt
		-8
		:IL_IPSIZE
		-IPヘッダのサイズ
		-20
		:IL_HDRSIZE
		-ILヘッダのサイズ; IP部分は含まない
		-18
		:IL_LISTEN
		:IL_CONNECT
		-ilstartに渡す引数
		:IP_ILPROTO
		-IPプロトコル番号
		-40

		=パケットタイプ

		:sync
		:data
		:dataquery
		:ack
		:query
		:state
		:close
		-xxx

		=接続状態

		:Closed
		-初期値または閉じた後
		:Syncer
		-ilconnect(argv, argc)したとき
		-connect側
		:Syncee
		-listen側
		-Listenを経てこれになる
		:Established
		-接続中
		:Listen
		-ilannounce()のとき
		:Closing
		-閉じる処理中
		:Opening
		-fileserverだけ?

	=データ構造

		=Conv

		conversation = 会話, 対話。コネクションにつき1つ割り当て。

		:raddr
		-リモートアドレス(IP)
		:rport
		-リモートポート
		:laddr
		-ローカルアドレス(IP)
		:lport
		-ローカルポート
		:pctl
		-Ilcb, Udpcb, Tcp等が設定されるのでキャストして使う
		:p
		-Proto
		:rq
		-read queue
		:wq
		-write queue
		:eq
		-?

		=Block

		データブロックのリスト。
		データ本体はrpからwpの間に配置される。

		:rp
		-データの開始ポインタ
		:wp
		-データの末尾ポインタ
		-書いたらwpが増えて、それを読んだらrpが増える
		-wp += IL4_IPSIZE+IL_HDRSIZE
		:next
		-blocklenで使っているリスト用
		-次のデータブロック
		:link
		-outoforderとかunackedで使っているリスト用

		=Ilcb

		コントロールブロック。
		/net/il/$id/statusを読むと見れる。

		:state
		-ILコネクションの状態
		:conv
		-Convへの逆参照
		-c->>pctl->>conv == cが成り立つ
		:ackq
		-unacknowledge queue(ロック)
		:unacked
		-list of ref Block
		-まだackを受けていないブロックのリスト(早いものが先頭)
		:unackedtail
		-unackedの末尾; 追加するとき使っている
		:unackedbytes
		-unackedに残っているブロックの合計バイト数
		:outo
		-out of order acket queue(ロック)
		:outoforder
		-list of ref Block
		-iloutoforderで追加+ソートして、ilpullupで取得
		:next
		-次のデータメッセージで設定するID
		:recvd
		-受信した最後のリモート側ilid
		:acksent
		-確認のとれた最大ID(ローカル側)
		:start
		-idの初期値(ローカル側; ランダム)
		:rstart
		-idの初期値(リモート側; ランダム)
		:window
		-ilidはrecvd << ilid <<= recvd+window
		:rxquery
		:rxtot
		:rexmit
		-タイムアウト用っぽい
		:qtx
		-ilnextqt()を呼び出す度に、1..Nqt(8)でループ
		:qt
		-ilnextqt()のときに、qt[[qtx]] = next-1
		-旧バージョンと互換のため、qt[[0]]は常にnext-1
		:fasttimeout
		-ilstartのとき、fasttimeoutが1ならこれも1

		=Ilhdr

		実際に送るIP+ILヘッダ。

		:vihl
		:tos
		:length
		:id
		:frag
		:ttl
		:proto
		:cksum
		:src
		:dst
		-ここまでIPv4ヘッダ
		:ilsum
		-チェックサム
		:illen
		-パケット長(ILヘッダ+データ長)
		:iltype
		-ILパケットタイプ
		:ilspec
		-予約
		-実際は再送カウントのような扱い
		:ilsrc
		-送信元ポート番号
		:ildst
		-送信先ポート番号
		:ilid
		-シーケンス番号
		:ilack
		-ACK

		=Ilpriv

		ILコネクション全体で共有するデータ。

		:ht
		-map of ref Conv
		-ハッシュテーブル
		:stats
		-array of oolong
		:csumerr
		:hlenerr
		:lenerr
		-各種エラー
		:order
		:rexmit
		:dup
		:dupb
		-このあたりもエラー？
		:ackprocstarted
		-ilstartでプロセスが起こっていれば1、まだなら0
		:apl
		-プロセス生成のときに使うロック

		=Proto

		:conv
		-array of conversations
		-いま発生しているコネクションの配列
		:nc
		-conv数?
		:ac
		-?
		:np
		-?
		:f
		-ilinit等で受けたFsポインタ
		:ipproto
		-IPプロトコル番号
		-ILの場合は40
		:priv
		-Ilpriv, Udppriv, Tcpprivといったデータ

		=Fs

		9Pファイルサーバ構造体っぽい。

	=関数

		=char **ilconnect(Conv **c, char ****argv, int argc)

		argv, argcを使ってc->>raddr, c->>laddrを設定する。

		ここで、argv[[1]]はリモートアドレスを文字列で持つ。
		argv[[1]]に!fasttimeoutを含んでいれば、fastモードに切り替わる。
		オプションでargv[[2]]にローカルアドレス。
		argv[[0]]は使わない。

		未開始ならilstartでプロセスを生成する。
		アドレスの指定が間違っていればエラー文字列を返す。

		=int ilinuse(Conv **c)

		cが使用中なら1を返す。
		具体的には、接続状態がClosed以外。

		=char **ilannounce(Conv **c, char ****argv, int argc)

		ilconnectと同じように処理する。
		ただし、!fasttimeoutは認識せず、
		待ち受け状態(Syncee)になる。

		=void illocalclose(Conv **c)

		ローカル側の接続を閉じる。
		接続状態はClosedになり、laddrとlportもリセットされる。

		=void ilclose(Conv **c)

		c->>[[rwe]]qを閉じ、接続を閉じる。
		cがEstablished, Syncee, Syncerなら状態をClosingに変えて、
		closeコマンドを送る。また、Listenならillocalcloseする。

		閉じるだけ、freeはしない。

		=void ilkick(void **x, Block **bp)

		ilcreateで、wq = qbypass(ilkick, c)されるもの。
		おそらくデータの送信に使われるのだろう。

		xはConv**なので、それをもとにbpをdataメッセージに加工、
		構築して投げる。と同時に、ack待ちリストにもコピーを追加。
		ちなみに、これが呼ばれた時点で、bpにはデータしかない。
		なのでpadblockで先頭にヘッダ分を確保して、
		そこにILヘッダを組み立てている。

		=void ilcreate(Conv **c)

		c->>rq, c->>wqの初期化。

		=void ilackq(Ilcb **ic, Block **bp)

		bpをひとつの大きなブロックにコピーして、
		ic->>unackedの末尾に追加する。

		=Block **copyblock(Block **bp, int count)

		ブロックのリスト(bp)を、
		新しいブロックにcountバイトだけコピーして返す。

		=void ilackto(Ilcb **ic, ulong ackto, Block **bp)

		unackedなリストから、
		acktoまで(含む)のパケットを承認されたものとする。
		結果的にunackedから消え、unackedbytesも減る。

		=Conv **iphtlook(Ipht **ht, uchar **sa, ushort sp, uchar **da, ushort dp)

		送信元/送信先のIPアドレス+ポートでテーブルを検索。
		一致の条件は、Listenの場合はいろいろ省略されたりする。

		=void iliput(Proto **il, Ipifc**, Block **bp)

		パケットを受信したとき呼ばれる関数。

		:dp
		-bpの送信元ポート
		:sp
		-bpの送信先ポート
		:raddr
		-bpの送信元IPアドレス
		:laddr
		-bpの送信先IPアドレス

		で、コネクションテーブルからこの条件で検索して、
		見つかったものがListenな接続なら、
		新しい接続(Conv)を作って対象をそれと置き換える。
		元のListen接続はそのままで、新しいほうはSynceeとなる。
		リモート側のシーケンス番号もここで設定。

		最後にilprocess()を呼び出している。

		=void ilprocess(Conv **s, Ilhdr **h, Block **bp)

		パケットを受信したときのメイン処理。
		基本的にはbp->>rp == sだが、Listenした場合は違う。

			=Syncer(connect側)の場合

			syncメッセージを受信したならackを返してEstablishへ移行、
			その後にilpullupする。

			closeメッセージの場合はfreeblist。

			=Syncee(listen側)の場合

			syncを受けてrecvdをそのidに設定、
			syncメッセージをid=start, ack=recvdとして投げ返す。

			ackを受信するとEstablishへ移行、ilpullupする。

			dataを受信した場合もEstablishへ移行するが、
			pullupしないでそのまま処理する。

			=Establishの場合

			sendを受信したらすぐack(id=next, ack=rstart)。

			dataの場合は、それに含まれるackまでを承認して、
			受信したデータをoutoforderへ追加、ilpullupする。

			dataqueryならdataと同じ処理をして、
			最後にstate(id=next, ack=recvd)を投げる。

			ackなら承認するだけ。

			queryはdataqueryと似ているが、
			こちらはデータが無いのでiloutoforderもilpullupもない。

			stateを受信したら、ack承認した後、
			ilrexmitとilsettimeoutしている。
			なんだか普通にIlhdr.ilspecが使われているけど、
			これはどういうことだろう。

			closeを受ければそのままclose(id=next, ack=recvd)。
			状態はClosingになる。

			=Closingの場合

			closeメッセージ受信でclose(id=next, ack=recvd)を返信。
			recvdはこのとき受信したidです。

		=void ilrexmit(Ilcb **ic)

		unackedの先頭にあるメッセージをコピーして再送する。
		このときの型はdataqueryで、ackは再送時のrecvdに変わるが、
		idは最初に送ったものから変化しない。

		それよりも送るデータのilspecを
		ilnextqt(ic)の値に設定しているのが気になる。

		=void ilhangup(Conv **s, char **msg)

		いろいろなものを終了している。illocalclose(s)とか。

		=void ilpullup(Conv **s)

		Ilestablished以外なら何もしない。

		正しい順番でs->>outoforderなリストをs->>rqへ渡す。
		ここで、分割されたブロックならひとつにまとめる。

		もし先にうしろのデータが届いたら、
		貯めておいてあとからまとめて処理する。

		=void iloutoforder(Conv **s, Ilhdr **h, Block **bp)

		s->>outoforderへ(h+bp)を追加する。
		このとき、ilid(シーケンス番号)順になるよう調整する。
		同じIDが現れたときは後のものを優先っぽい？

		=void ilsendctl(Conv **ipc, Ilhdr **inih, int type, ulong id, ulong ack, int ilspec)

		ipcのアドレスとポートをもとにBlockを作り、
		それをipoput4に渡して送信する。
		Blockの後ろ(Block.rpからwpの範囲)にはIlhdrが続く。
		このIlhdrを構成するとき、type, id, ilspecが使われる。

		または、inihがnilでなければ、上記の代わりにこれが使われる。

		ipoput4に渡されるIlhdrは、
		inihの送信元/送信先IP+ポートとは逆になる。

		=Block **allocb(int size)

		sizeof(Block)+size+Hdrspcな領域を確保して返す。
		rpとwpは多少ずれる可能性があるが、
		基本的にBlockのうしろを指す。

		=void ilackproc(void **x)

		ilstartで開始されるプロセスの中身。
		主にいま残っているコネクションをみて、
		それらのタイムアウトを処理している。

		=char **ilstart(Conv **c, int type, int fasttimeout)

		まだなければilackprocを処理するプロセスを立てる。
		プロトコルにつき1プロセス。

		その後、typeフラグにより2通りに別れる。

			=IL_LISTEN

			状態をListenにして、
			c->>p->>priv(Ilpriv)のhtテーブルへcを登録。

			=IL_CONNECT

			Syncer状態でIlpriv.htへcを登録し、
			ilsendctl(ilsync)を呼び出す。
			これによりsyncメッセージを投げる。

		=void ilfreeq(Ilcb **ic)

		icから、unackedとoutoforderリストを解放する。
		ic自体は残る。

		=void iladvise(Proto **il, Block **bp, char **msg)

		il.convから送信元IP, 送信先IP, 送信元ポート番号が
		bpと一致するものを調べて、それがIlsyncerならhangupさせる。
		最後に、一致していてもしなくてもbpを解放。

		=int ilnextqt(Ilcb **ic)

		icの、qtxとqtを設定。1..8でループ。

		=void ilinit(Fs **f)

		connect, announce, rcv等の関数をfに設定して、
		それをfにil用ルーチンとして登録。

.aside
{
	=関連情報
	*[IL/IPv6対応|0704.w]
	*[ILプロトコル|../../plan9/doc/guide/il.w]
	*[カーネルにilを組み込む|../../plan9/doc/inst/il.w]
}

@include nav.i
