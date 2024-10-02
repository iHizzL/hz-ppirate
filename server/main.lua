local QBCore = exports['qb-core']:GetCoreObject()
local openingPlayers = {}

QBCore.Functions.CreateUseableItem("mystery_box", function(source)
    local src = source
    if openingPlayers[src] then
        TriggerClientEvent('QBCore:Notify', src, 'You are already opening a package!', 'error')
        return
    end

    openingPlayers[src] = true
    TriggerClientEvent("fivem-package-spawn:client:openPackage", src)
end)

-- Function to get a random item based on probabilities
local function getRandomItem()
    local rand = math.random()
    local cumulativeProbability = 0
    
    for _, item in ipairs(Config.Items) do
        cumulativeProbability = cumulativeProbability + item.probability
        if rand <= cumulativeProbability then
            return item.name
        end
    end
    
    return Config.Items[#Config.Items].name -- Return last item if nothing else is selected
end

-- Event handler for picking up a package
RegisterNetEvent('fivem-package-spawn:server:pickupPackage')
AddEventHandler('fivem-package-spawn:server:pickupPackage', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if Player.Functions.AddItem("mystery_box", 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["mystery_box"], "add")
            TriggerClientEvent('QBCore:Notify', src, 'You picked up a mystery box', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Your inventory is full!', 'error')
        end
    end
end)

-- Event handler for opening a package
RegisterNetEvent('fivem-package-spawn:server:openPackage')
AddEventHandler('fivem-package-spawn:server:openPackage', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if Player.Functions.RemoveItem("mystery_box", 1) then
            local item = getRandomItem()
            
            if Player.Functions.AddItem(item, 1) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["mystery_box"], "remove")
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
                TriggerClientEvent('QBCore:Notify', src, 'You found: ' .. QBCore.Shared.Items[item].label, 'success')
                
                if Config.Debug then
                    print('Player ' .. Player.PlayerData.name .. ' received: ' .. QBCore.Shared.Items[item].label)
                end
            else
                Player.Functions.AddItem("mystery_box", 1) -- Give the box back if inventory is full
                TriggerClientEvent('QBCore:Notify', src, 'Your inventory is full!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have a mystery box to open!', 'error')
        end
    end
    openingPlayers[src] = nil
end)

-- Debug command to get item probabilities
if Config.Debug then
    RegisterCommand('itemprobs', function(source)
        for _, item in ipairs(Config.Items) do
            print(QBCore.Shared.Items[item.name].label .. ': ' .. (item.probability * 100) .. '%')
        end
    end, false)
end

-- Cleanup opening status when player disconnects
AddEventHandler('playerDropped', function(reason)
    local src = source
    openingPlayers[src] = nil
end)