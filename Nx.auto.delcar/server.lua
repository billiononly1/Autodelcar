ESX = nil
local autoCleanupEnabled = true
local isCountdownActive = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ฟังก์ชันสำหรับลบรถ
local function RemoveVehicles()
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
            DeleteEntity(vehicle)
        end
    end
end

-- ฟังก์ชันสำหรับตรวจสอบช่วงเวลาที่กำหนด
local function CheckCleanupTimes()
    if isCountdownActive then return end  -- หากกำลังนับถอยหลังอยู่ ให้หยุดทำงาน
    local currentTime = os.date('*t')
    for _, cleanupTime in ipairs(Config.CleanupTimes) do
        if currentTime.hour == cleanupTime.hour and currentTime.min == cleanupTime.minute and autoCleanupEnabled then
            isCountdownActive = true
            TriggerClientEvent('startCountdown', -1, { duration = 300 }) -- เริ่มต้นนับถอยหลัง 5 นาที
        end
    end
end

-- คำสั่งสำหรับลบรถด้วยตนเอง
RegisterCommand('delcar', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getGroup() ~= 'admin' then
        xPlayer.showNotification('You do not have permission to use this command.')
        return
    end

    if isCountdownActive then
        xPlayer.showNotification('A countdown is already active.')
        return
    end

    local duration = tonumber(args[1]) or 10 -- ค่าเริ่มต้นเป็น 10 วินาที
    isCountdownActive = true
    autoCleanupEnabled = false -- หยุดระบบลบรถอัตโนมัติ
    TriggerClientEvent('startCountdown', -1, { duration = duration })
end, false)

-- คำสั่งสำหรับหยุดการทำงาน
RegisterCommand('stopdelcar', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() ~= 'admin' then
        xPlayer.showNotification('You do not have permission to use this command.')
        return
    end

    if not isCountdownActive then
        xPlayer.showNotification('No countdown is active.')
        return
    end

    isCountdownActive = false
    autoCleanupEnabled = true
    TriggerClientEvent('stopCountdown', -1)
    xPlayer.showNotification('Vehicle cleanup has been stopped.')
end, false)

-- ตั้งเวลาให้ตรวจสอบช่วงเวลาที่กำหนดทุกนาที
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- ตรวจสอบทุก 60 วินาที
        CheckCleanupTimes()
    end
end)

-- รับ event สำหรับลบรถ
RegisterNetEvent('removeVehicles')
AddEventHandler('removeVehicles', function()
    RemoveVehicles()
    isCountdownActive = false
    autoCleanupEnabled = true
end)

function GetAllVehicles()
    local vehicles = {}
    local handle, veh = FindFirstVehicle()
    local success
    repeat
        table.insert(vehicles, veh)
        success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return vehicles
end
