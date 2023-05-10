--WAIT!! DON'T LOOK!!

textthing = 0;
thefunny = 'whar';

function onCreate()
	textthing = getRandomInt(1,8);
end

function onCreatePost()
	if textthing == 1 then
		thefunny = 'lets shit metal'
	elseif textthing == 2 then
		thefunny = 'my balls itch'
	elseif textthing == 3 then
		thefunny = 'the                                                                                       yes'
	elseif textthing == 4 then
		thefunny = '            yoy'
	elseif textthing == 5 then
		thefunny = 'legalize nuclear bombs'
	elseif textthing == 6 then
		thefunny = 'hey alexa, play mu_war.wav'
	elseif textthing == 7 then
		thefunny = 'I\'m using tilt controls!'
	elseif textthing == 8 then
		thefunny = 'source/Conductor.hx:135: new BPM map BUDDY []'
	end
end

function onCountdownTick(counter)
	--god damn
	if counter == 2 then
		makeLuaText('thetext', thefunny, 600, 335, 1500)
		setTextAlignment('thetext', 'center')
		setObjectCamera('thetext', 'other')
		setTextSize('thetext', 30)
		addLuaText('thetext')
		setTextFont('thetext', 'funy.ttf')
		doTweenY('showthefunny', 'thetext', 500, 1, 'sineOut')
		runTimer('unfunny', 3)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	--bye bye i think this is necessary to remove the sprite
	if tag == 'unfunny' then
		doTweenY('removethefunny', 'thetext', 1500, 1, 'sineIn')
	end
end

function onCreatePost()
    setTextFont('scoreTxt', 'funy.ttf')
    setTextFont('botplayTxt', 'funy.ttf')
    setTextFont('timeTxt', 'funy.ttf')
end
