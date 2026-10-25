--[[
    Cooldown.lua
    Простая и удобная система кулдаунов
]]

local Cooldown = {}
local active = {}

function Cooldown.Set(key: string, duration: number)
    active[key] = os.clock() + duration
end

function Cooldown.Check(key: string): boolean
    local expire = active[key]
    if not expire then
        return true -- кулдауна нет
    end

    if os.clock() >= expire then
        active[key] = nil
        return true
    end

    return false
end

function Cooldown.GetRemaining(key: string): number
    local expire = active[key]
    if not expire then
        return 0
    end

    local remaining = expire - os.clock()
    return remaining > 0 and remaining or 0
end

function Cooldown.Reset(key: string)
    active[key] = nil
end

function Cooldown.ResetAll()
    table.clear(active)
end

-- Пример использования:
-- if Cooldown.Check("Player_" .. player.UserId .. "_Ability") then
--     Cooldown.Set("Player_" .. player.UserId .. "_Ability", 5)
--     -- выполнить способность
-- else
--     print("Подождите ещё", Cooldown.GetRemaining(...), "сек.")
-- end

return Cooldown
