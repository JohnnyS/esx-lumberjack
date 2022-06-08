local ClassicMan = Config.Blips.LumberDepo.coords
local LumberTR = Config.Blips.LumberProcessor.coords
local sellClassic = Config.Blips.LumberSeller.coords
local ClassicPed = LumberJob.LumberModel
local ClassicHash = LumberJob.LumberHash

CreateThread(function()
    RequestModel(ClassicPed)
    while ( not HasModelLoaded(ClassicPed ) ) do
        Wait(1)
    end

    lumberjack1 = CreatePed(1, ClassicPed, ClassicMan, false, true)
    lumberjack2 = CreatePed(1, ClassicPed, LumberTR, false, true)
    lumberjack3 = CreatePed(1, ClassicPed, sellClassic, false, true)
    SetEntityInvincible(lumberjack1, true)
    SetBlockingOfNonTemporaryEvents(lumberjack1, true)
    FreezeEntityPosition(lumberjack1, true)
    SetEntityInvincible(lumberjack2, true)
    SetBlockingOfNonTemporaryEvents(lumberjack2, true)
    FreezeEntityPosition(lumberjack2, true)
    SetEntityInvincible(lumberjack3, true)
    SetBlockingOfNonTemporaryEvents(lumberjack3, true)
    FreezeEntityPosition(lumberjack3, true)

    exports.qtarget:AddEntityZone("lumberjackdepo", lumberjack1, {
        name="lumberjackdepo",
        debugPoly=false,
        useZ = true
            }, {
            options = {
                {
                    event = "esx-lumberjack:bossmenu",
                    icon = "Fas Fa-hands",
                    label = Config.Alerts["depo_label"],
                },
            },
            distance = 2.0
        })  
    exports.qtarget:AddEntityZone("LumberProcessor", lumberjack2, {
        name="LumberProcessor",
        debugPoly=false,
        useZ = true
            }, {
            options = {
                {
                    event = "esx-lumberjack:processormenu",
                    icon = "Fas Fa-hands",
                    label = Config.Alerts["mill_label"],
                },
                {
                    icon = "fa-solid fa-circle-info",
                    label = "Example of Trees you can cut down",
                    action = function(entity)
                        exports['t-notify']:Image({
                            style = 'message',
                            duration = 5000,
                            title = 'Trees you cant cut down',
                            image = 'https://cdn.discordapp.com/attachments/933165566380883989/978740420089634836/unknown.png',
                            sound = true
                        })
                        Wait(5500)
                        exports['t-notify']:Image({
                            style = 'message',
                            duration = 5000,
                            title = 'Trees you can cut down. Just look within the radius of here!',
                            image = 'https://cdn.discordapp.com/attachments/933165566380883989/978742220901466182/unknown.png',
                            sound = true
                        })
                    end
                }
            },
            distance = 2.0
        })
    exports.qtarget:AddEntityZone("LumberSeller", lumberjack3, {
        name="LumberSeller",
        debugPoly=false,
        useZ = true
            }, {
            options = {
                {
                    type = 'server',
                    event = "esx-lumberjack:sellItems",
                    icon = "fa fa-usd",
                    label = Config.Alerts["Lumber_Seller"],
                },
            },
            distance = 2.0
        })
end)
