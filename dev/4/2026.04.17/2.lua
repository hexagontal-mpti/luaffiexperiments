local rl = require("raylib")

rl.InitWindow(400, 400, "Raylib Lua Shader")

local shader = rl.LoadShader("shader.glsl", "shader.fs")

while not rl.WindowShouldClose() do
    rl.BeginDrawing()
    
    rl.BeginShaderMode(shader)
    rl.DrawRectangle(100, 100, 200, 200, rl.BLACK)
    rl.EndShaderMode()
    
    rl.EndDrawing()
end

rl.UnloadShader(shader)

rl.CloseWindow()
