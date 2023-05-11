function opponentNoteHit()
    if getProperty('health') > 0.2 then
        setProperty('health', getProperty('health') - 0.0085);
    end
end