function onCreate()

    setPropertyFromClass('openfl.Lib', 'application.window.title', 'vs FUFCKER ' .. "- " .. songName)
        makeLuaText('songName', "vs,, FUFCKER!!! - " .. songName, 1280, 11, 675)
        setTextBorder('songName', 2, '0xFF000000')
     setObjectCamera('songName','hud')
    setTextSize('songName', 18)
        addLuaText('songName')
        setTextFont('songName', 'funy.ttf')
        setTextAlignment('songName','left')
end

function onCreatePost()
    setTextFont('scoreTxt', 'funy.ttf')
    setTextFont('botplayTxt', 'funy.ttf')
    setTextFont('timeTxt', 'funy.ttf')
end