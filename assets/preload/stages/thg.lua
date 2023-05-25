

function onCreate()
	setProperty('skipCountdown', true);
	makeLuaSprite('black','',-600,-200);
	makeGraphic('black',4000,4000,'000000');
	scaleObject('black',1.5,1.5);
	setScrollFactor('black', 0.1, 0.1);
end

function onStepHit()
if curStep == 1 then
     noteTweenAlpha('NoteALpha0', 0, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha1', 1, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha2', 2, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha3', 3, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha4', 4, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha5', 5, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha6', 6, 0, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha7', 7, 0, 0.1, cubeOut)
end
if curStep == 16 then
     noteTweenAlpha('NoteALpha0', 0, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha1', 1, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha2', 2, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha3', 3, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha4', 4, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha5', 5, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha6', 6, 1, 0.1, cubeOut)
      noteTweenAlpha('NoteALpha7', 7, 1, 0.1, cubeOut)
end
if curStep == 272 then
 doTweenZoom('asf', 'camGame', 1.1, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 512 then
 doTweenZoom('asf', 'camGame', 1.2, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 528 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 536 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 544 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 548 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 552 then
 doTweenZoom('asf', 'camGame', 1.1, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 556 then
 doTweenZoom('asf', 'camGame', 1.05, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1)
			
	end
if curStep == 576 then
 doTweenZoom('asf', 'camGame', 1.2, 1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 592 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 600 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 608 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 612 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 616 then
 doTweenZoom('asf', 'camGame', 1.1, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 620 then
 doTweenZoom('asf', 'camGame', 1.05, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1)
			
	end
if curStep == 640 then
 doTweenZoom('asf', 'camGame', 1.2, 1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 912 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 920 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 928 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 932 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 936 then
 doTweenZoom('asf', 'camGame', 1.1, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 940 then
 doTweenZoom('asf', 'camGame', 1.05, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1)
			
	end
if curStep == 960 then
 doTweenZoom('asf', 'camGame', 1.2, 1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 976 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 984 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 992 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 996 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1000 then
 doTweenZoom('asf', 'camGame', 1.1, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 1004 then
 doTweenZoom('asf', 'camGame', 1.05, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1)
			
	end
if curStep == 1024 then
 doTweenZoom('asf', 'camGame', 1.2, 1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1040 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 1048 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 1056 then
 doTweenZoom('asf', 'camGame', 1.35, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.35)
			
	end
if curStep == 1060 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 1064 then
 doTweenZoom('asf', 'camGame', 1.25, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.25)
			
	end
if curStep == 1068 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1072 then
 doTweenZoom('asf', 'camGame', 1.1, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 1088 then
 doTweenZoom('asf', 'camGame', 1.2, 1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1104 then
 doTweenZoom('asf', 'camGame', 1.3, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 1112 then
 doTweenZoom('asf', 'camGame', 1.4, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
if curStep == 1120 then
 doTweenZoom('asf', 'camGame', 1.35, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.35)
			
	end
if curStep == 1124 then
 doTweenZoom('asf', 'camGame', 1.3, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.3)
			
	end
if curStep == 1128 then
 doTweenZoom('asf', 'camGame', 1.25, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.25)
			
	end
if curStep == 1132 then
 doTweenZoom('asf', 'camGame', 1.2, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1136 then
 doTweenZoom('asf', 'camGame', 1.1, 0.5, 'cubeOut')
        setProperty('defaultCamZoom', 1.1)
			
	end
if curStep == 1152 then
 doTweenZoom('asf', 'camGame', 1.16, 0.3, 'cubeOut')
        setProperty('defaultCamZoom', 1.16)
			
	end
if curStep == 1157 then
 doTweenZoom('asf', 'camGame', 1.17, 0.1, 'cubeOut')
        setProperty('defaultCamZoom', 1.17)
			
	end
if curStep == 1158 then
 doTweenZoom('asf', 'camGame', 1.18, 0.1, 'cubeOut')
        setProperty('defaultCamZoom', 1.18)
			
	end
if curStep == 1159 then
 doTweenZoom('asf', 'camGame', 1.19, 0.1, 'cubeOut')
        setProperty('defaultCamZoom', 1.19)
			
	end
if curStep == 1160 then
 doTweenZoom('asf', 'camGame', 1.2, 0.1, 'cubeOut')
        setProperty('defaultCamZoom', 1.2)
			
	end
if curStep == 1164 then
     noteTweenAlpha('NoteALpha0', 0, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha1', 1, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha2', 2, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha3', 3, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha4', 4, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha5', 5, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha6', 6, 0, 0.3, cubeOut)
      noteTweenAlpha('NoteALpha7', 7, 0, 0.3, cubeOut)
 doTweenAlpha('hp', 'healthBar', 0, duration, 'cubeOut')
            doTweenAlpha('icon1', 'iconP1', 0, 0.3, 'cubeOut')
            doTweenAlpha('icon2', 'iconP2', 0, 0.3, 'cubeOut')
            doTweenAlpha('hp', 'healthBar', 0, 0.3, 'cubeOut')
            doTweenAlpha('stuff', 'scoreTxt', 0, 0.3, 'linear')
            doTweenAlpha('broomtxt', 'timeTxt', 0, 0.3, 'cubeOut')
         doTweenAlpha('tb', 'timeBar', 0, 0.3, 'cubeOut')
     doTweenAlpha('bg', 'timeBarBG', 0, 0.3, 'cubeOut')
end
if curStep == 1426 then
 doTweenZoom('asf', 'camGame', 1.4, 0.1, 'cubeOut')
        setProperty('defaultCamZoom', 1.4)
			
	end
end