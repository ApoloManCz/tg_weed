local ItemList = {
    ["weed_papers"] = "weed_papers"
}

local DrugList = {
    ["weed_joint"] = "weed_joint"
}


------------------------
----PICK-UP-CANNABIS----
------------------------
RegisterServerEvent('tg_drugs:server:getcannabis')
AddEventHandler('tg_drugs:server:getcannabis', function(item, amount)
    local targetPlayer = ESX.GetPlayerFromId(source)
    targetPlayer.addInventoryItem("cannabis", 5)
end)

------------------------
----DEAL-&-CHECK-----
------------------------
RegisterServerEvent('tg_drugs:server:deal')
AddEventHandler('tg_drugs:server:deal', function(item, amount)
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source) 
    local cannabis = xPlayer.getInventoryItem("cannabis") 
    local weedPaper = xPlayer.getInventoryItem("weed_papers")
    if cannabis.count >= 3 and weedPaper.count >= 1 then 
        xPlayer.removeInventoryItem("cannabis", 3) 
        xPlayer.removeInventoryItem("weed_papers", 1) 
        TriggerClientEvent("tg_drugs:client:weeddeal", source) 
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have Items for this!', style = { ['background-color'] = 'FF0000', ['color'] = '#FFFFFF' } })
    end
end)

RegisterServerEvent('tg_drugs:server:getweed')
AddEventHandler('tg_drugs:server:getweed', function()
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source) 
    xPlayer.addInventoryItem("weed_joint", 1) 
end)

------------------------
---SELL-WEED-&-CHECK----
------------------------
RegisterServerEvent('tg_drugs:server:sell')
AddEventHandler('tg_drugs:server:sell', function(item, amount)
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source) 
    local weedJoint = xPlayer.getInventoryItem("weed_joint")
    if weedJoint.count >= 5 then 
        xPlayer.removeInventoryItem("weed_joint", 5) 
        TriggerClientEvent("tg_drugs:client:jointsell", source) 
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have Joints!', style = { ['background-color'] = 'FF0000', ['color'] = '#FFFFFF' } })
    end
end)

RegisterServerEvent('tg_drugs:server:getmoney')
AddEventHandler('tg_drugs:server:getmoney', function()
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source) 
    local random = math.random(50, 65)
    local amount = 5 * random
    xPlayer.addMoney(amount)
end)

