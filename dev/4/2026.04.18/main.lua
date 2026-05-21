local rl = require("raylib")

local complex = {}
function complex.new(r, i) return {r = r, i = i or 0} end
function complex.add(a, b) return complex.new(a.r + b.r, a.i + b.i) end
function complex.sub(a, b) return complex.new(a.r - b.r, a.i - b.i) end
function complex.mul(a, b) return complex.new(a.r * b.r - a.i * b.i, a.r * b.i + a.i * b.r) end
function complex.div(a, b)
    local den = b.r * b.r + b.i * b.i
    return complex.new((a.r * b.r + a.i * b.i) / den, (a.i * b.r - a.r * b.i) / den)
end
function complex.abs(a) return math.sqrt(a.r * a.r + a.i * a.i) end

function complex.sqrt(a)
    local m = math.sqrt(a.r * a.r + a.i * a.i)
    local real = math.sqrt((m + a.r) / 2)
    local imag = (a.i >= 0 and 1 or -1) * math.sqrt(math.max(0, (m - a.r) / 2))
    return complex.new(real, imag)
end

function complex.tanh(a)
    local den = math.cosh(2 * a.r) + math.cos(2 * a.i)
    return complex.new(math.sinh(2 * a.r) / den, math.sin(2 * a.i) / den)
end

local function get_reflection_db(freq_ghz, num_layers)
    local eps0, mu0 = 8.854e-12, 1.256e-6
    local Z0 = math.sqrt(mu0 / eps0)
    local c0 = 1 / math.sqrt(eps0 * mu0)
    local omega = 2 * math.pi * freq_ghz * 1e9

    local layers = {
        {eps = complex.new(10, -3),  mu = complex.new(3, -0.0011), h = 3e-3},
        {eps = complex.new(2, -1),   mu = complex.new(1, 0),       h = 0.5e-3},
        {eps = complex.new(2, -0.3), mu = complex.new(1, 0),       h = 0.5e-3}
    }

    num_layers = math.max(0, math.min(num_layers, #layers))
    local zin = complex.new(Z0, 0)

    for i = 1, num_layers do
        local L = layers[i]
        local zc = complex.sqrt(complex.div(L.mu, L.eps))
        local sqrt_me = complex.sqrt(complex.mul(L.mu, L.eps))
        local imag_factor = complex.new(0, omega * L.h / c0)
        local gam_h = complex.mul(imag_factor, sqrt_me)
        local th = complex.tanh(gam_h)
        zin = complex.mul(zc, complex.div(complex.add(zin, complex.mul(zc, th)), complex.add(zc, complex.mul(zin, th))))
    end

    local r = complex.div(complex.sub(zin, complex.new(Z0, 0)), complex.add(zin, complex.new(Z0, 0)))
    local mag = complex.abs(r)
    if mag <= 0 then return -999 end
    return 20 * (math.log(mag) / math.log(10))
end

local function draw_plot(offset_x, offset_y)
    local colors = {{255, 50, 50}, {50, 255, 50}, {50, 50, 255}}
    local padding = 30
    local w, h = 320, 240

    for layer_idx = 1, 3 do
        for i = 0, 200 do
            local f = 1 + (i / 200) * 24
            local db = get_reflection_db(f, layer_idx)
            local x = offset_x + padding + (i / 200) * (w - 2 * padding)
            local y = offset_y + (h - padding) - ((db + 40) / 40) * (h - 2 * padding)
            local color = colors[layer_idx]
            rl.DrawRectangle(math.floor(x), math.floor(y), 2, 2, {color[1], color[2], color[3], 255})
        end
    end
end

rl.InitWindow(800, 800, "Complex Reflection Analysis")

local ox, oy = 100, 100

while not rl.WindowShouldClose() do
    rl.BeginDrawing()

    rl.ClearBackground({30, 30, 30, 255})
    -- 
    draw_plot(ox, oy)

    rl.EndDrawing()
end

rl.CloseWindow()