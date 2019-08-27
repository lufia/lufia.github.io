@include u.i
%title Inferno Wiki

=Inferno Wiki
.revision
2010年5月12日作成

	=httpd

	!mkdir /services/httpd/root
	!svc/httpd/httpd &

	=wiki
	caerwyn.comからwikifs, acme wikiをダウンロード

	*いくつかコンパイルエラーになるところがあるので修正
	*wiki.b:nametonumの最初に、s = str->>tolower(s)を加える

	!mv wiki.m /include
	!mv wikipost.dis /dis/svc/httpd
	!mv wiki.dis /dis/lib
	!mv *.dis /dis

	=acme wiki
	caerwyn.comからダウンロード。
	/acmeに展開しておいて。

	!cd src
	!mk install

	で。httpdとacmeの両方に対応するため

	!mount {wikifs -d $home/lib/wiki.sample} /mnt/wiki
	!bind /mnt/wiki /services/httpd/root/sample

.aside
{
	=参照ページ
	*[Inferno httpdとマルチバイト|0420.w]

	=気になった記事
	*[InfernoのHTTPでCGIを書く|
	http://inferno-hell.blogspot.com/2010/01/infernohttpcgi.html]
}

@include nav.i
