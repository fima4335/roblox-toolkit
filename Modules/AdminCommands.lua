--[[
    AdminCommands.lua
    Простая система админ-команд
]]

local Players = game:GetService("Players")

local AdminCommands = {}

-- Список админов (добавь свои UserId)
local ADMINS = {
    -- [123456789] = true,
}

local PREFIX = ";"

local commands = {}

function AdminCommands.IsAdmin(player: Player): boolean
    return ADMINS[player.UserId] == true or player.UserId == game.CreatorId
end

function AdminCommands.AddCommand(name: string, callback: (player: Player, args: {string}) -> ())
    commands[name:lower()] = callback
end

function AdminCommands.AddAdmin(userId: number)
    ADMINS[userId] = true
end

-- Встроенные команды
AdminCommands.AddCommand("kick", function(admin, args)
    local targetName = args[1]
    if not targetName then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #targetName) == targetName:lower() then
            player:Kick("Вы были кикнуты администратором.")
            break
        end
    end
end)

AdminCommands.AddCommand("speed", function(admin, args)
    local value = tonumber(args[1]) or 16
    local character = admin.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

AdminCommands.AddCommand("tp", function(admin, args)
    local targetName = args[1]
    if not targetName then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #targetName) == targetName:lower() then
            if admin.Character and player.Character then
                admin.Character:PivotTo(player.Character:GetPivot())
            end
            break
        end
    end
end)

AdminCommands.AddCommand("cmds", function(admin)
    local list = {}
    for name in pairs(commands) do
        table.insert(list, PREFIX .. name)
    end
    print("Доступные команды:", table.concat(list, ", "))
end)

-- Обработка сообщений
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if not AdminCommands.IsAdmin(player) then return end
        if message:sub(1, 1) ~= PREFIX then return end

        local args = string.split(message:sub(2), " ")
        local commandName = table.remove(args, 1)

        if commandName and commands[commandName:lower()] then
            commands[commandName:lower()](player, args)
        end
    end)
end)

return AdminCommands
