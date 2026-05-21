(print "LUA: Loading ffi & header")
(local ffi (require :ffi))
(let [hfile (io.open "praylib.h")]
  (ffi.cdef (hfile:read :a))
  (hfile:close))
(print "LUA: Header done. Loading library...")

(local rl (ffi.load :libraylib))

(print "LUA: Library done. Init types...")

(local color (ffi.metatype "Color" {}))
(local CL_RED (color 255 0 0 255))
(local CL_BLACK (color 0 0 0 255))
(local CL_WHITE (color 255 255 255 255))

(print "LUA: Types done. Starting window...")

(var time 0)
(var sx 800)
(var sy 450)

(rl.InitWindow sx sy :bebrochka)
(rl.SetTargetFPS 60)

(print "LUA: Window started. Caching texture...")

(local rad 32)
(local circleTexture (rl.LoadRenderTexture (* rad 2) (* rad 2)))

(rl.BeginTextureMode circleTexture)
(rl.DrawCircle rad rad rad CL_RED)
(rl.DrawCircleLines rad rad rad CL_BLACK)
(rl.EndTextureMode)

(print "LUA: Cache done. Starting mainloop...")

(while (not (rl.WindowShouldClose))
  (set sx (rl.GetRenderWidth))
  (set sy (rl.GetRenderHeight))
  (set time (+ time (rl.GetFrameTime)))
  (rl.BeginDrawing)
  (rl.ClearBackground CL_WHITE)
  (rl.DrawTexture circleTexture.texture
    (+ (* (math.sin time) (/ sx 2)) (/ sx 2) (- rad))
    (+ (* (math.cos time) (/ sy 2)) (/ sy 2) (- rad))
    CL_WHITE)
  (rl.DrawFPS 0 0)
  (rl.EndDrawing))

(print "LUA: Mainloop done. Unloading everything...")

(rl.UnloadRenderTexture circleTexture)
(rl.CloseWindow)

(print "LUA: Goodbye!")
