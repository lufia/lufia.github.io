$(function(){
	$("nav").each(function(){
		setGradient(this, "#999999", "#000000", 0)
	})
	$("nav li a").each(function(){
		var t = location.href.substring(0, this.href.length)
		if(t == this.href)
			setGradient(this.parentNode, "#000000", "#666666")
	})

	$("article h2, aside h1").each(function(){
		setGradient(this, "#555555", "#000000", 0)
	})
	$("a[href=http://qa-dev.w3.org/wmvs/HEAD/]").each(function(){
		this.href += "check?uri=" + escape(location.href)
	})
})
