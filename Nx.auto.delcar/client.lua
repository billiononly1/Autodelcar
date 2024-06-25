RegisterNetEvent('startCountdown')
AddEventHandler('startCountdown', function(data)
    SendNUIMessage({
        type = 'startCountdown',
        duration = data.duration
    })
end)

RegisterNetEvent('stopCountdown')
AddEventHandler('stopCountdown', function()
    SendNUIMessage({
        type = 'stopCountdown'
    })
end)

RegisterNUICallback('removeVehicles', function(data, cb)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) and not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
            DeleteEntity(vehicle)
        end
    end
    cb('ok')
end)
