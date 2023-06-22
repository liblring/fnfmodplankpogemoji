function onCreate()

	makeLuaSprite('barup', 'bdup', 0, -50)
	setObjectCamera('barup','camHUD')
	addLuaSprite('barup',true)

	makeLuaSprite('bardown', 'bddown', 0, -300)
	setObjectCamera('bardown','camHUD')
	addLuaSprite('bardown',true)
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end