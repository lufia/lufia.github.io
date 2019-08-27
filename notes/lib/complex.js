function wrap(write)
{
	var orig = document.write
	var cout = ''
	document.write = function(s){
		cout += s
	}
	write()
	document.write = orig
	return cout
}

$(function(){
	$('nav').each(function(){
		setGradient(this, '#965042', '#763012', 0)
	})

	$('a[href=http://qa-dev.w3.org/wmvs/HEAD/]').each(function(){
		this.href += 'check?uri=' + escape(location.href)
	})

	var s = wrap(function(){
		writeSqexAvatarTag('', '', '', '', '8d2fed28fd4440cad2b8788df08fe45c')
	})
	$('aside:last').append(s)
})
