@include u.i
%title 無線LANのセキュリティ

.revision
2009年10月19日作成
=無線LANのセキュリティ

	.note
	この記事は書きかけです。

	=先に結論を書くと
	法人なら、しっかり対策すれば普通に安全。
	個人は、現状EvilTwinだけはどうにも対策不可。
	どちらにしても、WPA-AESまたはWPA2-AESでなければ危険。

	=結論は書いたので以下だらだらと
	SSIDステルス、ANY拒否、MACアドレス認証などなど。
	要素が多すぎて混乱してきたので、まとめました。
	まずは、一般的な事柄、続けて無線LANの要素を書きます。

	=セキュリティの3大要素
		一般的にセキュリティの要素は以下3つの要素に分類できます。

		*盗聴(機密性)
		*改ざん(整合性、完全性)
		*なりすまし

		これ以外にも可用性などが含まれていることもありますが、
		今回は無視します。以下詳細。

		=盗聴とその対策
		第三者がデータの内容を読み取れてしまうこと。
		ユーザを認証して適切なアクセス権を割り当てたり、
		データを暗号化して通信することで対策。

		=改ざんとその対策
		第三者がデータを書き換えてしまうこと。
		データの暗号化、データの認証で対策。
		どちらかというと、改ざんを防止するのではなく、
		改ざんされたことを検出する技術。メッセージダイジェスト。

		=なりすましとその対策
		第三者が他人になりかわること。例えば振込み詐欺。
		ユーザ認証により本人確認したり、
		認証局(CA)から保証してもらったりする(デジタル署名)。

		ただし現状、*個人でデジタル署名は取得できない*。

	=無線LANのセキュリティ技術

		これらをふまえて、無線LANの
		セキュリティ技術を挙げていきます。
		以下、無線LANアクセスポイントを親機、
		無線LANクライアントを子機と書きます。

		ではまず簡単なものから。

		=ANY接続の拒否
		ANY接続とは、クライアントのSSIDを
		特殊な意味を持つID「ANY」にすると、
		どんなSSIDの親機とでも接続できる、という便利な機能です。
		扱いはワイルドカードに似ています。
		で、ANY拒否というのは、SSIDがANYの子機からの接続を
		拒否する機能のこと。拒否しておいて損は無いかと。

		これが、次のSSIDステルスと
		混同して書かれている場合があるのでややこしい。
		機能としても同じ扱いの機種もあるようです。

		=SSIDステルス
		SSIDを、アクセスポイント一覧から見えなくする機能。
		一覧に表示されなくなり、手動でSSIDを設定しないと繋がらないので、
		SSIDを知らないと繋がらないように思いがちですが、
		通信内容にはSSIDが平文で含まれているので気休め程度。
		信用しないほうが賢明です。

		=MACアドレスフィルタリング
		「MACアドレスは機器ごとに異なる」という特徴を利用した認証。
		子機のMACアドレスを事前に親機へ登録しておいて、
		登録のないMACアドレスからのアクセスを拒否する機能。
		ですが、MACアドレス自体は簡単に書き換えできるに加えて、
		無線通信を暗号化していても、暗号化されるのはデータ部だけで
		MACアドレスは平文で流れるので、効果のほどは微妙。

		ちなみに、MACアドレスを偽装することを、
		「MACアドレススプーフィング」と呼ぶらしいです。

		SSIDステルスとMACアドレスフィルタリングについては、
		TECH WORLDの[あなたの知らない無線LANの恐怖|
		http://www.techworld.jp/topics/utm/11264/2/]
		が詳しいです。

		無線LAN(802.11)のフレームフォーマットについては以下2つ。
		*[MACフレームの種類と用途|
		http://lantech.up.seesaa.net/subpage/IEEE80211MacFrame.html]
		*[データフレームフォーマット|
		http://itpro.nikkeibp.co.jp/members/NBY/Security/20040410/4/]

		=WEP/WPA/WPA2
		認証と暗号化規格のセット。
		WPA2が現状最も優秀。WEPは危険。WPAはその中間。
		とは言っても、WPAとWPA2は、認証と暗号に
		以下のどれを選ぶかによって変わる。
		WEPは、WEP128も使ってはいけないので無視します。

		=認証の種類
			=オープンシステム認証
			認証とは言っていますが、認証しないことと等しい。

			=PSK(事前共有鍵)
			共通パスワードにより認証する。
			パーソナルモードとも呼ぶらしい。

			=EAP(拡張可能認証プロトコル)
			\[IEEE802.1X|http://itpro.nikkeibp.co.jp/article/COLUMN/20061010/250248/?ST=nettech&P=2]で認証する。
			エンタープライズモードとも呼ぶ。
			拡張可能なだけあって、多すぎなので名前だけ。
			親機と子機が相互に認証しあうので、
			使えるならEAP-TLSが最良。

			*EAP
			*EAP-MD5
			*EAP-TTLS
			*EAP-PEAP
			*EAP-TLS
			*LEAP(ASLEAPというツールでクラック可能らしい)

		=暗号化の種類
			=WEP
			暗号化してないようなもの。使ってはいけない。

			=TKIP
			2009年8月、[無線LANのWPAをわずか数秒から数十秒で突破する新しい攻撃方法が登場|http://gigazine.net/index.php?/news/comments/20090805_attack_on_wpa/]しました。
			タイトルはWPAが破られたようにみえますが、
			破られたのはTKIPです。WPA-AESはまだ大丈夫。

			=AES
			今のところ問題なし。

		WPA-AESとWPA2-AESは、
		暗号化アルゴリズムが同じなので、同じものです。
		違いは、WPAでは暗号化セットにAESを含まなくてもいいのですが、
		WPA2では必ず含まなければWPA2対応を名乗れません。

	=結局どれを使えばいいのか
	ANY拒否にして、WEP以外の規格をAESで使っていれば、
	親機については、それほど問題は無いんじゃないかと思っています。
	ただし、問題はここから先。子機から親機の認証について。

	IEEE802.11では、モバイル環境も考慮してなのか、
	より電波の強い親機に接続しようとします。
	具体的に言えば、現在接続しているSSIDと同じSSIDを持つ親機のうち、
	もっとも電波の強いものにアクセスします。

	ここで重要な点は2つ。

	*SSIDは隠したところでフレームに含まれるので、誰でも見られる
	*MACアドレスは書き換えられるので、親機のMACを登録したところで無意味

	以下書きかけ。

	!=EvilTwin(Wiフィッシング)
	!なりすまし対策は、ユーザ認証かCAお墨付き証明書なのですが、
	!子機が親機を認証するなんてできないので、証明書を使って
	!子機から親機を認証するしかありません。なのでEAPの、
	!相互に証明書を使って認証するEAP-TLS

	!http://www.atmarkit.co.jp/fnetwork/tokusyuu/19wlan/01.html

	!=本人(アクセスポイント)の確認は？なりすましAP対策
	!*[http://www.geocities.jp/hibiyank/ver3/sekyu/sekuwi.htm]
	!*[WiFishing|http://www.nikkeibp.co.jp/sj/2/column/u/03/]
	!EvilTwinとも言う。

	!IEEE802.1xで証明書を交換し、相互に認証しあうしかない？

	!でも、この安全性は、証明書がVeriSign等の証明機関から発行されているかを基準にしている気がする。
	!では家庭で使っている無線LANはどうすればいいんだろう。危険な情報は入力するなってのは馬鹿な話。
	!狙われやすいのはHotSpotってだけで、原理的にはどの無線APでも可能なわけだし。
	!狙われない程度に安全ってのは、たとえ家庭用ってのを差し引いても
	!http://itpro.nikkeibp.co.jp/article/COLUMN/20060914/248050/

.aside
{
	=関連情報
	*[無線LANのセキュリティ2|../2011/0712.w]
}

@include nav.i
