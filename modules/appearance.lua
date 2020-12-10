-- Location base Redshift
-- github.com/heptal/dotfiles/blob/master/roles/hammerspoon/files/redshift.lua

-- make a windowfilterDisable for redshift: VLC, Photos and screensaver/login window will disable color adjustment and inversion
--local wfRedshift=hs.window.filter.new({VLC={focused=true},Photos={focused=true},loginwindow={visible=true,allowRoles='*'}},'wf-redshift')
-- start redshift: 2800K + inverted from 21 to 7, very long transition duration (19->23 and 5->9)
--hs.redshift.start(2800,'21:00','7:00','4h',true,wfRedshift)
-- allow manual control of inverted colors
--hs.hotkey.bind(HYPER,'f1','Invert',hs.redshift.toggleInvert)

local lastMode = nil

hs.location.start()

-- https://www.hammerspoon.org/docs/hs.timer.html (doAfter, doAt, doEvery...)
hs.timer.doAfter(1, function()
    local loc = hs.location.get()
    hs.location.stop()
    -- hs.location.register("dark-mode", function() end)
    hs.timer.doEvery(60, function()
        local now = os.date("%H:%M")
        local times = {sunrise = "08:00", sunset = "20:00"}

        if loc then
            local tzOffset = tonumber(string.sub(os.date("%z"), 1, -3))
            for i, v in pairs({"sunrise", "sunset"}) do
                local t = hs.location[v](loc.latitude, loc.longitude, tzOffset)
                times[v] = os.date("%H:%M", t)
            end
        end

        -- hs.redshift.start(3600, times.sunset, times.sunrise)

        -- https://github.com/ApolloZhu/Dynamic-Dark-Mode

        local value = nil
        if now > times.sunrise and now < times.sunset then
            if lastMode ~= "day" then
                value = "false"
                lastMode = "day"
            end
        else -- now < times.sunrise and now > times.sunset
            if lastMode ~= "night" then
                value = "true"
                lastMode = "night"
            end
        end
        if value ~= nil then
        -- if value == "true" or value == "false" then
            print("It's " .. lastMode .. " time, setting dark mode to " .. value .. ".")
            -- set dark mode to not dark mode
            hs.applescript.applescript([[
                tell application "System Events"
                    tell appearance preferences
                        set dark mode to ]] .. value .. [[
                        # Y U NO \n
                    end tell
                end tell
            ]])
        end
    end)
end)

return {
    init = nil
}
