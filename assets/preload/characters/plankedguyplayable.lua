flipped = true
defaultY = 0
function onCreatePost()
	defaultY = getProperty('boyfriend.y')
end
function onBeatHit() 
	if getProperty('healthBar.percent') > 20 then
		flipped = not flipped
		setProperty('iconP1.flipX', flipped)
	end
end

function onStepHit() 
	if getProperty('healthBar.percent') < 20 and curStep % 2 == 0 then
		flipped = not flipped
		setProperty('iconP1.flipX', flipped)
	end
end

function onUpdate(e)
	local angleOfs = math.random(-5, 5)
	if getProperty('healthBar.percent') < 20 then
		setProperty('iconP1.angle', angleOfs)
	else
		setProperty('iconP1.angle', 0)
	end
end