--WAIT!! DON'T LOOK!!

textthing = 0;
thefunny = 'whar';

function onCreate()
	textthing = getRandomInt(1,10);
end

function onCreatePost()
	if textthing == 1 then
		thefunny = 'CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON CANON '
	elseif textthing == 2 then
		thefunny = 'THIS ISNT A JOKE'
	elseif textthing == 3 then
		thefunny = 'OH BOY A HAMBURGOR, THANK YOU KIND SIR!'
	elseif textthing == 4 then
		thefunny = 'SHERRIFF COP FUNKS MOD WHEN                  YEA'
	elseif textthing == 5 then
		thefunny = 'YOU ARE A DICK'
	elseif textthing == 6 then
		thefunny = 'FUCK YOU!'
	elseif textthing == 7 then
		thefunny = 'FUFKCEKR BEST VLS BILBING CHARACTER'
	elseif textthing == 8 then
		thefunny = 'WHATS YOUR NAME DICK HEAD'
	elseif textthing == 9 then
		thefunny = 'OH NO, UH, OH NO AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
	elseif textthing == 10 then
		thefunny = 'YOU GOT DISK'
	end
end

function onCountdownTick(counter)
	--god damn
	if counter == 2 then
		makeLuaText('thetext', thefunny, 600, 335, 1500)
		setTextAlignment('thetext', 'center')
		setObjectCamera('thetext', 'other')
		setTextSize('thetext', 30)
		setTextFont('thetext', 'funy.ttf')
		addLuaText('thetext')
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