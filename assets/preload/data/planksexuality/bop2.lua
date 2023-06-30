local angleshit = 1.5;

local anglevar = 1.5;

function opponentNoteHit(id, direction, noteType, isSustainNote)

if difficulty == 2 then

if curBeat < 2 then

if curBeat > 240 then

cameraShake('cam', '0.015', '0.1')

end

end

end

end

function onBeatHit()

    if curBeat > 2 then

        if curBeat % 2 == 0 then

            angleshit = anglevar;

        else

            angleshit = -anglevar;

        end

        setProperty('camHUD.y',angleshit*6)

        setProperty('camGame.y',angleshit*6)

        doTweenY('turn', 'camHUD', angleshit, stepCrochet*0.004, 'circOut')

        doTweenY('tt', 'camGame', angleshit, stepCrochet*0.004, 'circOut')

    end

end

