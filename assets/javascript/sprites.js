var incrementer = null;

function incrementFrame(sprite, frames) {
	console.log('incrementFrame');
	var div = $('#' + sprite);

	// Get current frame
	var classes = div.attr('class').split(" ");
	console.log(classes);
	for (var c in classes) {
		var cc = classes[c];
		if (cc.startsWith('frame-')) {
			var frameNum = parseInt(cc.split('frame-')[1]);
			frameNum ++;
			if (frameNum >= frames) {
				frameNum = 0;
				// clearInterval(incrementer);
				// incrementer = null;
			}
			div.removeClass(cc);
			div.addClass('frame-' + frameNum);
			break;
		}
	}	
}

function animate(sprite, animation) {
	var div = $('#' + sprite);
	div.addClass('anim-' + animation);	

	incrementer = setInterval(function() {
		incrementFrame(sprite, anim_frames[animation]);		
	}, 60);
}