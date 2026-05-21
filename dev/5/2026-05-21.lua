local s = [[
Этот код выполняет HTTP-запрос к API,
который принимает Lua-код,
выполняет его и возвращает результат.

> По минимуму использовать скобки, пример:
print "текст"
> НЕ использовать string в string.format и других вместо него 
нужно использовать s, пример:
(s).format("%s", "текст")
> НЕ использовать .. для конкатенации строк,
вместо этого использовать (s).format, пример:
(s).format("%s%s%s", "1", "2", "3")

Планы:
admin
image
posts
theme
chats

# date +"%Y-%m-%d.lua"

https://github.com/hexagontal-mpti
]]

local http  = require "socket.http"
local ltn12 = require "ltn12"
local cjson = require "cjson"

local url   = require "socket.url"
local cat = "https://v0-hexagontal.vercel.app"
local seq = 'local s = "Ура великой растпобеде!"; print(s); return s'
local api = "api/commands?cmd=lua&code=" .. url.escape(seq)
local url = string.format("%s/%s", cat, api) -- string.format, котиков не трогаем :)
local dog = {}
local log = 0 -- Переключатель великой растпобеды!

local res, code, headers, status = http.request{url = url, sink = ltn12.sink.table(dog)}

if code == 200 then
    local json_str = table.concat(dog)
    local data = cjson.decode(json_str)
    
    if data and data.output then
        local res = ""

        for num in (s).gmatch(data.output, "%d+") do
            res = res .. (s).char(tonumber(num))
        end

        if log > 0 then --[[Проверка великой растпобеды, 
            если включена, то выводим результат сервера,
            иначе просто результат]]
            print("Результат сервера: " .. res)
            if data.success then 
                print "растпобеда.рф!"
            else print [[БРО!
СЕРВЕР ВЕРНУЛ ОШИБКУ!
ПРОВЕРЬ КОД!]] end
        else print(res) end

    end

else 
    print("Ошибка HTTP: " .. tostring(code)) 
end
