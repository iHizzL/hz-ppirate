local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPackages = {}
local isPickingUp = false

-- Function to check if a location is occupied
local function isLocationOccupied(location)
    for _, package in ipairs(spawnedPackages) do
        if package.location == location then
            return true
        end
    end
    return false
end

-- Function to check if any player is near a location
local function isPlayerNearby(coords)
    local players = QBCore.Functions.GetPlayers()
    for _, player in ipairs(players) do
        local ped = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(ped)
        if #(playerCoords - coords) <= Config.PlayerProximityCheck then
            return true
        end
    end
    return false
end

-- Function to get an available spawn location
local function getAvailableLocation()
    local availableLocations = {}
    for _, location in ipairs(Config.SpawnLocations) do
        if not isLocationOccupied(location) and not isPlayerNearby(vector3(location.x, location.y, location.z), 50.0) then
            table.insert(availableLocations, location)
        end
    end
    
    if #availableLocations > 0 then
        return availableLocations[math.random(#availableLocations)]
    end
    return nil
end

-- Function to spawn a package
local function spawnPackage()
    if #spawnedPackages >= Config.MaxPackages then return end

    local location = getAvailableLocation()
    if not location then return end  -- No available locations

    local model = Config.PackageModels[math.random(#Config.PackageModels)]
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(1)
    end
    
    local package = CreateObject(GetHashKey(model), location.x, location.y, location.z - 1.0, false, false, false)
    SetEntityHeading(package, location.w)
    PlaceObjectOnGroundProperly(package)
    FreezeEntityPosition(package, true)
    
    local packageData = {
        object = package,
        location = location,
        spawnTime = GetGameTimer()
    }
    table.insert(spawnedPackages, packageData)
    
    -- Add interaction with ox_target
    exports.ox_target:addLocalEntity(package, {
        {
            name = 'pickup_package',
            icon = 'fas fa-box-open',
            label = 'Pick Up Package',
            onSelect = function()
                if not isPickingUp then
                    pickupPackage(packageData)
                end
            end
        }
    })
end

-- Function to pick up a package
function pickupPackage(packageData)
    if isPickingUp then return end
    isPickingUp = true

    if lib.progressBar({
        duration = 2000,
        label = 'Picking up package...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer'
        },
    }) then
        TriggerServerEvent('fivem-package-spawn:server:pickupPackage')
        removePackage(packageData)
    else
        QBCore.Functions.Notify('Package pickup cancelled', 'error')
    end

    isPickingUp = false
end

-- Function to remove a package
function removePackage(packageData)
    for i, spawnedPackage in ipairs(spawnedPackages) do
        if spawnedPackage == packageData then
            exports.ox_target:removeLocalEntity(packageData.object, {'pickup_package'})
            DeleteObject(packageData.object)
            table.remove(spawnedPackages, i)
            break
        end
    end
end

-- Function to check and despawn old packages
local function checkPackageDespawn()
    local currentTime = GetGameTimer()
    for i = #spawnedPackages, 1, -1 do
        local packageData = spawnedPackages[i]
        if currentTime - packageData.spawnTime > Config.DespawnTime then
            removePackage(packageData)
        end
    end
end

-- Main thread for spawning packages and checking despawn
Citizen.CreateThread(function()
    while true do
        spawnPackage()
        checkPackageDespawn()
        Citizen.Wait(Config.SpawnInterval)
    end
end)

-- Cleanup function
local function cleanupPackages()
    for _, packageData in ipairs(spawnedPackages) do
        if DoesEntityExist(packageData.object) then
            DeleteObject(packageData.object)
        end
    end
    spawnedPackages = {}
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    cleanupPackages()
end)

-- Debug commands
if Config.Debug then
    RegisterCommand('spawnpackage', function()
        spawnPackage()
        print('Package spawned')
    end, false)

    RegisterCommand('clearpackages', function()
        cleanupPackages()
        print('All packages cleared')
    end, false)
end

-- Event handler for opening a package
RegisterNetEvent('fivem-package-spawn:client:openPackage')
AddEventHandler('fivem-package-spawn:client:openPackage', function()
    local boxProp = nil
    local ped = PlayerPedId()
    
    -- Create and attach box prop to player's hand
    local boxModel = 'prop_cs_cardbox_01'
    RequestModel(GetHashKey(boxModel))
    while not HasModelLoaded(GetHashKey(boxModel)) do
        Wait(10)
    end
    boxProp = CreateObject(GetHashKey(boxModel), 0, 0, 0, true, true, true)
    AttachEntityToEntity(boxProp, ped, GetPedBoneIndex(ped, 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)

    if lib.progressBar({
        duration = Config.OpeningDuration,
        label = 'Opening package...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@heists@ornate_bank@grab_cash',
            clip = 'grab'
        },
    }) then
        TriggerServerEvent('fivem-package-spawn:server:openPackage')
    else
        QBCore.Functions.Notify('Package opening cancelled', 'error')
    end
    
    -- Remove box prop
    if DoesEntityExist(boxProp) then
        DeleteObject(boxProp)
    end
end)