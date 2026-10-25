# Roblox Toolkit

Полезные и чистые модули для разработки игр в Roblox.

Готовые системы, которые можно просто вставить в свой проект и сразу использовать.

## Что внутри

| Модуль | Описание |
|--------|----------|
| `DataManager` | Удобная работа с DataStore (сохранение и загрузка данных игрока) |
| `Notify` | Красивые уведомления для игроков |
| `AdminCommands` | Простая система админ-команд |
| `PlayerStats` | Система статистики игрока (монеты, уровень и т.д.) |
| `Cooldown` | Удобная система задержек (кулдаунов) |

## Как использовать

1. Скачай нужные модули
2. Положи их в `ReplicatedStorage` или `ServerScriptService`
3. Подключай через `require`

### Пример с DataManager

```lua
local DataManager = require(path.to.DataManager)

-- При входе игрока
game.Players.PlayerAdded:Connect(function(player)
    local data = DataManager.Load(player)
    print("Монеты игрока:", data.Coins)
end)

-- При выходе
game.Players.PlayerRemoving:Connect(function(player)
    DataManager.Save(player)
end)
```

### Пример уведомления

```lua
local Notify = require(path.to.Notify)

Notify.Success(player, "Вы получили 100 монет!")
Notify.Error(player, "Недостаточно средств")
Notify.Info(player, "Сервер перезагрузится через 5 минут")
```

## Структура

```
roblox-toolkit/
├── Modules/
│   ├── DataManager.lua
│   ├── Notify.lua
│   ├── AdminCommands.lua
│   ├── PlayerStats.lua
│   └── Cooldown.lua
└── README.md
```

## Для кого это

- Новички, которым нужны готовые рабочие системы
- Разработчики, которые не хотят каждый раз писать одно и то же
- Те, кто ценит чистый и понятный код

---

Можно свободно использовать в своих играх.
