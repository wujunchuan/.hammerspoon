local drawing = hs.drawing -- 用于在屏幕上绘制文本
local window = hs.window -- 用于处理窗口
local hotkey = hs.hotkey -- 用于绑定键盘快捷键
local spaces = hs.spaces -- 用于检测 Mission Control
local application = hs.application -- 用于处理应用程序

local hyperKey = {'cmd', 'ctrl', 'alt', 'shift'}
local superKey = {'cmd', 'alt', 'ctrl'}

--[[ 切换应用 ]]
local function switch_to_app(appName, bundleID)
    return function()
        -- Get focused window and app
        local focusedWindow = window.focusedWindow()
        local focusedApp = focusedWindow and focusedWindow:application()

        -- If already focused on target app, cycle between its windows
        if focusedApp and focusedApp:name() == appName then
            local appWindows = focusedApp:allWindows()
            if #appWindows > 1 then
                -- Find current window index
                local currentIndex = 1
                for i, win in ipairs(appWindows) do
                    if win == focusedWindow then
                        currentIndex = i
                        break
                    end
                end
                -- Focus next window (wrap around to first)
                local nextIndex = currentIndex % #appWindows + 1
                appWindows[nextIndex]:focus()
                return
            end
        end

        application.launchOrFocus(bundleID or appName)
    end
end

local labels = {} -- 数组，用于存储绘制的标签
local mcHotkeys = {} -- 数组，用于存储 Mission Control 中的快捷键

local function showLabelsInMissionControl()
    print("Mission Control activated - Showing window labels")
    for _, label in ipairs(labels) do
        label:delete()
    end
    labels = {} -- 清空数组

    for _, hk in pairs(mcHotkeys) do
        hk:delete()
    end
    mcHotkeys = {} -- 清空数组

    local visibleWindows = window.visibleWindows() -- 获取所有可见窗口列表
    if #visibleWindows == 0 then
        return
    end -- 如果没有窗口，退出

    for i, win in ipairs(visibleWindows) do
        if win:isStandard() then -- 只处理标准窗口（排除 Dock 等）
            local frame = win:frame() -- 获取窗口的框架（位置和大小）

            -- 在窗口上绘制标签（例如，数字 i）
            local label = drawing.text({
                x = frame.x + 10, -- 标签的 X 坐标，窗口左边 + 10 像素
                y = frame.y + 10, -- 标签的 Y 坐标，窗口上边 + 10 像素
                w = 50, -- 标签宽度
                h = 20 -- 标签高度
            }, tostring(i)) -- 文本内容为数字 i
            label:setTextFont("Arial-Bold")
            label:setTextSize(24) -- 字体大小
            label:setTextColor({
                red = 1,
                green = 0,
                blue = 0,
                alpha = 1
            }) -- 红色文字
            label:show() -- 显示标签
            table.insert(labels, label) -- 将标签添加到数组中

            -- 绑定快捷键：按数字 i 时激活对应窗口
            local hk = hotkey.new({}, tostring(i), function()
                win:focus() -- 聚焦到该窗口
                hs.timer.doAfter(0.1, function()
                    hs.spaces.toggleMissionControl()
                end) -- 关闭 Mission Control
            end)
            hk:enable() -- 启用快捷键
            table.insert(mcHotkeys, hk) -- 将快捷键添加到数组中
        end
    end
end

local function hideLabelsInMissionControl()
    for _, label in ipairs(labels) do
        label:delete() -- 删除标签
    end
    labels = {}

    for _, hk in pairs(mcHotkeys) do
        hk:delete() -- 删除快捷键
    end
    mcHotkeys = {}
end

-- 5. 监听 Mission Control 事件
-- local watcher = spaces.watcher.new(function(event)
--     print("Mission Control event detected:", event)
--     if event == "exposeOpen" then
--         showLabelsInMissionControl()
--     elseif event == "exposeClose" then
--         hideLabelsInMissionControl()
--     end
-- end)

-- watcher:start() -- 启动监听

--[[ 切换应用 ]]
hs.hotkey.bind(hyperKey, "x", switch_to_app("WeChat"))
hs.hotkey.bind(hyperKey, "g", switch_to_app("Google Chrome"))
hs.hotkey.bind(hyperKey, "e", switch_to_app("Cursor"))
hs.hotkey.bind(hyperKey, "n", switch_to_app("Obsidian"))
hs.hotkey.bind(hyperKey, "i", switch_to_app("Warp"))
hs.hotkey.bind(hyperKey, "c", switch_to_app("Cherry Studio"))
hs.hotkey.bind(hyperKey, "f", switch_to_app("Figma"))
hs.hotkey.bind(hyperKey, "m", switch_to_app("iPhone Mirroring"))
hs.hotkey.bind(hyperKey, "q", switch_to_app("Telegram"))
hs.hotkey.bind(hyperKey, "y", switch_to_app("DingTalk"))

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

--[[ wifi 监听 ]]
wifiWatcher = nil
homeSSID = "XiaomiSB_5G"
lastSSID = hs.wifi.currentNetwork()
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.alert.show("Joined Home WiFi")
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        hs.alert.show("Departed Home WiFi")
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- mic_ui = {
--     includeNonVisible = false, -- 不显示后台应用窗口
--     includeOtherSpaces = false, -- 不显示其它桌面窗口

--     -- 颜色格式为 RGB，最后一位是透明度A
--     highlightThumbnailStrokeWidth = 0, -- 取消橙色的边宽
--     backgroundColor = {0, 0, 0, 0.1}, -- ui 的背景颜色，这里改为透明
--     showTitles = false, -- 隐藏标题
-- }

-- -- hyper 指 Com + Con + Opt 三个修饰键
-- hs.hotkey.bind(hyper, 't', function()
--     hs.expose.new(nil, mic_ui):toggleShow()
-- end)

