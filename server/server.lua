ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastStarted = 0
local currentShipmentId = nil
local onGoingShipment = false
local CopsConnected  = 5
function CountCops()

    local xPlayers = ESX.GetPlayers()

    CopsConnected = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            CopsConnected = CopsConnected + 1
        end
    end

    SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterNetEvent('cfx_shipments:serverStartShipments')
AddEventHandler('cfx_shipments:serverStartShipments', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = xPlayer.getAccount('black_money').money
    local rep = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})
    rep = rep[1].amount
    if CopsConnected >= 5 then
        if rep >= 10 then
            if money >= Config.InterceptingCost then
                if lastStarted > 0 then
                    print(lastStarted)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Shipments are not available.', length = 2500})
                else
                    print(lastStarted)
                    lastStarted = os.time()
                    currentShipmentId  = math.random(1, #Config.Shipments)
                    onGoingShipment = true

                    TriggerClientEvent('cfx_shipments:interceptShipments', -1, currentShipmentId)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You intercepted the shipment find the illegal container and open it.', length = 2500})
                    xPlayer.removeAccountMoney('black_money', Config.InterceptingCost)
                    Citizen.Wait(60000)
                    local xPlayers = ESX.GetPlayers()
                    for i=1, #xPlayers, 1 do
                        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                        if xPlayer.job.name == 'police' then
                            TriggerClientEvent('cfx_shipments:IllegalShipmentNotification', xPlayers[i])
                        end
                    end
                end
            else
                local missingMoney = Config.InterceptingCost - money
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'You\'re missing '..ESX.Math.GroupDigits(missingMoney)..'$ of dirty money!', length = 4500})
            end
        else
            TriggerClientEvent('cfx_shipments:BadReputationMessage', src)
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Not enough cops', length = 2500})
    end
end)

RegisterNetEvent('cfx_shipments:serverResetShipments')
AddEventHandler('cfx_shipments:serverResetShipments', function()
    print('^2SERVER GLOBAL COOLDOWN ACTIVATED^0')
    SetTimeout(Config.ShipmentCooldown * (60 * 1000), function()
        lastStarted = 0
        currentShipmentId = nil
        onGoingShipment = false

        TriggerClientEvent('cfx_shipments:clientResetShipments', -1)
        print('^2SERVER GLOBAL COOLDOWN ENDED^0')
    end)
end)

RegisterNetEvent('cfx_shipments:openShipment')
AddEventHandler('cfx_shipments:openShipment', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local itemreward = Config.ItemShipments[math.random(1, #Config.ItemShipments)]
    local qty = math.random(itemreward.minqty, itemreward.maxqty)
    local sourceItem = xPlayer.getInventoryItem(itemreward.name)
    if (sourceItem.count + qty) > sourceItem.limit then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'You don\'t have enough space in your pockets!', length = 4500})
    else
        xPlayer.addInventoryItem(itemreward.name, qty)
    end
end)

RegisterServerEvent("cfx_shipments:checkplayer")
AddEventHandler("cfx_shipments:checkplayer", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM reputation")
    local found = false
    while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(_source)
        Citizen.Wait(1000)
    end
    for i = 1, #result, 1 do
        if result[i].identifier == xPlayer.identifier then
            found = true
            print("^3[REPUTATION]^0 Player Found: "..xPlayer.name..", "..xPlayer.identifier)
        end
    end
    if not found then
        MySQL.Async.execute("INSERT INTO reputation (identifier, amount) VALUES (@identifier, @amount)", {
            ["@identifier"] = xPlayer.identifier,
            ["@amount"] = 0
        })
        print("^3[REPUTATION]^0 Player Added: "..xPlayer.name..", "..xPlayer.identifier)
    end
end)

RegisterServerEvent("cfx_shipments:addrep")
AddEventHandler("cfx_shipments:addrep", function(id, amount)
    local xPlayer = ESX.GetPlayerFromId(id)
    local oldamount = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})[1].amount

    MySQL.Async.execute("UPDATE reputation SET amount = @amount WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
        ["@amount"] = oldamount + amount
    })
end)

RegisterServerEvent("cfx_shipments:removerep")
AddEventHandler("cfx_shipments:removerep", function(id, amount)
    local xPlayer = ESX.GetPlayerFromId(id)
    local oldamount = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})[1].amount
    local totalamount = oldamount - amount
    if totalamount <= 0 then
        totalamount = 0
    end
    MySQL.Async.execute("UPDATE reputation SET amount = @amount WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
        ["@amount"] = oldamount - amount
    })
end)

ESX.RegisterServerCallback("cfx_shipments:getRep", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount
    local result

    result = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    })
    if result ~= nil then
        amount = result[1].amount
        cb(amount)
    end
end)

ESX.RegisterUsableItem('minismg_crate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('cfx_shipments:minismg_crate', source)
end)

ESX.RegisterUsableItem('compactrif_crate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('cfx_shipments:compactrif_crate', source)
end)

ESX.RegisterUsableItem('assultrif_crate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('cfx_shipments:assultrif_crate', source)
end)

RegisterServerEvent('cfx_shipments:removeWeaponCrate')
AddEventHandler('cfx_shipments:removeWeaponCrate', function(crate, weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.hasWeapon(weapon) then
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You already have this weapon!', length = 4500})
    else
        xPlayer.addWeapon(weapon, 1)
        xPlayer.removeInventoryItem(crate, 1)
    end
end)

RegisterCommand('checkrep', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    result = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    })
    if result ~= nil then
        amount = result[1].amount
        TriggerClientEvent('chat:addMessage', _source ,{
			template = "<div class='chat-message advert'><div class='chat-message-header'>[^1SYSTEM^0] You have ^3{0}^0x reputation.</div></div>", 
			args = { amount }
		})
        --TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Reputation: '..amount, length = 4500})
    end
end)

function isAllowed(player)
    local allowed = false
    for i,id in ipairs(Config.admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

--RegisterCommand('addrep', function(source,args)
--    local _source = source
--    local xPlayer = ESX.GetPlayerFromId(_source)
--    --if isAllowed(_source) then
--        if args[1] and args[2] == nil then
--            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Use /addrep [playerID] [amount]!', length = 4500})
--        else
--            local targetPlayer = ESX.GetPlayerFromId(args[1])
--            local oldamount = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {["@identifier"] = targetPlayer.identifier})[1].amount
--            MySQL.Async.execute("UPDATE reputation SET amount = @amount WHERE identifier = @identifier", {
--                ["@identifier"] = xPlayer.identifier,
--                ["@amount"] = oldamount + args[2]
--            })
--        
--            TriggerClientEvent('chat:addMessage', targetPlayer.source ,{
--	    		template = "<div class='chat-message advert'><div class='chat-message-header'>[^1SYSTEM^0] You have ^3 {0}^0x reputation.</div></div>", 
--	    		args = { oldamount + args[2] }
--            })
--        end
--    --else
--    --    print('^4[cfx_shipments]^0 ^3SOMEONE TRIED TO USE ADMIN COMMAND NOT AN ADMIN^0\n^4[cfx_shipments]^0 ^3NAME:^0 ^1'..xPlayer.name..' ^3STEAM:^0 ^1'..xPlayer.identifier..'^0')
--    --end
--end)
--
--RegisterCommand('removerep', function(source,args)
--    local _source = source
--    local xPlayer = ESX.GetPlayerFromId(_source)
--    --if isAllowed(_source) then
--        if args[1] and args[2] == nil then
--            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Use /removerep [playerID] [amount]!', length = 4500})
--        else
--            local targetPlayer = ESX.GetPlayerFromId(args[1])
--            local oldamount = MySQL.Sync.fetchAll("SELECT amount FROM reputation WHERE identifier = @identifier", {["@identifier"] = targetPlayer.identifier})[1].amount
--            MySQL.Async.execute("UPDATE reputation SET amount = @amount WHERE identifier = @identifier", {
--                ["@identifier"] = xPlayer.identifier,
--                ["@amount"] = oldamount - args[2]
--            })
--        
--            TriggerClientEvent('chat:addMessage', targetPlayer.source ,{
--	    		template = "<div class='chat-message advert'><div class='chat-message-header'>[^1SYSTEM^0] You have ^3{0}^0x reputation.</div></div>", 
--	    		args = { oldamount - args[2] }
--            })
--        end
--    --else
--    --    print('^4[cfx_shipments]^0 ^3SOMEONE TRIED TO USE ADMIN COMMAND NOT AN ADMIN^0\n^4[cfx_shipments]^0 ^3NAME:^0 ^1'..xPlayer.name..' ^3STEAM:^0 ^1'..xPlayer.identifier..'^0')
--    --end
--end)