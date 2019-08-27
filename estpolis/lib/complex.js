function inner(cat, url)
{
	var a = ['boss', 'char', 'item', 'magic', 'map', 'monster', 'stuff']

	if(cat == url)
		return true;

	var s = cat.replace(/.*\/estpolis\//, '').replace(/\/.*/, '')
	var t = url.replace(/.*\/estpolis\//, '').replace(/\/.*/, '')
	if(s != 'db.html')
		return s == t
	for(var i = 0; i < a.length; i++)
		if(a[i] == t)
			return true
	return false
}

$(function(){
	$('nav').each(function(){
		setGradient(this, '#4169e1', '#00008b', 0)
	})
	$('nav li a').each(function(){
		if(inner(this.href, location.href))
			setGradient(this.parentNode, '#00008b', '#4169e1')
	})

	$('article h2, aside h1').each(function(){
		setGradient(this, '#4169e1', '#00008b', 0)
	})
	$('a[href=http://qa-dev.w3.org/wmvs/HEAD/]').each(function(){
		this.href += 'check?uri=' + escape(location.href)
	})
})
