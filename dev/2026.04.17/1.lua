local rl = require("raylib")

rl.InitWindow(800, 800, "mouse")

local ball_position = { x = 0, y = 0 }
local ball_color = rl.DARKBLUE

local MB_LEFT, MB_RIGHT, MB_MIDDLE = 0, 1, 2

while not rl.WindowShouldClose() do
  ball_position.x = rl.GetMouseX()
  ball_position.y = rl.GetMouseY()

  if rl.IsMouseButtonPressed(MB_LEFT) then
    ball_color = rl.MAROON
  elseif rl.IsMouseButtonPressed(MB_MIDDLE) then
    ball_color = rl.BLACK
  elseif rl.IsMouseButtonPressed(MB_RIGHT) then
    ball_color = rl.DARKBLUE
  end

  rl.BeginDrawing()
    rl.DrawCircleV(ball_position, 50, ball_color)
  rl.EndDrawing()
end

rl.CloseWindow()
