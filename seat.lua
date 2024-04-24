local maxSpeedKmh = 80 -- Maksymalna prędkość pojazdu w km/h

RegisterNetEvent('f4LqNotify:Alert')
AddEventHandler('f4LqNotify:Alert', function(title, message, time, type)
    Alert(title, message, time, type)
end)

function Alert(title, message, time, type)
    -- Funkcja do wyświetlania powiadomienia
    print(title .. ": " .. message)
end

RegisterCommand("seat", function(source, args)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local speed = GetEntitySpeed(vehicle) * 3.6 -- Prędkość w km/h
    
    if speed > maxSpeedKmh then
        TriggerEvent('f4LqNotify:Alert', "<b>SEAT</b>", "Jedzisz zbyt szybko <b><span style='color:lightblue'>(" .. maxSpeedKmh .. "km/h)</span></b>", 5000, "info")
        return
    end
    
    if vehicle ~= 0 then
        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
        local targetSeat = tonumber(args[1]) or 1 -- Domyślne miejsce to 1, jeśli nie podano innego
        
        if targetSeat < 1 or targetSeat > maxSeats then
            TriggerEvent('f4LqNotify:Alert', "<b>SEAT</b>", "<b><span style='color:red'>Nieprawidłowy numer miejsca.</span></b>", 5000, "error")
            return
        end
        
        local currentSeat = GetPedInVehicleSeat(vehicle, targetSeat - 1) -- Sprawdź, kto aktualnie zajmuje to miejsce
        
        if currentSeat == playerPed then
            TriggerEvent('f4LqNotify:Alert', "<b>SEAT</b>", "<b><span style='color:orange'>Już siedzisz na tym miejscu!</span></b>", 5000, "error")
            return
        end
        
        if targetSeat == 1 then
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1) -- Przesiadka na miejsce kierowcy (-1)
        else
            TaskWarpPedIntoVehicle(playerPed, vehicle, targetSeat - 2) -- Numeracja miejsc zaczyna się od 0
        end
        
        TriggerEvent('f4LqNotify:Alert', "<b>SEAT</b>", "Zajęto miejsce <b><span style='color:green'>#" .. targetSeat .. "</span></b> w pojeździe.", 5000, "success")
    else
        TriggerEvent('f4LqNotify:Alert', "<b>SEAT</b>", "<b><span style='color:red'>Nie jesteś w pojeździe.</span></b>", 5000, "info")
    end
end, false)