/*
 * original source:
 * http://www.hedgerwow.com/360/dhtml/dom-gradient-background/demo.php
 *
 * I HATE THE HUNGARIAN NOTATION!
 *
 * setGradiant: fn(e: Element, c1, c2: string, d: int);
 *	if d is 0, x-direction, otherwise y-direction
 */
var setGradient = function(){
	var canvas = document.createElement('canvas')
	var useCanvas =  !!(typeof(canvas.getContext) == 'function')
	var ctxt = useCanvas ? canvas.getContext('2d') : null

	try{
		ctxt.canvas.toDataURL()
	}catch(e){
		useCanvas = false;
	}

	if(useCanvas){
		return function(e , c1 , c2 , d){
			if(typeof(e) == 'string')
				e =  document.getElementById(e)
			if(!e)
				return false
			var w = canvas.width = e.offsetWidth
			var h = canvas.height = e.offsetHeight

			var g, s
			if(d){
				g = ctxt.createLinearGradient(0, 0, w, 0)
				s = 'repeat-y'
			}else{
				g = ctxt.createLinearGradient(0, 0, 0, h)
				s = 'repeat-x'
			}
			g.addColorStop(0, c1);
			g.addColorStop(1, c2);
			ctxt.fillStyle = g ;
			ctxt.fillRect(0, 0, w, h);
			var url = ctxt.canvas.toDataURL('image/png');

			with(e.style){
				backgroundRepeat = s;
				backgroundImage = 'url(' + url + ')';
				backgroundColor = c2;
			}
		}
	}else if(/*@cc_on!@*/false){	// Internet Explorer only
		canvas = useCanvas = ctxt =  null
		return function(e , c1 , c2 , d){
			if(typeof(e) == 'string')
				e =  document.getElementById(e)
			if(!e)
				return false
			e.style.zoom = 1
			var sF = e.currentStyle.filter		// ??
			e.style.filter += ' ' + [
				'progid:DXImageTransform.Microsoft.gradient(',
					'GradientType=',	+(!!d),
					',Enabled=',		'true',
					',StartColorStr=',	c1,
					',EndColorStr=',		c2,
				')'
			].join('')
		}
	}else{
		canvas = useCanvas = ctxt =  null
		return function(e , c1 , c2){
			if(typeof(e) == 'string')
				e =  document.getElementById(e)
			if(!e)
				return false
			with(e.style)
				 backgroundColor = c2
		}
	}
}()
