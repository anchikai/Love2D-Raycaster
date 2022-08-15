local drawables = require("drawables")
require("reset")

function dist(ax, ay, bx, by, ang)
    return math.sqrt((bx-ax) * (bx-ax) + (by-ay) * (by-ay))
end

PointSize = 22
function love.load()
    -- Window Shit
    love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
    love.window.setMode(1920, 1080, {fullscreen = true})
    CenterX = love.graphics.getWidth()/2
    CenterY = love.graphics.getHeight()/2
    love.graphics.setPointSize(PointSize)

    -- Player
    Player = {}
    Player.Angle = 0
    Player.X, Player.Y = 96, CenterY+128
    Player.DeltaX, Player.DeltaY = math.cos(Player.Angle)*5, math.sin(Player.Angle)*5
    Player.DeltaX2, Player.DeltaY2 = math.cos(Player.Angle-(math.pi/2))*5, math.sin(Player.Angle-(math.pi/2))*5
    Player.offsetX, Player.offsetY = 0, 0

    -- Map/World
    Map = {}
    Map.X, Map.Y, Map.Size = 16, 16, 64
    Map.Grid = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1,
        1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1,
        1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1,
        1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1,
        1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1,
        1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1,
        1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    }

    RenderType = 3
    ShowRays = true
end

local rayCooldown, resetCooldown = 0, 0
function love.update(dt)
    love.mouse.setVisible(not love.window.hasFocus())
    -- Player Movement
    if love.window.hasFocus() then
        if love.mouse.getX() < CenterX then
            Player.Angle = Player.Angle - (CenterX-love.mouse.getX())*0.0015
            if Player.Angle < 0 then
                Player.Angle = Player.Angle + 2*math.pi
            end
            Player.DeltaX = math.cos(Player.Angle)*5
            Player.DeltaY = math.sin(Player.Angle)*5
            Player.DeltaX2 = math.cos(Player.Angle-(math.pi/2))*5
            Player.DeltaY2 = math.sin(Player.Angle-(math.pi/2))*5
        end
        if love.mouse.getX() > CenterX then
            Player.Angle = Player.Angle + (love.mouse.getX()-CenterX)*0.0015
            if Player.Angle > 2*math.pi then
                Player.Angle = Player.Angle - 2*math.pi
            end
            Player.DeltaX = math.cos(Player.Angle)*5
            Player.DeltaY = math.sin(Player.Angle)*5
            Player.DeltaX2 = math.cos(Player.Angle-(math.pi/2))*5
            Player.DeltaY2 = math.sin(Player.Angle-(math.pi/2))*5
        end
    end

    -- Collision
    if Player.DeltaX < 0 then
        Player.offsetX = -20
    else
        Player.offsetX = 20
    end
    if Player.DeltaY < 0 then
        Player.offsetY = -20
    else
        Player.offsetY = 20
    end
    local playerGridX, playerGridY = math.floor(Player.X/64), math.floor(Player.Y/64)
    local playerGridX_add_xOffset, playerGridY_add_yOffset = (Player.X + Player.DeltaX)/64, (Player.Y + Player.DeltaY)/64
    local playerGridX_sub_xOffset, playerGridY_sub_yOffset = (Player.X - Player.DeltaX)/64, (Player.Y - Player.DeltaY)/64
    local playerGridX_add_yOffset, playerGridY_add_xOffset = (Player.X + Player.DeltaX2)/64, (Player.Y + Player.DeltaY2)/64
    local playerGridX_sub_yOffset, playerGridY_sub_xOffset = (Player.X - Player.DeltaX2)/64, (Player.Y - Player.DeltaY2)/64

    -- Forward/Backward
    if love.keyboard.isDown("w") then
        if Map.Grid[math.floor(playerGridY*Map.X + playerGridX_add_xOffset) + 1] == 0 then
            Player.X = Player.X + Player.DeltaX/2
        end
        if Map.Grid[math.floor(math.floor(playerGridY_add_yOffset)*Map.X + playerGridX) + 1] == 0 then
            Player.Y = Player.Y + Player.DeltaY/2
        end
    end
    if love.keyboard.isDown("s") then
        if Map.Grid[math.floor(playerGridY*Map.X + playerGridX_sub_xOffset) + 1] == 0 then
            Player.X = Player.X - Player.DeltaX/2
        end
        if Map.Grid[math.floor(math.floor(playerGridY_sub_yOffset)*Map.X + playerGridX) + 1] == 0 then
            Player.Y = Player.Y - Player.DeltaY/2
        end
    end

    -- Left/Right
    if love.keyboard.isDown("a") then
        if Map.Grid[math.floor(playerGridY*Map.X + playerGridX_add_yOffset) + 1] == 0 then
            Player.X = Player.X + Player.DeltaX2/2
        end
        if Map.Grid[math.floor(math.floor(playerGridY_add_xOffset)*Map.X + playerGridX) + 1] == 0 then
            Player.Y = Player.Y + Player.DeltaY2/2
        end
    end
    if love.keyboard.isDown("d") then
        if Map.Grid[math.floor(playerGridY*Map.X + playerGridX_sub_yOffset) + 1] == 0 then
            Player.X = Player.X - Player.DeltaX2/2
        end
        if Map.Grid[math.floor(math.floor(playerGridY_sub_xOffset)*Map.X + playerGridX) + 1] == 0 then
            Player.Y = Player.Y - Player.DeltaY2/2
        end
    end

    -- Switch Render Mode
    if love.keyboard.isDown("2") then RenderType = 2 end
    if love.keyboard.isDown("3") then RenderType = 3 end

    -- Toggle Ray Rendering
    if love.keyboard.isDown("1") then
        if rayCooldown ~= 1 then
            ShowRays = not ShowRays
        end
        rayCooldown = 1
    else
        rayCooldown = 0
    end

    -- Reset
    if love.keyboard.isDown("r") then
        if resetCooldown ~= 1 then
            reset()
        end
        resetCooldown = 1
    else
        resetCooldown = 0
    end
    if love.window.hasFocus() then
        love.mouse.setPosition(CenterX, CenterY)
    end
end

function love.draw()
    if RenderType == 2 then
        drawables.drawMap2D()
        if ShowRays and RenderType == 2 then
            drawables.drawRays2D()
        end
        drawables.drawPlayer()
    elseif RenderType == 3 then
        drawables.drawRays3D()
    end
end