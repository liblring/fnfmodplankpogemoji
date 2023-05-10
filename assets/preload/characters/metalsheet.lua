function onUpdate(e)
	local angleOfs = math.random(-90, 90)
	if getProperty('healthBar.percent') > 80 then
		setProperty('iconP2.angle', angleOfs)
	else
		setProperty('iconP2.angle', 0)
	end
end