-- Note: Your Custom HUD That Moves Health Bar of Position will not work --

function onCreate()

    makeLuaSprite('customhb', 'Example', 0, 625)

    -- "customhb" Its the name of Sprite --
    -- "Example.png" Its the Image of Custom Health Bar, You can give other name, --
    -- But change the name in code --

    setObjectCamera('customhb', 'camHUD')
    addLuaSprite('customhb', true)
    screenCenter('customhb', 'x')

    -- If you don't know how to move positions in the code,
    -- then just make your cutom health bar with the same format as "Example.png"--

    setObjectOrder('customhb', getObjectOrder('healthBar') - 1)
    scaleObject('healthBar', 1, 1.3)
    setProperty('healthBarBG.visible', false)
    setProperty('healthBar.y', getProperty('healthBar.y') - 1)

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        setProperty('customhb.y', 63.5)
    end
end

-- All development was done by JogadorIce So Please, don't forget the credits --
-- But anyway, thank you very much for using my script :) --