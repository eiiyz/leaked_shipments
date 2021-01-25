ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
-------------------------------------------------------
local onGoingShipment = false
local isAttemping = false
local isOpening = false
local lastStarted = 0
local currentShipmentId = nil

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local pedCoords = GetEntityCoords(playerPed)
		
		if onGoingShipment then
			local shipment_dist = GetDistanceBetweenCoords(pedCoords, Config.Shipments[currentShipmentId].x, Config.Shipments[currentShipmentId].y, Config.Shipments[currentShipmentId].z, 1)

			if shipment_dist <= 5.0 and not isOpening then
				Draw3DText(Config.Shipments[currentShipmentId].x, Config.Shipments[currentShipmentId].y, Config.Shipments[currentShipmentId].z, '[E] to open the cargo')

				if shipment_dist <= 2.0 and IsControlJustReleased(0, 38) and onGoingShipment and ( GetGameTimer() - lastStarted ) < Config.Duration then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance == -1 or closestDistance > 2.0 then
						isOpening = true
						OpenCargo()
					end
				end
			end
		else
			Citizen.Wait(2000)
    end
	end

end)

Citizen.CreateThread(function()
  while true do
    
    Citizen.Wait(0)
    local inRange = false
    local playerPed = PlayerPedId()
		local pedCoords = GetEntityCoords(playerPed)
    local setup_dist = GetDistanceBetweenCoords(pedCoords, Config.ShipmentSetup.x,Config.ShipmentSetup.y,Config.ShipmentSetup.z, 1)

    if setup_dist < 2.0 then
      Draw3DText(Config.ShipmentSetup.x,Config.ShipmentSetup.y,Config.ShipmentSetup.z, '[E] Intercept Shipments')
      inRange = true
      if IsControlJustPressed(1, 38) then	
        TriggerServerEvent('cfx_shipments:serverStartShipments')
        Citizen.Wait(2000)
      end
    end

    if not inRange then
      Citizen.Wait(2500)
    end
  end
end)

RegisterNetEvent('cfx_shipments:interceptShipments')
AddEventHandler('cfx_shipments:interceptShipments', function(shipmentId)
	lastStarted = GetGameTimer()
	onGoingShipment = true
	currentShipmentId = shipmentId
  print('^2SHIPMENT ID: '..currentShipmentId..'^0')
	Citizen.Wait(Config.Duration)
  print('UNABLE TO FIND CONTAINER RESET SHIPMENT')
	TriggerServerEvent('cfx_shipments:serverResetShipments')
end)

RegisterNetEvent('cfx_shipments:clientResetShipments')
AddEventHandler('cfx_shipments:clientResetShipments', function()
	lastStarted = 0
	onGoingShipment = false
  currentShipmentId = nil	
  print('^3CLIENT GLOBAL COOLDOWN ENDED^0')
end)

function AttemptToIntercept()
    local finished = exports['np-taskbarskill']:skillBar(1500, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isAttemping = false
      Citizen.Wait(1000)
      return
    end 
    Citizen.Wait(1000)
    local finished = exports['np-taskbarskill']:skillBar(1200, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isAttemping = false
      Citizen.Wait(1000)
      return
    end 
    Citizen.Wait(1000)
    local finished = exports['np-taskbarskill']:skillBar(1000, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isAttemping = false
      Citizen.Wait(1000)
      return
    end 
    Citizen.Wait(1000)
    local finished = exports['np-taskbarskill']:skillBar(800, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isAttemping = false
      Citizen.Wait(1000)
      return
    end 
    Citizen.Wait(1000)
    local finished = exports['np-taskbarskill']:skillBar(500, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isAttemping = false
      Citizen.Wait(1000)
      return
    end 

  loadAnimDict("anim@heists@prison_heiststation@cop_reactions")
	TaskPlayAnim( PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
	Citizen.Wait(5000)
	ClearPedTasks(PlayerPedId())
	isAttemping = false

	local started = GetGameTimer()
	TriggerServerEvent('cfx_shipments:attemptInterceptingShipments', started)
end

RegisterNetEvent('cfx_shipments:IllegalShipmentNotification')
AddEventHandler('cfx_shipments:IllegalShipmentNotification', function()
    TriggerEvent('chat:addMessage', {
        template = "<div class='chat-message advert'><div class='chat-message-header'>[^1EMAIL^0] Bruh! Someone paid me to track the cargo that is being shipped on Bucaneer Way Docks, just letting you know in case you're interested in getting it first.</div></div>", 
        args = {}
    })

    TriggerEvent('InteractSound_CL:PlayOnOne', 'email', 1.0)
end)

function OpenCargo()
    local finished = exports['np-taskbarskill']:taskBar(1500, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isOpening = false
      Citizen.Wait(1000)
      return
    end 
    loadAnimDict("random@shop_robbery")
	TaskPlayAnim( PlayerPedId(), "random@shop_robbery", "robbery_action_b", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
	Citizen.Wait(5000)

    local finished = exports['np-taskbarskill']:taskBar(1200, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isOpening = false
      Citizen.Wait(1000)
      return
    end 
    loadAnimDict("random@shop_robbery")
	TaskPlayAnim( PlayerPedId(), "random@shop_robbery", "robbery_action_b", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
	Citizen.Wait(5000)

    local finished = exports['np-taskbarskill']:taskBar(1000, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isOpening = false
      Citizen.Wait(1000)
      return
    end 
    loadAnimDict("random@shop_robbery")
	TaskPlayAnim( PlayerPedId(), "random@shop_robbery", "robbery_action_b", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
	Citizen.Wait(5000)

    local finished = exports['np-taskbarskill']:taskBar(1000, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isOpening = false
      Citizen.Wait(1000)
      return
    end 
    loadAnimDict("random@shop_robbery")
	TaskPlayAnim( PlayerPedId(), "random@shop_robbery", "robbery_action_b", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
	Citizen.Wait(5000)

    local finished = exports['np-taskbarskill']:taskBar(1000, math.random(3, 5))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      isOpening = false
      Citizen.Wait(1000)
      return
    end 

    loadAnimDict("mini@repair")
	  TaskPlayAnim( PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, 1.0, 10000, 49, 0, 0, 0, 0 )
	  Citizen.Wait(10000)
	  ClearPedTasks(PlayerPedId())
	  isOpening = false

	  TriggerServerEvent('cfx_shipments:openShipment')

  local repLuck = math.random(1, 100)

  if repLuck > 5 then
    TriggerServerEvent("cfx_shipments:addrep", GetPlayerServerId(PlayerId()), 1)
    exports['mythic_notify']:SendAlert('inform', 'You recieved reputation', 2500)
  end
  
end

function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    Citizen.Wait(100)
  end
end   

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end

AddEventHandler('playerSpawned', function()
	TriggerServerEvent("cfx_shipments:checkplayer")
end)

RegisterCommand('registerrep',function(source)
  TriggerServerEvent("cfx_shipments:checkplayer")
end)

----- REPUTATION
local BadRep = {
  [1] = "Who the fuck are you?",
  [2] = "Move the fuck on, stay away from here.",
  [3] = "You are probably dreaming.",
  [4] = "What are you trying to do?",
  [5] = "How did you know about this shit?",
  [6] = "Fuck off!!"
}

RegisterCommand('testrep', function(source)
  TriggerServerEvent("cfx_shipments:checkplayer")
end)

RegisterNetEvent('cfx_shipments:BadReputationMessage')
AddEventHandler('cfx_shipments:BadReputationMessage', function()
  local msg = math.random(1, #BadRep)

  exports['mythic_notify']:DoCustomHudText ('inform', BadRep[msg], 5000)
end)


RegisterNetEvent('cfx_shipments:minismg_crate')
AddEventHandler('cfx_shipments:minismg_crate', function()
    local playerPed = PlayerPedId()

    local finished = exports['np-taskbarskill']:taskBar(1500, math.random(5, 7))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end 
    local finished = exports['np-taskbarskill']:taskBar(700, math.random(3, 4))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end     
    TriggerServerEvent('cfx_shipments:removeWeaponCrate', 'minismg_crate', 'WEAPON_MINISMG')    
end)

RegisterNetEvent('cfx_shipments:compactrif_crate')
AddEventHandler('cfx_shipments:compactrif_crate', function()
    local playerPed = PlayerPedId()

    local finished = exports['np-taskbarskill']:taskBar(2000, math.random(5, 7))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end 
    local finished = exports['np-taskbarskill']:taskBar(1300, math.random(3, 4))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end     
    TriggerServerEvent('cfx_shipments:removeWeaponCrate', 'compactrif_crate', 'WEAPON_COMPACTRIFLE')   
end)

RegisterNetEvent('cfx_shipments:assultrif_crate')
AddEventHandler('cfx_shipments:assultrif_crate', function()
    local playerPed = PlayerPedId()

    local finished = exports['np-taskbarskill']:taskBar(2000, math.random(5, 7))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end 
    local finished = exports['np-taskbarskill']:taskBar(1300, math.random(3, 4))
    if finished <= 0 then
      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
      return
    end     
    
    TriggerServerEvent('cfx_shipments:removeWeaponCrate', 'assultrif_crate', 'WEAPON_ASSAULTRIFLE')     
end)