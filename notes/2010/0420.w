@include u.i
%title Inferno httpdとマルチバイト

.revision
2011年5月14日更新
=Inferno httpdとマルチバイト

.note
2011年5月14日現在、公式に対応されましたので、
この記事は不要です。

Inferno Wikiのための前準備。
マルチバイトファイル名を参照すると化けていたので、
httpdを2点ほど修正しました。

まずは、parse.b:urlunesc。
終わりのほうにちょっと追加しただけですね。

.c
!urlunesc(s : string): string
!{
!	c, n : int;
!	u := 0;
!	buf := array[2] of byte;
!	for(i := 0;i<len s ; i++){
!		c = int s[i];
!		if(c == '%'){
!			n = int s[i+1];
!			if(n >= '0' && n <= '9')
!				n = n - '0';
!			else if(n >= 'A' && n <= 'F')
!				n = n - 'A' + 10;
!			else if(n >= 'a' && n <= 'f')
!				n = n - 'a' + 10;
!			else
!				break;
!			c = n;
!			n = int s[i+2];
!			if(n >= '0' && n <= '9')
!				n = n - '0';
!			else if(n >= 'A' && n <= 'F')
!				n = n - 'A' + 10;
!			else if(n >= 'a' && n <= 'f')
!				n = n - 'a' + 10;
!			else
!				break;
!			i += 2;
!			c = c * 16 + n;
!		}
!		else if( c == '+' )
!			c = ' ';
!		if(u >= len buf){
!			b := array[len buf*2] of byte;
!			b[0:] = buf[0:];
!			buf = b;
!		}
!		buf[u++] = byte c;
!	}
!	return string array of byte buf[0:u];
!}

続けてparse.b:urlconv。

.c
!urlesc(c : int): string
!{
!	s, t : string;
!	s[0] = c;
!	buf := array of byte s;
!	for(i:=0;i<len buf ;i++)
!		t += sys->sprint("%%%2.2x", int buf[i]);
!	return t;
!}
!
!urlconv(p : string): string
!{
!	c : int;
!	t : string;
!	for(i:=0;i<len p ;i++){
!		c = p[i];
!		if(c == 0)
!			break;
!		if(c <= ' ' || c == '%' || c >= Runeself){
!			t += urlesc(c);
!		} else {
!			t[len t] = c;
!		}
!	}
!	return t; 
!}

あとはふつうに。

.console
!% mk && mk install

.note
svc/httpdに-Dオプションを与えると、/services/httpd以下に
詳細なログを書き出します。問題解決にとても役立ちます。

@include nav.i
