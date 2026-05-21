local rl = require("raylib")

rl.InitWindow(400, 400, "2026.04.15")

rl.SetTargetFPS(60)

while not rl.WindowShouldClose() do
    rl.BeginDrawing()
        rl.DrawText("# luajit main.lua", 0, 0, 32, rl.WHITE)
    rl.EndDrawing()
end

rl.CloseWindow()