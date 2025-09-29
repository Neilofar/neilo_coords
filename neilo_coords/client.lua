local tennisModel = `prop_tennis_ball`
local ball = nil
local enabled = false
local lastCoords = nil

-- helper: rot to dir
local function rotToDir(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- spawn or move ball
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

-- raycast from camera
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
    local _, hit, endCoords = GetShapeTestResult(handle)
    if hit and endCoords then
        return endCoords
    end
    return nil
end

-- copy coords with ox_lib
local function copyCoords(coords)
    if not coords then return end
    local text = string.format("vector3(%.3f, %.3f, %.3f)", coords.x, coords.y, coords.z)
    lib.setClipboard(text)
    lib.notify({
        title = 'neilo_coords',
        description = 'Coordinates copied to clipboard:\n' .. text,
        type = 'success'
    })
end

-- main placement loop (starts only when enabled)
local function startPlacementLoop()
    CreateThread(function()
        RequestModel(tennisModel)
        while not HasModelLoaded(tennisModel) do Wait(10) end

        while enabled do
            Wait(0)
            local hitCoords = raycastFromCamera()
            if hitCoords then
                local placed = vector3(hitCoords.x, hitCoords.y, hitCoords.z - 0.03)
                placeBallAt(placed)
                lastCoords = placed
            end
        end
        -- cleanup wenn beendet
        removeBall()
    end)
end

-- commands
RegisterCommand('toggleball', function()
    enabled = not enabled
    if enabled then
        lib.notify({ title = 'neilo_coords', description = 'Enabled. Press F7 to copy coords.', type = 'info' })
        startPlacementLoop()
    else
        lib.notify({ title = 'neilo_coords', description = 'Disabled.', type = 'warning' })
    end
end, false)

RegisterCommand('copycoords', function()
    if lastCoords then
        copyCoords(lastCoords)
    else
        lib.notify({ title = 'neilo_coords', description = 'No valid coords found.', type = 'error' })
    end
end, false)

-- keybinds
RegisterKeyMapping('toggleball', 'Toggle Tennisball Placement', 'keyboard', 'F6')
RegisterKeyMapping('copycoords', 'Copy shown coords to clipboard', 'keyboard', 'F7')
