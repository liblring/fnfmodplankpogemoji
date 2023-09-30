-- Base Detect
local defaultVert = 'Up'
local defaultHori = 'Side'
local Vertical = 'off'
local Horizontal = 'off'
local sectionCheck = 'watiting...'
function onUpdatePost()
	-- Up and Downscroll
	if Vertical == 'off' then
		if downscroll then
			noteTweenDirection('scrollDir0', 0, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir1', 1, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir2', 2, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir3', 3, -90, 1, 'elasticOut')
			
			noteTweenDirection('scrollDir4', 4, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir5', 5, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir6', 6, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir7', 7, -90, 1, 'elasticOut')

			noteTweenY('moveNoteY0', 0, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY1', 1, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY2', 2, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY3', 3, 150, 1, 'elasticOut')

			noteTweenY('moveNoteY4', 4, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY5', 5, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY6', 6, 150, 1, 'elasticOut')
			noteTweenY('moveNoteY7', 7, 150, 1, 'elasticOut')
		else
			noteTweenDirection('scrollDir0', 0, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir1', 1, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir2', 2, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir3', 3, 90, 1, 'elasticOut')

			noteTweenDirection('scrollDir4', 4, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir5', 5, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir6', 6, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir7', 7, 90, 1, 'elasticOut')
			
			noteTweenY('moveNoteY0', 0, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY1', 1, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY2', 2, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY3', 3, 50, 1, 'elasticOut')

			noteTweenY('moveNoteY4', 4, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY5', 5, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY6', 6, 50, 1, 'elasticOut')
			noteTweenY('moveNoteY7', 7, 50, 1, 'elasticOut')
		end
	elseif Vertical == 'on' then
		if downscroll then
			noteTweenDirection('scrollDir0', 0, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir1', 1, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir2', 2, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir3', 3, 90, 1, 'elasticOut')

			noteTweenDirection('scrollDir4', 4, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir5', 5, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir6', 6, 90, 1, 'elasticOut')
			noteTweenDirection('scrollDir7', 7, 90, 1, 'elasticOut')

			noteTweenY('moveNoteY0', 0, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY1', 1, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY2', 2, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY3', 3, 570, 1, 'elasticOut')

			noteTweenY('moveNoteY4', 4, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY5', 5, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY6', 6, 570, 1, 'elasticOut')
			noteTweenY('moveNoteY7', 7, 570, 1, 'elasticOut')
		else
			noteTweenDirection('scrollDir0', 0, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir1', 1, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir2', 2, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir3', 3, -90, 1, 'elasticOut')

			noteTweenDirection('scrollDir4', 4, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir5', 5, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir6', 6, -90, 1, 'elasticOut')
			noteTweenDirection('scrollDir7', 7, -90, 1, 'elasticOut')

			noteTweenY('moveNoteY0', 0, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY1', 1, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY2', 2, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY3', 3, 500, 1, 'elasticOut')

			noteTweenY('moveNoteY4', 4, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY5', 5, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY6', 6, 500, 1, 'elasticOut')
			noteTweenY('moveNoteY7', 7, 500, 1, 'elasticOut')
		end
	end

	-- Side and Middlescroll
	if Horizontal == 'off' then
		noteTweenX('moveNoteX0', 0, 92, 1, 'elasticOut');
		noteTweenX('moveNoteX1', 1, 204, 1, 'elasticOut');
		noteTweenX('moveNoteX2', 2, 316, 1, 'elasticOut');
		noteTweenX('moveNoteX3', 3, 428, 1, 'elasticOut');
    
		noteTweenX('moveNoteX4', 4, 732, 1, 'elasticOut');
		noteTweenX('moveNoteX5', 5, 844, 1, 'elasticOut');
		noteTweenX('moveNoteX6', 6, 956, 1, 'elasticOut');
		noteTweenX('moveNoteX7', 7, 1068, 1, 'elasticOut');
    
		noteTweenAlpha('alphaNote0', 0, 1, 1, 'linear')
		noteTweenAlpha('alphaNote1', 1, 1, 1, 'linear')
		noteTweenAlpha('alphaNote2', 2, 1, 1, 'linear')
		noteTweenAlpha('alphaNote3', 3, 1, 1, 'linear')
	elseif Horizontal == 'on' then
		noteTweenX('moveNoteX0', 0, 92, 1, 'elasticOut');
		noteTweenX('moveNoteX1', 1, 204, 1, 'elasticOut');
		noteTweenX('moveNoteX2', 2, 956, 1, 'elasticOut');
		noteTweenX('moveNoteX3', 3, 1068, 1, 'elasticOut');

		noteTweenX('moveNoteX4', 4, 416, 1, 'elasticOut');
		noteTweenX('moveNoteX5', 5, 528, 1, 'elasticOut');
		noteTweenX('moveNoteX6', 6, 640, 1, 'elasticOut');
		noteTweenX('moveNoteX7', 7, 752, 1, 'elasticOut');
		
		noteTweenAlpha('alphaNote0', 0, 0.5, 1, 'linear')
		noteTweenAlpha('alphaNote1', 1, 0.5, 1, 'linear')
		noteTweenAlpha('alphaNote2', 2, 0.5, 1, 'linear')
		noteTweenAlpha('alphaNote3', 3, 0.5, 1, 'linear')
	end
end

function onCreate()
	if not downscroll then
		Vertical = 'off'
		defaultVert = 'Up'
	else
		Vertical = 'on'
		defaultVert = 'Down'
	end
	if not middlescroll then
		Horizontal = 'off'
		defaultHori = 'Side'
	else
		Horizontal = 'on'
		defaultHori = 'Middle'
	end
end

function onCreatePost()
	doTweenAlpha('title0', 'titlingthisshit', 0, 0.001, 'elasticInOut')
	doTweenAlpha('vert0', 'Vert', 0, 0.001, 'elasticInOut')
	doTweenAlpha('hori0', 'Hori', 0, 0.001, 'elasticInOut')
	doTweenAlpha('secCheck0', 'sectionCheck', 0, 0.001, 'elasticInOut')
end

function onEvent(name, value1, value2)
	if name == 'Change Scrolltype' then
		-- Vertical Scrolltypes
		if value1 == 'off' then -- Switch to Upscroll
			Vertical = 'off'
		elseif value1 == 'on' then -- Switch to Downscroll
			Vertical = 'on'
		elseif value1 == 'swap' then -- Swap between Up and Downscroll
			if Vertical == 'on' then -- Downscroll Check
				Vertical = 'off'
			elseif Vertical == 'off' then -- Upscroll Check
				Vertical = 'on'
			end
		elseif value1 == 'default' then -- Switch Back to Default Scrolltype
			if not downscroll then
				Vertical = 'off'
			else
				Vertical = 'on'
			end
		end

		-- Horizontal Scrolltypes
		if value2 == 'off' then -- Switch to Sidescroll
			Horizontal = 'off'
		elseif value2 == 'on' then -- Switch to Middlescroll
			Horizontal = 'on'
		elseif value2 == 'swap' then -- Swap between Side and Middlescroll
			if Horizontal == 'on' then -- Middlescroll Check
				Horizontal = 'off'
			elseif Horizontal == 'off' then -- Sidescroll Check
				Horizontal = 'on'
			end
		elseif value2 == 'default' then -- Switch Back to Default Scrolltype
			if not middlescroll then
				Horizontal = 'off'
			else
				Horizontal = 'on'
			end
		end

		-- Weird Shit but it's cool - Doesn't work properly tho will make a on a separate script
		if value2 == 'unfunny' then
			addLuaScript('scripts/scrolltypes/funnyStuffMan')
			doTweenAlpha('secCheckShow', 'sectionCheck', 1, 50, 'elasticInOut')
		elseif value2 == 'funny' then
			removeLuaScript('scripts/scrolltypes/funnyStuffMan')
			doTweenAlpha('secCheckHide', 'sectionCheck', 1, 50, 'elasticInOut')
		end
	end
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think

	if counter == 3 then --Go!
		doTweenAlpha('title1', 'titlingthisshit', 1, 1, 'elasticInOut')
		doTweenAlpha('vert1', 'Vert', 1, 1, 'elasticInOut')
		doTweenAlpha('hori1', 'Hori', 1, 1, 'elasticInOut')
	end

	--[[if counter == 4 then --Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter == 2 then --One
	if counter == 0 then --Two]]
end