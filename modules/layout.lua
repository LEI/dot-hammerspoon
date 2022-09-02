-- Watch the number of display and adjust window layout

hs.layout.center = {0.1, 0.1, 0.8, 0.8}

local function applyWindowLayout(screens)
    -- screens[2] -> attempt to index a nil value (field '?')
    local windowLayout = {
        {"Terminal", nil, screens[1]:name(), nil, nil, screens[1]:fullFrame()},
        {"Google Chrome", nil, screens[1]:name(), nil, nil, nil},
        {"Firefox", nil, screens[2]:name(), hs.layout.center, nil, nil},
        {"Microsoft Teams", nil, screens[2]:name(), hs.layout.maximized, nil, nil},
        {"Sequel Pro", nil, screens[2]:name(), hs.layout.center, nil, nil},
        {"Spotify", nil, screens[2]:name(), hs.layout.center, nil, nil},
        -- {"Activity Monitor", nil, screens[2]:name(), hs.layout.center, nil, nil},
        -- {"Finder", nil, screens[1]:name(), hs.layout.center, nil, nil},
        -- {"Google Chrome", "Postman", screens[2]:name(), hs.layout.center, nil, nil},
        -- {"Mail", nil, screens[2]:name(), hs.layout.right50, nil, nil },
        -- {"Skype", nil, screens[1]:name(), hs.layout.left50, nil, nil },
        -- {"Slack", nil, screens[1]:name(), hs.layout.center, nil, nil },
    }

    hs.layout.apply(windowLayout)
end

function watchApps(appName, eventType, appObject)
    local log = hs.logger.new('app')
    if (eventType == hs.application.watcher.activated) then
        log.i(appName, "appName")
        log.i(appObject:focusedWindow(), "appFocusedWin")
        -- if (appName == "Terminal") then
        --     local win = appObject:focusedWindow()
        --     if win ~= nil then -- & isFullScreen?
        --         win:setFullScreen(true)
        --     end
        -- end
    end
end

local function watchScreens()
    local screens = hs.screen.allScreens()

    -- local log = hs.logger.new('Screen Watcher')
    -- log.i("nbScreens:", #screens)
    -- log.i("lastScreen:", lastCount)

    -- hs.brightness.get()

    if #screens ~= lastCount then
        if #screens == 1 then
            screens[2] = screens[1]
        end
        applyWindowLayout(screens)
    end

    lastCount = #screens
end

return {
    init = function()
        -- local appWatcher = hs.application.watcher.new(watchApps)
        -- appWatcher:start()

        local screenWatcher = hs.screen.watcher.new(watchScreens)
        screenWatcher:start()

        watchScreens()
    end
}
