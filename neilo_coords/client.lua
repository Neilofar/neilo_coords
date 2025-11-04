local tennisModel = `prop_tennis_ball` -- Model
local ball = nil
local enabled = false
local lastCoords = nil

-- helper: convert cam rot to forward vector
local function rotToDir(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- spawn or move ball to coords (statisch, keine Physik)
local function placeBallAt(coords)
    if not ball or not DoesEntityExist(ball) then
        ball = CreateObjectNoOffset(tennisModel, coords.x, coords.y, coords.z, false, false, false)
        SetEntityCollision(ball, false, false)
        FreezeEntityPosition(ball, true)
        SetEntityInvincible(ball, true)
        SetEntityAsMissionEntity(ball, true, true)
    else
        SetEntityCoordsNoOffset(ball, coords.x, coords.y, coords.z, false, false, true)
    end
end

-- remove ball
local function removeBall()
    if ball and DoesEntityExist(ball) then
        DeleteObject(ball)
        ball = nil
    end
end

-- do a raycast from camera forward
local function raycastFromCamera()
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local dir = rotToDir(camRot)
    local farCoords = camCoords + dir * 200.0

    local handle = StartShapeTestRay(
        camCoords.x, camCoords.y, camCoords.z,
        farCoords.x, farCoords.y, farCoords.z,
        -1, PlayerPedId(), 7
    )
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
    if hit and endCoords then
        return endCoords, entityHit
    end
    return nil, nil
end

-- copy via NUI (html) and print to chat
local function copyCoords(coords)
    if not coords then return end
    local text = string.format("vector3(%.3f, %.3f, %.3f)", coords.x, coords.y, coords.z)
    -- send to NUI to copy to system clipboard
    SendNUIMessage({ action = 'copy', text = text })
    -- print to chat
    TriggerEvent('chat:addMessage', { args = { '^2[TennisCoords] ^7Koords kopiert:', text } })
end

-- ======================
-- Commands & KeyMapping
-- ======================
RegisterCommand('toggleball', function()
    enabled = not enabled
    if not enabled then
        removeBall()
        TriggerEvent('chat:addMessage', { args = { '^3[TennisCoords] ^7Deaktiviert.' } })
    else
        TriggerEvent('chat:addMessage', { args = { '^3[TennisCoords] ^7Aktiviert. Nutze F7 um Koords zu kopieren.' } })
    end
end, false)

RegisterCommand('copycoords', function()
    if lastCoords then
        copyCoords(lastCoords)
    else
        TriggerEvent('chat:addMessage', { args = { '^1[TennisCoords] ^7Keine gültigen Koords gefunden.' } })
    end
end, false)

RegisterKeyMapping('toggleball', 'Toggle Tennisball Placement', 'keyboard', 'F6')
RegisterKeyMapping('copycoords', 'Copy shown coords to clipboard', 'keyboard', 'F7')

-- ======================
-- Main Loop
-- ======================
CreateThread(function()
    RequestModel(tennisModel)
    while not HasModelLoaded(tennisModel) do
        Wait(10)
    end

    while true do
        Wait(0)

        if enabled then
            local hitCoords, hitEntity = raycastFromCamera()
            if hitCoords then
                local placed = vector3(hitCoords.x, hitCoords.y, hitCoords.z - 0.03)
                placeBallAt(placed)
                lastCoords = placed
            end
        else
            Wait(250)
        end
    end
end)

-- NUI callback (optional)
RegisterNUICallback('copied', function(data, cb)
    cb('ok')
end)
