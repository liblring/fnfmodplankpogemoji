function onUpdate(e)
	local angleOfs = math.random(-10, 10)
	local angleOf1s = math.random(-0.75, 0.75)
	if getProperty('healthBar.percent') < 20 then
		setProperty('iconP1.angle', angleOfs)
	else
		setProperty('iconP1.angle', angleOf1s)
	end
end