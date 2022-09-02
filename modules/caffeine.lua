-- Caffeine
-- https://github.com/cmsj/hammerspoon-config/blob/master/init.lua
-- http://jimmygreen.deviantart.com/art/Retina-Caffeine-menubar-icons-350451587

local caffeine = hs.menubar.new()

local modifiers = {} -- {"cmd"}
local character = "f19" -- "Right"
local delay = 100000 -- Default: 200000 (200ms)

function fn()
    if hs.host.idleTime() > 60 then
        hs.eventtap.keyStroke(modifiers, character, delay)
    end
end

local seconds = 30
local timer = hs.timer.new(seconds, fn)

function get()
    return hs.caffeinate.get("displayIdle")
end

function toggle()
    status = hs.caffeinate.toggle("displayIdle")
    if status then
        timer:start()
    else
        timer:stop()
    end
    return status
end

function setCaffeineDisplay(state)
    local icon = "caffeinIcon"
    if state then
        icon = icon .. "Active"
    end
    caffeine:setIcon("assets/" .. icon .. ".tiff")
end

function caffeineClicked()
    setCaffeineDisplay(toggle())
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(get())
end

local SpoonInstall = hs.loadSpoon('SpoonInstall')
SpoonInstall:installSpoonFromRepo('Caffeine')

local Caffeine = hs.loadSpoon('Caffeine')
Caffeine:start() -- Caffeine.setState(true)

return {
    init = nil
}
