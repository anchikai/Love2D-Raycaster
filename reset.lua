function reset()
    Player.Angle = 0
    Player.X, Player.Y = 512, 256
    Player.DeltaX, Player.DeltaY = math.cos(Player.Angle)*5, math.sin(Player.Angle)*5
end