local npcCoords = vector3(1514.3295, 3687.7603, 34.6678)
local npcHash2 = GetHashKey("cs_floyd")
local npcHash3 = GetHashKey("g_f_y_vagos_01")


------------------------
----------BLIP----------
------------------------
Citizen.CreateThread(function()
        if Config.PickupBlip == true then
          blip = CreateBlip(Config.PickupPos1.x, Config.PickupPos1.y, Config.PickupPos1.z, 140, 11, "Cannabis")
        end

        if Config.DealBlip == true then
        blip = CreateBlip(Config.DealNPC.x, Config.DealNPC.y, Config.DealNPC.z, 140, 11, "Weed Deal")

        end
        
        if Config.SellBlip == true then
            blip = CreateBlip(Config.SellNPC.x, Config.SellNPC.y, Config.SellNPC.z, 140, 11, "Weed sell")
            while true do
                Citizen.Wait(1000) 
            end
        
    end  
end)



------------------------
--------PICK-UP---------
------------------------
Citizen.CreateThread(function()
    while true do 
        local inRange = false 
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        local dis1 = #(PlayerPos - Config.PickupPos1)
        local dis2 = #(PlayerPos - Config.PickupPos2) 
        local dis3 = #(PlayerPos - Config.PickupPos3) 

        if dis1 < 15 then 
            inRange = true 

                if dis1 < 3 then 
                    DrawText3D(Config.PickupPos1.x, Config.PickupPos1.y, Config.PickupPos1.z, "[E] Pick Up")
                        if IsControlJustPressed(0, 38) then
                            pickDeal()
                        end
                end

                if dis2 < 3 then 
                    DrawText3D(Config.PickupPos2.x, Config.PickupPos2.y, Config.PickupPos2.z, "[E] Pick Up") 
                        if IsControlJustPressed(0, 38) then
                            pickDeal()
                        end
                end

                if dis3 < 3 then 
                    DrawText3D(Config.PickupPos3.x, Config.PickupPos3.y, Config.PickupPos3.z, "[E] Pick Up")
                        if IsControlJustPressed(0, 38) then
                            pickDeal()
                        end
                end
        end
        
        if not inRange then
            Citizen.Wait(2000)
        end
            Citizen.Wait(3)
    end         
end)


------------------------
-------SPAWN-NPC--------
------------------------
Citizen.CreateThread(function()
    RequestModel(npcHash2 and npcHash3)
    while not HasModelLoaded(npcHash2 and npcHash3) do
        Wait(1)
    end

    local dealPed = CreatePed(4, npcHash2, Config.DealNPC.x, Config.DealNPC.y, Config.DealNPC.z -1, Config.DealNPCHeading, false, true)
    
    local sellPed = CreatePed(4, npcHash3, Config.SellNPC.x, Config.SellNPC.y, Config.SellNPC.z -1, Config.SellNPCHeading, false, true)
   
    SetEntityInvincible(dealPed, true)
    SetEntityInvincible(sellPed, true)

    SetEntityAsMissionEntity(dealPed, true)
    SetEntityAsMissionEntity(sellPed, true)

    SetBlockingOfNonTemporaryEvents(dealPed, true)
    SetBlockingOfNonTemporaryEvents(sellPed, true)

    FreezeEntityPosition(dealPed, true)
    FreezeEntityPosition(sellPed, true)
end)


------------------------
--INTERACTION-WITH-NPC--
------------------------
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local npcDistance = #(playerCoords - Config.DealNPC)
        local sellDistance = #(playerCoords - Config.SellNPC)

        if npcDistance <= 2.0 then
            DrawText3D(Config.DealNPC.x, Config.DealNPC.y, Config.DealNPC.z, "[E] Deal Cannabis")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("tg_drugs:server:deal")
            end
        end

        if sellDistance <= 2.0 then
            DrawText3D(Config.SellNPC.x, Config.SellNPC.y, Config.SellNPC.z,"[E] Sell Joints")
            if IsControlJustPressed(0,38) then
                TriggerServerEvent("tg_drugs:server:sell")
            end
        end
        Wait(0) 
    end
end)


------------------------
---------EVENTS---------
------------------------
RegisterNetEvent('tg_drugs:client:weeddeal')
AddEventHandler('tg_drugs:client:weeddeal', function(source)
    Deal()
end)

RegisterNetEvent('tg_drugs:client:jointsell')
AddEventHandler('tg_drugs:client:jointsell', function(source)
    sell()
end)


------------------------
--------FUNCTION--------
------------------------
function pickDeal()    
    ESX.Progressbar("Picking Cannabis...", 9000,{
        FreezePlayer = true, 
        animation ={
            type = "Scenario",
            Scenario = "WORLD_HUMAN_GARDENER_PLANT", 
        },
        onFinish = function()
            TriggerServerEvent("tg_drugs:server:getcannabis")
        end, onCancel = function()
        end
    })
end

function Deal()
    ESX.Progressbar("Dealing...", 9000, {
        FreezePlayer = true,
        animation ={
            type = "Scenario",
            Scenario = "WORLD_HUMAN_DRUG_DEALER_HARD",
        },
        onFinish = function()
            TriggerServerEvent("tg_drugs:server:getweed")
        end, onCancel, function()
        end
    })
end
        
function sell()
        ESX.Progressbar("Selling...", 5000,{
            FreezePlayer = true, 
            animation ={
                type = "Scenario",
                Scenario = "WORLD_HUMAN_STAND_IMPATIENT_FACILITY", 
            },
            onFinish = function()
                TriggerServerEvent("tg_drugs:server:getmoney")
            end, onCancel = function()
                exports['mythic_notify']:DoHudText('error', 'You dont have joints!')
            end
    })
end


------------------------
---------OTHER----------
------------------------
DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function CreateBlip(x, y, z, sprite, color, name)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 6)
    return blip
end
