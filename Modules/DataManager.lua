--[[
    DataManager.lua
    Удобная обёртка над DataStoreService
    Автор: roblox-toolkit
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataManager = {}

local DATASTORE_NAME = "PlayerData_v1"
local dataStore = DataStoreService:GetDataStore(DATASTORE_NAME)

-- Данные по умолчанию
local DEFAULT_DATA = {
    Coins = 0,
    Level = 1,
    XP = 0,
    Wins = 0,
    Settings = {
        Music = true,
        SFX = true,
    }
}

-- Кэш данных игроков
local cache = {}

local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function DataManager.Load(player: Player)
    if cache[player.UserId] then
        return cache[player.UserId]
    end

    local success, data = pcall(function()
        return dataStore:GetAsync("Player_" .. player.UserId)
    end)

    if success and data then
        -- Добавляем недостающие поля из DEFAULT_DATA
        for key, value in pairs(DEFAULT_DATA) do
            if data[key] == nil then
                data[key] = typeof(value) == "table" and deepCopy(value) or value
            end
        end
        cache[player.UserId] = data
    else
        cache[player.UserId] = deepCopy(DEFAULT_DATA)
        if not success then
            warn("[DataManager] Не удалось загрузить данные для", player.Name, data)
        end
    end

    return cache[player.UserId]
end

function DataManager.Save(player: Player)
    local data = cache[player.UserId]
    if not data then return false end

    local success, err = pcall(function()
        dataStore:SetAsync("Player_" .. player.UserId, data)
    end)

    if not success then
        warn("[DataManager] Ошибка сохранения для", player.Name, err)
    end

    return success
end

function DataManager.Get(player: Player)
    return cache[player.UserId] or DataManager.Load(player)
end

function DataManager.Update(player: Player, key: string, value: any)
    local data = DataManager.Get(player)
    data[key] = value
end

function DataManager.Add(player: Player, key: string, amount: number)
    local data = DataManager.Get(player)
    if type(data[key]) == "number" then
        data[key] += amount
        return data[key]
    end
    return nil
end

-- Автосохранение каждые 5 минут
task.spawn(function()
    while true do
        task.wait(300)
        for _, player in ipairs(Players:GetPlayers()) do
            DataManager.Save(player)
        end
    end
end)

-- Сохраняем при выходе
Players.PlayerRemoving:Connect(function(player)
    DataManager.Save(player)
    cache[player.UserId] = nil
end)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        DataManager.Save(player)
    end
end)

return DataManager
