zoom = 0
intensity = 0
defaultzoom = 0
intensed = false
zoomed = false
zooming = false

function onCreatePost()
	defaultzoom = getProperty('defaultCamZoom')
end

function onEvent(name, value1, value2)
	if name == 'Intense' then
		zoom = value1;
		intensity = value2;
		zooming = true;
		zoomed = false;
	if intensed == false then
   	  	 makeLuaSprite('bar', 'bars', 0, 730);
   		 setObjectCamera('bar', 'hud');
		 setObjectOrder('bar', getObjectOrder('strumLineNotes') - 9);
  		 addLuaSprite('bar', true);
   	  	 makeLuaSprite('bar2', 'bars', 0, -730);
   		 setObjectCamera('bar2', 'hud');
		 setObjectOrder('bar2', getObjectOrder('strumLineNotes') - 9);
  		 addLuaSprite('bar2', true);
		 doTweenY('tense','bar',730 - intensity,0.5,'sineOut');
		 doTweenY('tense2','bar2',-730 + intensity,0.5,'sineOut');
		doTweenZoom('zoomies', 'camGame', defaultzoom + zoom, 1, 'quadInOut');
		intensed = true;
	elseif intensed == true and intensity == 0 then
		doTweenZoom('zoomies', 'camGame', defaultzoom + zoom, 1, 'quadInOut');
		 doTweenY('tense','bar',730,0.5,'sineOut');
		 doTweenY('tense2','bar2',-730 + intensity,0.5,'sineOut');
		intensed = false;
	elseif intensed == true then
		doTweenZoom('zoomies', 'camGame', defaultzoom + zoom, 1, 'quadInOut');
		 doTweenY('tense','bar',730 - intensity,0.5,'sineOut');
		 doTweenY('tense2','bar2',-730 + intensity,0.5,'sineOut');
	end
    	end
    end
    
function onTweenCompleted(tag)
	if tag == 'zoomies' and zooming == true then
		zooming = false;
		doTweenZoom('keepzoom', 'camGame', defaultzoom + zoom, 0.01, 'linear');
	end
	if tag == 'keepzoom' and zoomed == true and zooming == false then
	if zoom == 0 then
		zoomed = false;
	else
		zoomed = true;
	end
		doTweenZoom('keepzoom', 'camGame', defaultzoom + zoom, 0.01, 'sineOut');
	end
end