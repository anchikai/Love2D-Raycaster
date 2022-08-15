function reset()
    Player.Angle = 0
    Player.X, Player.Y = 96, CenterY+128
    Player.DeltaX, Player.DeltaY = math.cos(Player.Angle)*5, math.sin(Player.Angle)*5
    Player.DeltaX2, Player.DeltaY2 = math.cos(Player.Angle-(math.pi/2))*5, math.sin(Player.Angle-(math.pi/2))*5
end