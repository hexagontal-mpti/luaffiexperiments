print 'LUA: Loading ffi & header...'
local ffi = require 'ffi'
local hfile = io.open('praylib.h')
local header = hfile:read('a')
hfile:close()
ffi.cdef(header)

print 'LUA: Header done. Loading library...'

rl = ffi.load 'libraylib'

print 'LUA: Library done. Init types...'

local color = ffi.metatype('Color', {})
local CL_RED = color(255, 0, 0, 255)
local CL_BLACK = color(0, 0, 0, 255)
local CL_WHITE = color(255, 255, 255, 255)
print 'LUA: Types done. Starting window...'

local sx = 800
local sy = 450
local time = 0

rl.InitWindow(sx, sy, "abobochka...")
rl.SetTargetFPS(60)
print 'LUA: Window started. Caching texture...'

local rad = 32

local circleTexture = rl.LoadRenderTexture(rad*2, rad*2)

rl.BeginTextureMode(circleTexture)
rl.DrawCircle(rad,rad,rad,CL_RED)
rl.DrawCircleLines(rad,rad,rad,CL_BLACK)
rl.EndTextureMode()

print 'LUA: Cache done. Starting mainloop...'

while not rl.WindowShouldClose() do
  sx = rl.GetRenderWidth()
  sy = rl.GetRenderHeight()
  time = time + rl.GetFrameTime()
  rl.BeginDrawing()
  rl.ClearBackground(CL_WHITE)
  rl.DrawTexture(circleTexture.texture, 
    math.sin(time)*sx/2+sx/2-rad,
    math.cos(time)*sy/2+sy/2-rad,
    CL_WHITE)
  rl.DrawFPS(0,0)
  rl.EndDrawing()
end

print 'LUA: Mainloop done. Unloading everything...'

rl.UnloadRenderTexture(circleTexture)
rl.CloseWindow()

print 'LUA: Goodbye!'
