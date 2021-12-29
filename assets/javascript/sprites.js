var incrementer = null;

function clearFrames(sprite) {
	var div = $('#' + sprite);

	// Get current frame
	var classes = div.attr('class').split(" ");	
	for (var c in classes) {
		var cc = classes[c];
		if (cc.startsWith('frame-')) {
			div.removeClass(cc);
		}
		if (cc.startsWith('anim-')) {
			div.removeClass(cc);
		}
	}
}

function incrementFrame(sprite, frames, loop) {
	console.log('incrementFrame');
	var div = $('#' + sprite);

	// Get current frame
	var classes = div.attr('class').split(" ");	
	for (var c in classes) {
		var cc = classes[c];
		if (cc.startsWith('frame-')) {
			var frameNum = parseInt(cc.split('frame-')[1]);
			frameNum ++;
			var remove = false;
			if (frameNum >= frames) {
				frameNum = 0;
				if (!loop) {
					clearInterval(incrementer);
					incrementer = null;
				} else {
					remove = true;
				}
			} else {
				remove = true;
			}
			if (remove) {
				div.removeClass(cc);
				div.addClass('frame-' + frameNum);
			}			
			break;
		}
	}	
}

function configureSprite(sprite) {
	var link = $('<link></link>');
	link.attr('rel', "stylesheet");
	link.attr('href', "assets/css/gen/" + sprite + ".css");
	$('head').append(link);

	var div = $('<div></div>');
	div.addClass(sprite);
	div.addClass('frame-0');
	div.attr('id', sprite);	
	$('body').append(div);	
}

function animate(sprite, animation, loop) {
	
	if (incrementer != null) {
		clearInterval(incrementer);
		incrementer = null;
	}
	clearFrames(sprite);
	
	var div = $('#' + sprite);
	div.addClass('frame-0');
	div.addClass('anim-' + animation);		

	incrementer = setInterval(function() {
		incrementFrame(sprite, anim_frames[sprite][animation], loop);		
	}, 60);
}