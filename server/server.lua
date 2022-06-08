local ox_inventory = exports.ox_inventory
local Chopped = false

RegisterNetEvent('esx-lumberjack:sellItems', function()
    local source = source
    local price = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.Sell) do 
        local item = ox_inventory:GetItem(source, k, nil, true)
        if item >= 1 then
            price = price + (v * item)
            ox_inventory:RemoveItem(source, k, item)
        end
    end
    if price > 0 then
        xPlayer.addMoney(price)
        xPlayer.showNotification(Config.Alerts["successfully_sold"], true, false, 140)
    else
        xPlayer.showNotification(Config.Alerts["no_item"])
    end
end)

RegisterNetEvent('esx-lumberjack:BuyAxe', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local TRAxeClassicPrice = LumberJob.AxePrice
    local hasAxe = ox_inventory:GetItem(source, 'axe', nil, true)
    
    if hasAxe < 1 then
        if ox_inventory:CanCarryItem(source, 'axe', 1) then
            ox_inventory:AddItem(source, 'axe', 1)
            ox_inventory:RemoveItem(source, 'money', TRAxeClassicPrice)
            xPlayer.showNotification(Config.Alerts["axe_bought"], true, false, 140)
        else
            --Cant Carry
        end
    else
        xPlayer.showNotification(Config.Alerts["axe_check"], true, false, 140)
    end
end)

ESX.RegisterServerCallback('esx-lumberjack:axe', function(source, cb) --Doesnt seem to be used?
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.hasWeapon('WEAPON_BATTLEAXE') then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('esx-lumberjack:setLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
    TriggerClientEvent('esx-lumberjack:getLumberStage', -1, stage, state, k)
end)

RegisterNetEvent('esx-lumberjack:setChoppedTimer', function()
    if not Chopped then
        Chopped = true
        CreateThread(function()
            Wait(Config.Timeout)
            for k, v in pairs(Config.TreeLocations) do
                Config.TreeLocations[k]["isChopped"] = false
                TriggerClientEvent('esx-lumberjack:getLumberStage', -1, 'isChopped', false, k)
            end
            Chopped = false
        end)
    end
end)

RegisterServerEvent('esx-lumberjack:recivelumber', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local lumber = math.random(LumberJob.LumberAmount_Min, LumberJob.LumberAmount_Max)
    local bark = math.random(LumberJob.TreeBarkAmount_Min, LumberJob.TreeBarkAmount_Max)
    if ox_inventory:CanCarryItem(source, 'tree_lumber', lumber) and ox_inventory:CanCarryItem(source, 'tree_bark', bark) then
        ox_inventory:AddItem(source, 'tree_lumber', lumber)
        ox_inventory:AddItem(source, 'tree_bark', bark)
    else
        --Cant carry
    end
end)

ESX.RegisterServerCallback('esx-lumberjack:lumber', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasLumber = ox_inventory:GetItem(source, 'tree_lumber', nil, true)

    if xPlayer then
        if hasLumber >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('esx-lumberjack:lumberprocessed', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local lumber = ox_inventory:GetItem(source, 'tree_lumber', nil, true)
    local TradeAmount = math.random(LumberJob.TradeAmount_Min, LumberJob.TradeAmount_Max)
    local TradeRecevied = math.random(LumberJob.TradeRecevied_Min, LumberJob.TradeRecevied_Max)

    if lumber < 1 then
        xPlayer.showNotification(Config.Alerts['error_lumber'])
        return false
    end

    local amount = lumber
    if amount >= 1 then
        amount = TradeAmount
    else
      return false
    end
    if lumber >= amount then
        if ox_inventory:CanCarryItem(source, 'wood_plank', amount) then
            ox_inventory:RemoveItem(source, 'tree_lumber', amount)
            xPlayer.showNotification(Config.Alerts["lumber_processed_trade"] ..TradeAmount.. Config.Alerts["lumber_processed_lumberamount"] ..TradeRecevied.. Config.Alerts["lumber_processed_received"])
            Wait(750)
            ox_inventory:AddItem(source, 'wood_plank', TradeRecevied)
        else
        end
    else 
        xPlayer.showNotification(Config.Alerts['itemamount'])
        return false
    end
end)


