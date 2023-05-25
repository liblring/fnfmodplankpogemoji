function opponentNoteHit()
    if getProperty('health') > 0.2 then
        setProperty('health', getProperty('health') - 0.03);
    end
end