---
title: xpathコマンド
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年11月2日作成
=xpathコマンド

Plan 9に[移植されたPython|/plan9/doc/devel/python.w]で、
XPath検索するコマンドを作りました。
文字コードの関係で4時間ほど悩んだことを除けば、お手軽でいい言語ですね。
文字コードの問題については、[PythonのUnicodeEncodeErrorを知る|
http://lab.hde.co.jp/2008/08/pythonunicodeencodeerror.html]が
よくまとまっている資料だと思います。

まず、以下のソースをXPath.pyとして保存。

!#!/bin/python
!
!import sys, codecs
!from BSXPath import BSXPathEvaluator as XPathEvaluator
!from BSXPath import XPathResult
!
!def find(xpath, fin, fname):
!	lines = fin.readlines()
!	data = ''.join(lines)
!	try:
!		doc = XPathEvaluator(data)
!		r = doc.getItemList(xpath)
!	except TypeError, e:
!		print >>sys.stderr, "xpath: '%s' %s" % (fname, e)
!		return 0
!	except ValueError, e:
!		print >>sys.stderr, "xpath: '%s' %s" % (fname, e)
!		return 0
!
!	n = len(r)
!	for i in range(n):
!		if isinstance(r[i], unicode):
!			print r[i]
!		elif 'decode' not in dir(r[i]):
!			print r[i]
!		else:
!			print r[i].decode('utf-8')
!	return n
!
!sys.stdin = codecs.lookup('utf_8')[-1](sys.stdin)
!sys.stdout = codecs.lookup('utf_8')[-1](sys.stdout)
!argv = sys.argv[1:]
!xpath = argv[0]
!argv.pop(0)
!
!found = 0
!if len(argv) == 0:
!	found += find(xpath, sys.stdin, None)
!else:
!	for f in argv:
!		fin = open(f, 'r')
!		found += find(xpath, fin, f)
!		fin.close()
!if found == 0:
!	exit(1)

以下2つのモジュールをXPath.pyと同じ場所に置きます。

*[BeautifulSoup.py|http://www.crummy.com/software/BeautifulSoup/]
*[BSXPath.py|http://d.hatena.ne.jp/furyu-tei/20090324]

最後にxpathを呼び出すシェルスクリプト。

.sh
!#!/bin/rc
!
!if(~ $#* 0){
!	echo 'usage: xpath pattern [files]' >[1=2]
!	exit usage
!}
!
!exec python /bin/_xpath/XPath.py $*

まとめ。

!/bin/xpath
!/bin/_xpath/BeautifulSoup.py
!/bin/_xpath/BSXPath.py
!/bin/_xpath/XPath.py

.aside
{
	=関連情報
	*[XPathすごいね|2008/0214.w]
}
