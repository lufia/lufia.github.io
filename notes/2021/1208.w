@include u.i
%title Google WorkspaceのGmailでDMARC

.revision
2021年12月8日作成
=Google WorkspaceのGmailでDMARC

	Google Workspaceアカウントで*DMARC*を有効にするためには、*SPF*と*DKIM*も必要。

	=SPF(Sender Policy Framework)

	ドメインのレコードに、以下のようなTXTを追加すれば良い。

	!@ TXT 1h "v=spf1 include:_spf.google.com ~all"

	以下のヘルプに、いくつかの具体例が掲載されている。

	*[SPFについて - Google Workspace管理者ヘルプ|
	https://support.google.com/a/answer/33786]

	それぞれのキーが意味する内容は以下が詳しい。

	*[SPF(Sender Policy Framework): 迷惑メール対策委員会|
	https://salt.iajapan.org/wpmu/anti_spam/admin/tech/explanation/spf/]

	過去に記事も書いた。

	*[ドメイン移管とSPF|../2009/0210.w]

	=DKIM(DomainKeys Identified Mail)

	以下のヘルプによると、設定していない場合はデフォルトのDKIMが使われるらしい。

	*[DKIMを設定してメールのなりすましを防ぐ - Google Workspace管理者ヘルプ|
	https://support.google.com/a/answer/174124]

	Gmailで送ったメールのソースを見ると、以下のヘッダがついていた。

	.http
	!DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; ...
	!Authentication-Results: mx.google.com; dkin=pass ...
	!ARC-Authentication-Results: i=1; mx.google.com; dkin=pass ...

	=DMARC(Domain-based Message Authentication, Reporting, and Conformance)

	ドメインのレコードに以下のようなレコードを追加する。

	!_dmarc TXT 1h "v=DMARC1; p=reject; sp=none; pct=100"

	digで設定を確認する。

	.console
	!% dig txt _dmarc.lufia.org

	上記を実行した結果、ANSWERセクションで以下が見られれば終わり。

	!;; ANSWER SECTION:
	!_dmarc.lufia.org. 3600 IN TXT "v=DMARC1; p=reject; sp=none; pct=100"

	*[DMARCレコードの追加 - Google Workspace管理者ヘルプ|
	https://support.google.com/a/answer/2466563]

	それぞれのキーが意味する内容は以下が詳しい。

	*[DMARCと送信ドメイン認証を理解して、実際に設定してみよう|
	http://blog.smtps.jp/entry/2017/12/22/095814]

	=Google Domainsメモ

	TXTレコードに複数の値を設定したい場合は、編集ボタンで編集状態にして、
	各エントリの*このレコードにさらに追加*ボタンを押せば追加できる。

	少し古い画面では、*++*ボタンだけしかなくとても分かりづらいものだった。

	*[How to set up DNS records with Google Domains|
	https://protonmail.com/support/knowledge-base/dns-records-google-domains/]

	そのほか、DNSのTXTレコードに設定しておくと良いもの。

	*[TXTレコードの値 - Google Workspace管理者ヘルプ|
	https://support.google.com/a/answer/2716802]

@include nav.i
