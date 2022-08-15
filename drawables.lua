local drawables = {}
local playerSize = 8
local P2 = math.pi/2
local P3 = 3*math.pi/2
local DR = math.pi / 180 -- One degree in radians
local imgDecoder = require("imageDecoder")

local image = imgDecoder("brick.png")

function drawables.drawPlayer()
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", Player.X, Player.Y, playerSize, playerSize)

    love.graphics.setLineWidth(3)
    love.graphics.line(Player.X+(playerSize/2), Player.Y+(playerSize/2), Player.X+Player.DeltaX*5+(playerSize/2), Player.Y+Player.DeltaY*5+(playerSize/2))
end

function drawables.drawMap2D()
    for x = 0, Map.X do
        for y = 0, Map.Y do
            if Map.Grid[y*Map.X+x] == 1 then
                love.graphics.setColor(1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0)
            end
            local xo, yo = x*Map.Size, y*Map.Size
            love.graphics.rectangle("fill", xo-Map.Size + 5, yo + 5, Map.Size, Map.Size)
        end
    end
end

function drawables.drawRays2D()
    for ray = 0, 64 do
        local rayAngle = Player.Angle - math.rad(30 - ray + 1)
        rayAngle = rayAngle % (2 * math.pi)

        local rayX, rayY

        -- Check Horizontal Lines
        local distHoriz  = 1000000
        local horizX, horizY = Player.X, Player.Y
        do
            local depthOfField = 0
            local aTan = -1/math.tan(rayAngle)
            local offsetX, offsetY = 0, 0

            if rayAngle > math.pi then -- Looking up
                rayY = math.floor(Player.Y / 64) * 64 - 0.0001
                rayX = (Player.Y - rayY)*aTan + Player.X
                offsetY = offsetY - 64
                offsetX = offsetX - offsetY*aTan
            elseif rayAngle < math.pi then -- Looking down
                rayY = math.floor(Player.Y / 64) * 64 + 64
                rayX = (Player.Y - rayY)*aTan + Player.X
                offsetY = offsetY + 64
                offsetX = offsetX - offsetY*aTan
            else -- Looking straight left or right
                rayX, rayY, depthOfField = Player.X, Player.Y, 8
            end

            while depthOfField < 8 do
                local midX = math.floor(rayX / 64)
                local midY = math.floor(rayY / 64)
                local midPoint = midY*Map.X + midX
                if midPoint > 0 and midPoint < Map.X * Map.Y and Map.Grid[midPoint + 1] == 1 then -- Hit Wall
                    horizX, horizY = rayX, rayY
                    distHoriz = dist(Player.X, Player.Y, horizX, horizY, rayAngle)
                    depthOfField = 8
                else -- Next line
                    rayX = rayX + offsetX
                    rayY = rayY + offsetY
                    depthOfField = depthOfField + 1
                end
            end
        end

        -- Check Vertical Lines
        local distVert = 1000000
        local vertX, vertY = Player.X, Player.Y
        do
            local depthOfField = 0
            local nTan = -math.tan(rayAngle)
            local offsetX, offsetY = 0, 0

            if rayAngle > P2 and rayAngle < P3 then -- Looking left
                rayX = math.floor(Player.X / 64) * 64 - 0.0001
                rayY = (Player.X - rayX)*nTan+Player.Y
                offsetX = offsetX - 64
                offsetY = offsetY - offsetX*nTan
            elseif rayAngle < P2 or rayAngle > P3 then -- Looking right
                rayX = math.floor(Player.X / 64) * 64 + 64
                rayY = (Player.X - rayX)*nTan + Player.Y
                offsetX = offsetX + 64
                offsetY = offsetY - offsetX*nTan
            else -- Looking up or down
                rayX, rayY, depthOfField = Player.X, Player.Y, 8
            end

            while depthOfField < 8 do
                local midX = math.floor(rayX / 64)
                local midY = math.floor(rayY / 64)
                local midPoint = midY*Map.X+midX
                if midPoint > 0 and midPoint < Map.X * Map.Y and Map.Grid[midPoint + 1] == 1 then -- Hit Wall
                    vertX, vertY = rayX, rayY
                    distVert = dist(Player.X, Player.Y, vertX, vertY, rayAngle)
                    depthOfField = 8
                else -- Next line
                    rayX = rayX + offsetX
                    rayY = rayY + offsetY
                    depthOfField = depthOfField + 1
                end
            end
        end

        local distFinal
        if distVert <= distHoriz then -- Vertical wall hit
            rayX, rayY = vertX, vertY
            distFinal = distVert
            love.graphics.setColor(0.9, 0, 0)
        else -- Horizontal wall hit
            rayX, rayY = horizX, horizY
            distFinal = distHoriz
            love.graphics.setColor(0.7, 0, 0)
        end

        love.graphics.setLineWidth(3)
        love.graphics.line(Player.X+(playerSize/2), Player.Y+(playerSize/2), rayX+(playerSize/2), rayY+(playerSize/2))
    end
end

function drawables.drawRays3D()
    for ray = 0, 64 do
        local rayAngle = Player.Angle - math.rad(30 - ray + 1)
        rayAngle = rayAngle % (2 * math.pi)

        local rayX, rayY

        -- Check Horizontal Lines
        local distHoriz  = 1000000
        local horizX, horizY = Player.X, Player.Y
        do
            local depthOfField = 0
            local aTan = -1/math.tan(rayAngle)
            local offsetX, offsetY = 0, 0

            if rayAngle > math.pi then -- Looking up
                rayY = math.floor(Player.Y / 64) * 64 - 0.0001
                rayX = (Player.Y - rayY)*aTan + Player.X
                offsetY = offsetY - 64
                offsetX = offsetX - offsetY*aTan
            elseif rayAngle < math.pi then -- Looking down
                rayY = math.floor(Player.Y / 64) * 64 + 64
                rayX = (Player.Y - rayY)*aTan + Player.X
                offsetY = offsetY + 64
                offsetX = offsetX - offsetY*aTan
            else -- Looking straight left or right
                rayX, rayY, depthOfField = Player.X, Player.Y, 8
            end

            while depthOfField < 8 do
                local midX = math.floor(rayX / 64)
                local midY = math.floor(rayY / 64)
                local midPoint = midY*Map.X + midX
                if midPoint > 0 and midPoint < Map.X * Map.Y and Map.Grid[midPoint + 1] == 1 then -- Hit Wall
                    horizX, horizY = rayX, rayY
                    distHoriz = dist(Player.X, Player.Y, horizX, horizY, rayAngle)
                    depthOfField = 8
                else -- Next line
                    rayX = rayX + offsetX
                    rayY = rayY + offsetY
                    depthOfField = depthOfField + 1
                end
            end
        end

        -- Check Vertical Lines
        local distVert = 100000000
        local vertX, vertY = Player.X, Player.Y
        do
            local depthOfField = 0
            local nTan = -math.tan(rayAngle)
            local offsetX, offsetY = 0, 0

            if rayAngle > P2 and rayAngle < P3 then -- Looking left
                rayX = math.floor(Player.X / 64) * 64 - 0.0001
                rayY = (Player.X - rayX)*nTan+Player.Y
                offsetX = offsetX - 64
                offsetY = offsetY - offsetX*nTan
            elseif rayAngle < P2 or rayAngle > P3 then -- Looking right
                rayX = math.floor(Player.X / 64) * 64 + 64
                rayY = (Player.X - rayX)*nTan + Player.Y
                offsetX = offsetX + 64
                offsetY = offsetY - offsetX*nTan
            else -- Looking up or down
                rayX, rayY, depthOfField = Player.X, Player.Y, 8
            end

            while depthOfField < 8 do
                local midX = math.floor(rayX / 64)
                local midY = math.floor(rayY / 64)
                local midPoint = midY*Map.X+midX
                if midPoint > 0 and midPoint < Map.X * Map.Y and Map.Grid[midPoint + 1] == 1 then -- Hit Wall
                    vertX, vertY = rayX, rayY
                    distVert = dist(Player.X, Player.Y, vertX, vertY, rayAngle)
                    depthOfField = 8
                else -- Next line
                    rayX = rayX + offsetX
                    rayY = rayY + offsetY
                    depthOfField = depthOfField + 1
                end
            end
        end

        local distFinal
        local shade = 1
        local wallOffset
        if distVert <= distHoriz then -- Vertical wall hit
            rayX, rayY = vertX, vertY
            distFinal = distVert
            shade = 0.9
            love.graphics.setColor(0.9, 0, 0)
            wallOffset = rayY
            if rayAngle > P2 and rayAngle < P3 then
                wallOffset = -wallOffset
            end
        else -- Horizontal wall hit
            rayX, rayY = horizX, horizY
            distFinal = distHoriz
            love.graphics.setColor(0.7, 0, 0)
            shade = 0.7
            wallOffset = rayX
            if rayAngle < math.pi then
                wallOffset = -wallOffset
            end
        end

        -- Draw 3D Walls
        local ca = Player.Angle-rayAngle
        distFinal = distFinal*math.cos(ca) -- Fix fisheye

        local lineHeight = Map.Size * 512/distFinal
        local lineOffset = 256 - lineHeight/2

        local textureY, textureYStep = 0, image.Y/lineHeight
        local textureX = (wallOffset * image.X / 64) % image.X

        for y = 0, lineHeight do
            local c = image[math.floor(textureX)][math.floor(textureY)]
            love.graphics.setColor(c.r*shade, c.g*shade, c.b*shade)
            love.graphics.points(ray*16, y+lineOffset)
            textureY = textureY + textureYStep
        end
    end
end

return drawables