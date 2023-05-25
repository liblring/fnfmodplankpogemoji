function onCreate()
    setProperty('camGame.alpha', 0)
end
function onStepHit()
    if curStep == 1 then
        doTweenAlpha('baller', 'camGame', 1, 2)
    end
    if curStep == 2608 then
        doTweenAlpha('eoaoeo', 'camHUD', 0, 0.75)
    end
    if curStep == 2620 then
        setProperty('camGame.visible', false)
    end
end