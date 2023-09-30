bpm = 4
bam = 1

function onEvent(name, v1, v2)
    if (name == 'CamBoomSpeed') then
        bpm = tonumber(v1)
        bam = tonumber(v2)
    end
end

function onBeatHit()
    if (curBeat % bpm == 0) then
        triggerEvent('Add Camera Zoom', 0.015 * bam, 0.03 * bam)
    end
end