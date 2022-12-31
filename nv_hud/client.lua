ESX = nil
loaded = false
local on = false
local display = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    loaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

function open()
    SendNUIMessage({
        type = "ui",
        status = true,
    })
end

function close()
    SendNUIMessage({
        type = "ui",
        status = false,
    })
end

function openE()
    SendNUIMessage({
        type = "ui",
        status = true,
    })
end

function closeE()
    SendNUIMessage({
        type = "ui",
        status = false,
    })
end


function setSocBal(money)
    socBal = money
end

local id = 0
local health = 0
local armor = 0
local food = 0
local water = 0
local stamina = 0
local job = ""
local socBal = 0
local cash = 0

local isPause = false

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(20)
    end

    while true do 
        Citizen.Wait(0)
        local ped =  GetPlayerPed(-1)
        local playerId = PlayerId()
        SetPlayerHealthRechargeMultiplier(playerId, 0)
        health = GetEntityHealth(ped)/2
        armor = GetPedArmour(ped)
        stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
        stamina = math.ceil(stamina)
        SendNUIMessage({
            type = "update",
            id = id,
            health = health,
            armor = armor,
            food = food,
            water = water,
            stamina = stamina,
            job = job,
            socBal = socBal,
            cash = cash,
        })
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(20)
    end

    while true do
        Citizen.Wait(1000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
              food = hunger.getPercent()
              water = thirst.getPercent()
            end)
        end)
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(20)
    end
    local isPause = false
    while true do
        Citizen.Wait(100)
        
        if IsPauseMenuActive() then 
            isPause = true
            SendNUIMessage({
                type = "ui",
                status = false,
            })
        
        elseif not IsPauseMenuActive() and isPause then
            isPause = false
            SendNUIMessage({
                type = "ui",
                status = true,
            })
        end
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(20)
    end

    while true do
        Citizen.Wait(3000)
        ESX.PlayerData = ESX.GetPlayerData()
        
        job =  ESX.PlayerData.job.label .." - "..ESX.PlayerData.job.grade_label

        if ESX.PlayerData.job.grade_name == 'boss' then
            ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
                socBal = money               
            end, ESX.PlayerData.job.name)
            if not isBoss then
                SendNUIMessage({
                    type = "isBoss",
                    isBoss = true
                })
                isBoss = true
            end
            
        elseif isBoss and ESX.PlayerData.job.grade_name ~= 'boss' then
            isBoss = false
            SendNUIMessage({
                type = "isBoss",
                isBoss = false,
            })
        end

        TriggerServerEvent('hud:getServerInfo')
    end
end)




Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      HideHudComponentThisFrame(1)  -- Wanted Stars
      HideHudComponentThisFrame(2)  -- Weapon Icon
      HideHudComponentThisFrame(3)  -- Cash
      HideHudComponentThisFrame(4)  -- MP Cash
      HideHudComponentThisFrame(6)  -- Vehicle Name
      HideHudComponentThisFrame(7)  -- Area Name
      HideHudComponentThisFrame(8)  -- Vehicle Class
      HideHudComponentThisFrame(9)  -- Street Name
      HideHudComponentThisFrame(13) -- Cash Change
      HideHudComponentThisFrame(17) -- Save Game
      HideHudComponentThisFrame(20) -- Weapon Stats
    end
  end)
  

RegisterNetEvent('hud:setInfo')
AddEventHandler('hud:setInfo', function(info)
	cash = info['money']
	bank = info['bankMoney']
    black = info['blackMoney']
    id = info['id']
end)

Citizen.CreateThread(function()

    local minimap = RequestScaleformMovie("minimap")

    SetRadarBigmapEnabled(true, false)

    Wait(0)

    SetRadarBigmapEnabled(false, false)

    while true do

        Wait(0)

        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")

        ScaleformMovieMethodAddParamInt(3)

        EndScaleformMovieMethod()

    end

end)

function show(bool)
    on = bool
    SetNuiFocus(on, on)
    SendNUIMessage({
        status = on,
    })
end



RegisterNUICallback('exit', function(data)
    show(false)
end)

RegisterNUICallback('accept', function(data)
    show(false)
end)

-- Citizen.CreateThread(function()
--     while true do
--     Citizen.Wait(0)
--         if IsControlJustPressed(0, 56) then
--             close()
--         elseif IsControlJustPressed(0, 56) then
--             open()
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
        if health <= 50 then
            TriggerEvent('chat:addMessage', {
                color = { 125, 197, 118},
                multiline = true,
                args = {"[VLRP]", "Kevés a HP-d menj el a korházba!"}
              })
            end
    end
end)

RegisterNUICallback("kilep", function()
    SetDisplay(false)
  end)
  
  RegisterNUICallback("main", function(data)
    print(data.text)
    SetDisplay(false)
  end)
  
  RegisterNUICallback("error", function(data)
    print(data.error)
    SetDisplay(false)
  end)
  
  function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
      type = "ui",
      status = bool,
    })
  end
  
RegisterCommand("edit", function(source, args)
    SetDisplay(not display)
end)
