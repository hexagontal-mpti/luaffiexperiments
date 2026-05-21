local rl = require("raylib")
local ffi = require("ffi")

rl.InitWindow(400,400,"shader debug")
rl.SetTargetFPS(60)

-- load shader and print status
local shader = rl.LoadShader(nil, "bg.fs")
print("shader:", shader and shader.id)
-- try to print program log functions if available
if rl.GetShaderLocation then
  print("GetShaderLocation available")
end

local uTime = rl.GetShaderLocation(shader, "iTime")
local uRes  = rl.GetShaderLocation(shader, "iResolution")
print("uTime,uRes:", uTime, uRes)

local time_buf = ffi.new("float[1]")
local res_buf  = ffi.new("float[2]")

local function setFloat(loc, buf, bytes)
  -- try pointer first
  local ok, err = pcall(function()
    rl.SetShaderValue(shader, loc, ffi.cast("const void *", buf), bytes)
  end)
  if not ok then
    -- fallback: pass string copy
    local s = ffi.string(ffi.cast("const char *", buf), bytes)
    rl.SetShaderValue(shader, loc, s, bytes)
  end
end

while not rl.WindowShouldClose() do
  local t = rl.GetTime()
  local w,h = rl.GetScreenWidth(), rl.GetScreenHeight()

  time_buf[0] = t
  res_buf[0] = w
  res_buf[1] = h

  if uTime ~= -1 then setFloat(uTime, time_buf, 4) end
  if uRes  ~= -1 then setFloat(uRes, res_buf, 8) end

  rl.BeginDrawing()
    rl.BeginShaderMode(shader)
      -- try DrawRectangle; also try DrawTexture if available
      rl.DrawRectangle(0,0,w,h, rl.WHITE)
    rl.EndShaderMode()
    rl.DrawText("shader debug", 10, 10, 20, rl.WHITE)
  rl.EndDrawing()
end

rl.UnloadShader(shader)
rl.CloseWindow()
