local tennisModel = 'prop_tennis_ball' -- Model
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

-- copy using ox_lib clipboard and notify
local function copyCoords(coords)
    if not coords then return end
    local text = string.format("vector3(%.3f, %.3f, %.3f)", coords.x, coords.y, coords.z)
    -- copy to clipboard using ox_lib
    lib.setClipboard(text)
    -- show notification using ox_lib
    lib.notify({
        title = locale('title'),
        description = locale('notifications.coords_copied', text),
        type = 'success',
        duration = 3000
    })
end

-- ======================
-- Commands & Events
-- ======================
RegisterNetEvent('neilo_coords:toggleBall', function()
    enabled = not enabled
    if not enabled then
        removeBall()
        lib.notify({
            title = locale('title'),
            description = locale('notifications.deactivated'),
            type = 'info',
            duration = 3000
        })
    else
        lib.notify({
            title = locale('title'),
            description = locale('notifications.activated'),
            type = 'success',
            duration = 4000
        })
    end
end)

RegisterNetEvent('neilo_coords:copyCoords', function()
    if lastCoords then
        copyCoords(lastCoords)
    else
        lib.notify({
            title = locale('title'),
            description = locale('notifications.no_valid_coords'),
            type = 'error',
            duration = 3000
        })
    end
end)

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

