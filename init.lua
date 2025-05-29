local drawing = hs.drawing -- 用于在屏幕上绘制文本
local window = hs.window -- 用于处理窗口
local hotkey = hs.hotkey -- 用于绑定键盘快捷键
local spaces = hs.spaces -- 用于检测 Mission Control
local application = hs.application -- 用于处理应用程序

--[[ HyperKey ]]
local hyper = {'cmd', 'ctrl', 'alt', 'shift'}
local HyperKey = hs.loadSpoon("HyperKey")
hyperKey = HyperKey:new(hyper, {
    overlayTimeoutMs = 1000,
})

--[[ SuperKey ]]
local superKey = {'cmd', 'alt', 'ctrl'}

--[[ 切换应用 ]]
hyperKey:bind('x'):toApplication('/Applications/WeChat.app')
hyperKey:bind('g'):toApplication('/Applications/Google Chrome.app')
hyperKey:bind('e'):toApplication('/Applications/Cursor.app')
hyperKey:bind('n'):toApplication('/Applications/Obsidian.app')
hyperKey:bind('i'):toApplication('/Applications/Warp.app')
hyperKey:bind('c'):toApplication('/Applications/Cherry Studio.app')
hyperKey:bind('f'):toApplication('/Applications/Figma.app')
hyperKey:bind('m'):toApplication('/Applications/iPhone Mirroring.app')
hyperKey:bind('q'):toApplication('/Applications/Telegram.app')
hyperKey:bind('y'):toApplication('/Applications/DingTalk.app')


--[[ 音量调整 ]]
function changeVolume(diff)
    return function()
        local current = hs.audiodevice.defaultOutputDevice():volume()
        local new = math.min(100, math.max(0, math.floor(current + diff)))
        if new > 0 then
            hs.audiodevice.defaultOutputDevice():setMuted(false)
        end
        hs.alert.closeAll(0.0)
        hs.alert.show("Volume " .. new .. "%", {}, 0.5)
        hs.audiodevice.defaultOutputDevice():setVolume(new)
    end
end

hs.hotkey.bind(superKey, 'a', changeVolume(-5))
hs.hotkey.bind(superKey, 's', changeVolume(5))

--[[ 切换静音/非静音 ]]
hs.hotkey.bind(superKey, "m", function()
    hs.audiodevice.defaultOutputDevice():setMuted(not hs.audiodevice.defaultOutputDevice():muted())
end)
--[[ 播放/暂停音乐 ]]
hs.hotkey.bind(superKey, "f", function()
    hs.itunes.playpause()
end)

--[[ Hammer 开发调试，用 superKey 绑定 ]]
--[[ 重载配置Key ]]
hs.hotkey.bind(superKey, "r", function()
    hs.reload()
end)

hs.alert.show("Hammerspoon Config loaded")

--[[ Show HammerspoonKey Console ]]
hs.hotkey.bind(superKey, "`", function()
    hs.toggleConsole()
end)

--[[ 切换深色/浅色模式 ]]
hs.hotkey.bind(superKey, "d", function()
    local darkMode = hs.osascript.applescript([[
        tell application "System Events"
            tell appearance preferences
                set dark mode to not dark mode
            end tell
        end tell
    ]])
    if darkMode then
        hs.alert.show("Dark Mode Enabled")
    else
        hs.alert.show("Dark Mode Disabled")
    end
end)

if hs.location.servicesEnabled() then
    hs.location.start()

    local location = hs.location.get()
    if location then
        print("Current Location:")
        print("Latitude: " .. location.latitude)
        print("Longitude: " .. location.longitude)
        print("Altitude: " .. location.altitude)
        print("Horizontal Accuracy: " .. location.horizontalAccuracy)
        print("Vertical Accuracy: " .. location.verticalAccuracy)
    else
        print("Unable to retrieve location information.")
    end
    hs.location.stop()
else
    print("Location services are not enabled.")
end

--[[ wifi 监听 ]]
wifiWatcher = nil
homeSSID = "XiaomiSB_5G"
officeSSID = "GD-Office"
lastSSID = hs.wifi.currentNetwork()
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    --[[ 办公室 wifi 监听 ]]
    if newSSID == officeSSID and lastSSID ~= officeSSID then
        print("Joined Office WiFi")
    elseif newSSID ~= officeSSID and lastSSID == officeSSID then
        print("Departed Office WiFi")
    end

    --[[ 家里 wifi 监听 ]]
    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        print("Joined Home WiFi")
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        print("Departed Home WiFi")
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

--[[ demo: 使用 URL 自动化 Hammerspoon ]]
--[[ 使用方式： `open -g hammerspoon://someAlert` ]]
hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)