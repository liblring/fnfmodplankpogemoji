function onEvent(n,v1,v2)
	if flashingLights then
		if n == "Camera Flash" then
    		cameraFlash(camOther, v1, v2);
		end
	end
end