local drawables = require("drawables")
require("reset")

function dist(ax, ay, bx, by, ang)
    return math.sqrt((bx-ax) * (bx-ax) + (by-ay) * (by-ay))
end

function love.load()
    -- Window Shit
    love.graphics.setBackgroundColor(0.3, 0.3, 0.3)
    love.window.setMode(1024, 512)

    -- Player
    Player = {}
    Player.Angle = 0
    Player.X, Player.Y = 512, 256
    Player.DeltaX, Player.DeltaY = math.cos(Player.Angle)*5, math.sin(Player.Angle)*5

    -- Map/World
    Map = {}
    Map.X, Map.Y, Map.Size = 16, 8, 64
    Map.Grid = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    }

    RenderType = 3
    ShowRays = true
end

local rayCooldown, resetCooldown = 0, 0
function love.update(dt)
    -- Player Movement
    if love.keyboard.isDown("a") then
        Player.Angle = Player.Angle - 0.1
        if Player.Angle < 0 then
            Player.Angle = Player.Angle + 2*math.pi
        end
        Player.DeltaX = math.cos(Player.Angle)*5
        Player.DeltaY = math.sin(Player.Angle)*5
    end
    if love.keyboard.isDown("d") then
        Player.Angle = Player.Angle + 0.1
        if Player.Angle > 2*math.pi then
            Player.Angle = Player.Angle - 2*math.pi
        end
        Player.DeltaX = math.cos(Player.Angle)*5
        Player.DeltaY = math.sin(Player.Angle)*5
    end
    if love.keyboard.isDown("w") then Player.X = Player.X + Player.DeltaX/2 Player.Y = Player.Y + Player.DeltaY/2 end
    if love.keyboard.isDown("s") then Player.X = Player.X - Player.DeltaX/2 Player.Y = Player.Y - Player.DeltaY/2 end

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