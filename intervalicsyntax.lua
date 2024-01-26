g = grid.connect()
m = midi.connect()

intervals = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
interval = nil
lastPitch = nil

function init()
end

function g.key(x,y,z)
    if z == 1 then noteOn(x,y)
    elseif z == 0 then noteOff(x,y)
    end
    gridMap(x,y,z)
end

function noteOn(x,y)
    local pitch = 63 + x - (5 * y)
    if lastPitch ~= nil then
        interval = pitch - lastPitch + 12
        while interval <= 0 do
            interval = interval + 12
        end
        while interval >= 12 do
            interval = interval - 12
        end
    end
    lastPitch = pitch
    m:note_on(pitch, math.random(60, 100), 1)
    table.remove(intervals, getKeyFromValue(intervals, interval))
end

function noteOff(x,y)
    local pitch = 63 + x - (5 * y)
    m:note_off(pitch, 0, 1)
end

function getKeyFromValue(table, value)
    for key, val in pairs(table) do
        if val == value then
            return key
        end
    end
    return nil -- return nil if the value is not found
end

function gridMap(x,y,z)
    g:all(0)
    if #intervals == 0 then
        intervals = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
    end
    for i = 1, #intervals do
        for j = 1,16 do
            for k = 1,8 do
                if (63 + j - (5 * k)) % 12 == (lastPitch + intervals[i]) % 12 then
                    g:led(j,k,12)
                    if k == 8 then print(lastPitch, intervals[i]) end
                end
            end
        end
    end
    if z == 1 then
        g:led(x,y,16)
    end
    g:refresh()
end