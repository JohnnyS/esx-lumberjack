local chopping = false
local LumberDepo = Config.Blips.LumberDepo
local LumberProcessor = Config.Blips.LumberProcessor
local LumberSeller = Config.Blips.LumberSeller
local ox_inventory = exports.ox_inventory

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    blips()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    Wait(100)
    blips()
end)

RegisterNetEvent('esx-lumberjack:getLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

local function axe()
    local hasAxe = ox_inventory:Search('slots', 'axe')
    if hasAxe then
        return true
    else
        ESX.ShowNotification(Config.Alerts["error_axe"])
        return false
    end
end

local function ChopLumber(k)
    local animDict = "melee@hatchet@streamed_core"
    local animName = "plyr_rear_takedown_b"
    local trClassic = PlayerPedId()
    local choptime = LumberJob.ChoppingTreeTimer
    chopping = true
    --FreezeEntityPosition(trClassic, true)
    TriggerServerEvent('esx-lumberjack:setLumberStage', "isOccupied", true, k)
    local success = exports['rcrp-minigame']:StartLockPickCircle(1, 15, success)
    if success then
        exports["esx_progressbar"]:Progressbar(Config.Alerts["chopping_tree"], 25000,{
            FreezePlayer = true, 
            animation ={
                type = "anim",
                dict = animDict, 
                lib = animName 
            }, 
        onFinish = function()
            TriggerServerEvent('esx-lumberjack:setLumberStage', "isChopped", true, k)
            TriggerServerEvent('esx-lumberjack:setLumberStage', "isOccupied", false, k)
            TriggerServerEvent('esx-lumberjack:recivelumber')
            TriggerServerEvent('esx-lumberjack:setChoppedTimer')
            chopping = false
            TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            FreezeEntityPosition(trClassic, false)
            end
        })
    else
        TriggerServerEvent('esx-lumberjack:setLumberStage', "isOccupied", false, k)
        exports['t-notify']:Custom({
            style  =  'error',
            duration  =  7000,
            message  =  'Did you miss your swing?',
            sound  =  true
        })
    end 
end

RegisterNetEvent('esx-lumberjack:StartChopping', function()
    for k, v in pairs(Config.TreeLocations) do
        if not Config.TreeLocations[k]["isChopped"] then
            if axe() then
                ChopLumber(k)
            end
        end
    end
end)

local sleep = 0
Citizen.CreateThread(function()
  while true do
    sleep = 1500
    local pedCoords = GetEntityCoords(PlayerPedId()) 
    for _, v in pairs(Config.TreeLocations) do
        local dst = #(pedCoords - v.coords)
        if dst < 2 then
            sleep = 0
            lib.showTextUI('[LALT] - Cut Tree', {
                position = "top-center",
                icon = 'tree',
                style = {
                    borderRadius = 0,
                    backgroundColor = '#1E7929',
                    color = 'white'
                }
            })
        end
    end
    Citizen.Wait(sleep)
   end
end)

CreateThread(function()
    for k, v in pairs(Config.TreeLocations) do
        exports["qtarget"]:AddBoxZone("trees" .. k, v.coords, 1.5, 1.5, {
            name = "trees" .. k,
            heading = 40,
            minZ = v.coords["z"] - 2,
            maxZ = v.coords["z"] + 2,
            debugPoly = false
        }, {
            options = {
                {
                    action = function()
                        if axe() then
                            ChopLumber(k)
                        end
                    end,
                    event = "esx-lumberjack:StartChopping",
                    icon = "fa fa-hand",
                    label = Config.Alerts["Tree_label"],
                    job = "lumberjack",
                    item = 'axe',
                    canInteract = function()
                        if v["isChopped"] or v["isOccupied"] then
                            return false
                        end
                        return true
                    end,
                }
            },
            distance = 1.0
        })
    end
end)

RegisterNetEvent('esx-lumberjack:vehicle', function()
    local vehicle = LumberDepo.Vehicle
    local coords = LumberDepo.VehicleCoords
    local TR = PlayerPedId()
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(0)
    end
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local JobVehicle = CreateVehicle(vehicle, coords, 45.0, true, false)
        SetVehicleHasBeenOwnedByPlayer(JobVehicle,  true)
        SetEntityAsMissionEntity(JobVehicle,  true,  true)
        Plate = GetVehicleNumberPlateText(JobVehicle)
        veh_name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(JobVehicle)))
        Config.FuelSystem(JobVehicle, 100.0)
        exports['t1ger_keys']:SetVehicleLocked(JobVehicle, 0)
        exports['t1ger_keys']:GiveTemporaryKeys(Plate, veh_name, "LumberJack Vehicle")
        local id = NetworkGetNetworkIdFromEntity(JobVehicle)
        DoScreenFadeOut(1500)
        Wait(1500)
        SetNetworkIdCanMigrate(id, true)
        TaskWarpPedIntoVehicle(TR, JobVehicle, -1)
        DoScreenFadeIn(1500)
    else
        ESX.ShowNotification(Config.Alerts["depo_blocked"], "error")
    end
end)

RegisterNetEvent('esx-lumberjack:removevehicle', function()
    local TR92 = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(TR92,true)
    SetEntityAsMissionEntity(TR92,true)
    DeleteVehicle(vehicle)
    ESX.ShowNotification(Config.Alerts["depo_stored"])
end)

RegisterNetEvent('esx-lumberjack:getaxe', function()
    TriggerServerEvent('esx-lumberjack:BuyAxe')
end)

RegisterNetEvent('esx-lumberjack:bossmenu', function()
    lib.registerContext({
        id = 'VehicleMenu',
        title = Config.Alerts["vehicle_header"],
        options = {
            {
                title = Config.Alerts["vehicle_text"],
                arrow = true,
                event = 'esx-lumberjack:vehicle',
            },
            {
                title = Config.Alerts["remove_text"],
                arrow = true,
                event = 'esx-lumberjack:removevehicle',
            },
        },
    })
    lib.showContext('VehicleMenu')
end)

RegisterNetEvent('esx-lumberjack:processormenu', function()
    lib.registerContext({
        id = 'processormenu',
        title = Config.Alerts["lumber_mill"],
        options = {
            {
                title = Config.Alerts["lumber_text"],
                arrow = true,
                event = 'esx-lumberjack:processor',
            },
            {
                title = Config.Alerts["battleaxe_text"],
                arrow = true,
                event = 'esx-lumberjack:getaxe',
            },
        },
    })
    lib.showContext('processormenu')
end)

RegisterNetEvent('esx-lumberjack:processor', function()
    local ped = PlayerPedId()
    ESX.TriggerServerCallback('esx-lumberjack:lumber', function(lumber)
        if lumber then
            TriggerServerEvent("esx-lumberjack:lumberprocessed")
            ClearPedTasks(ped)
        else
            ESX.ShowNotification(Config.Alerts['error_lumber'])
        end
    end)
end)
