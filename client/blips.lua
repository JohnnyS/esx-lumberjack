local lumberdepo = nil
local lumberprocessing = nil
local lumbersell = nil
local TreeBlips = nil
local LumberYard = vector3(-528.3692, 5314.325, 92.68567)

function blips()
    if ESX.PlayerData and ESX.PlayerData.job.name == 'lumberjack' then
            lumberdepo = AddBlipForCoord(1167.73,-1347.27,33.92)
            SetBlipSprite(lumberdepo, 85)
            SetBlipDisplay(lumberdepo, 6)
            SetBlipScale(lumberdepo, 0.8)
            SetBlipColour(lumberdepo, 5)
            SetBlipAsShortRange(lumberdepo, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("1. ~g~Lumber Depo~g~")
            EndTextCommandSetBlipName(lumberdepo)
            
            lumberprocessing = AddBlipForCoord(-516.9495,5331.996,80.25061)
            SetBlipSprite(lumberprocessing, 480)
            SetBlipDisplay(lumberprocessing, 6)
            SetBlipScale(lumberprocessing, 0.7)
            SetBlipColour(lumberprocessing, 11)
            SetBlipAsShortRange(lumberprocessing, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("3. ~o~Lumber Trader~o~")
            EndTextCommandSetBlipName(lumberprocessing)
            
            lumbersell = AddBlipForCoord(-510.9626,-943.3714,24.0564)
            SetBlipSprite(lumbersell, 500)
            SetBlipDisplay(lumbersell, 6)
            SetBlipScale(lumbersell, 1.00)
            SetBlipColour(lumbersell, 69)
            SetBlipAsShortRange(lumbersell, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("4. ~b~Lumber Seller~b~")
            EndTextCommandSetBlipName(lumbersell)
            
            TreeBlips = AddBlipForRadius(LumberYard, 150.0)
            SetBlipColour(TreeBlips, 2)
            SetBlipDisplay(TreeBlips, 6)
            SetBlipAlpha(TreeBlips, 128)
            SetBlipAsShortRange(TreeBlips, true)
    else
            if lumberdepo ~= nil then
            RemoveBlip(lumberdepo)
            lumberdepo = nil
            
        if lumberprocessing ~= nil then
            RemoveBlip(lumberprocessing)
            lumberprocessing = nil
        end
        
            if lumbersell ~= nil then
            RemoveBlip(lumbersell)
            lumbersell = nil
        end
        
        if TreeBlips ~= nil then
            RemoveBlip(TreeBlips)
            TreeBlips = nil
        end
    end
end
end

