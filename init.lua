local drawing = hs.drawing -- 用于在屏幕上绘制文本
local window = hs.window -- 用于处理窗口
local hotkey = hs.hotkey -- 用于绑定键盘快捷键
local spaces = hs.spaces -- 用于检测 Mission Control
local application = hs.application -- 用于处理应用程序

--[[ init HyperKey ]]
local HyperKey = hs.loadSpoon("HyperKey")
local hyper = {'cmd', 'ctrl', 'alt', 'shift'}
local super = {'cmd', 'alt', 'ctrl'}

local hyperKeyConfig = {
    overlayTimeoutMs = 2000
}
hyperKey = HyperKey:new(hyper, hyperKeyConfig)
superKey = HyperKey:new(super, hyperKeyConfig)

--[[ 切换应用,相同的应用会切换到下一个窗口 ]]
--[[ 切换应用 ]]
local function switch_to_app(appName, bundleID)
    return function()
        -- Get focused window and app
        local focusedWindow = window.focusedWindow()
        local focusedApp = focusedWindow and focusedWindow:application()

        -- If already focused on target app, cycle between its windows
        if focusedApp and (focusedApp:name() == appName or focusedApp:bundleID() == bundleID) then
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

        application.launchOrFocus(appName)
    end
end

-- 需要用到 loop 窗口的特性
-- hs.hotkey.bind(hyper, "y", switch_to_app("DingTalk", "com.alibaba.DingTalkMac"))
-- hs.hotkey.bind(hyper, "f", function()
--     local sf = hs.screen.primaryScreen():frame()
--     hs.window.focusedWindow():setFrame(hs.geometry.new(sf.x, sf.y, sf.w, sf.h))
-- end)

--[[ 切换应用 ]]
hyperKey:bind('x'):toApplication('/Applications/WeChat.app')
hyperKey:bind('g'):toApplication('/Applications/Google Chrome.app')
-- hyperKey:bind('e'):toApplication('/Applications/Visual Studio Code.app')
hyperKey:bind('e'):toApplication('/System/Volumes/Data/Applications/Antigravity.app')
-- hyperKey:bind('s'):toApplication('/Applications/Cursor.app')
hyperKey:bind('n'):toApplication('/Applications/Obsidian.app')
-- hyperKey:bind('i'):toApplication('/Applications/Warp.app')
hyperKey:bind('i'):toApplication('/System/Volumes/Data/Applications/Ghostty.app')
hyperKey:bind('c'):toApplication('/Applications/Cherry Studio.app')
hyperKey:bind('o'):toApplication('/System/Applications/iPhone Mirroring.app')
hyperKey:bind('t'):toApplication('/Applications/Telegram.app') 
hyperKey:bind('f'):toApplication('/System/Library/CoreServices/Finder.app')
-- hyperKey:bind('y'):toApplication('/System/Volumes/Data/Applications/LarkSuite.app')
hyperKey:bind('m'):toApplication('/System/Volumes/Data/Applications/Figma.app')
-- hyperKey:bind('a'):toApplication('/System/Volumes/Data/Applications/ChatGPT Atlas.app')

hyperKey:bind('y'):toApplication('/System/Volumes/Data/Applications/Fork.app');

--[[ 
    在相同应用中切换焦点,
    与 `right_command + `` 不同的是，前者会在所有应用中切换焦点，而后者只会在当前应用与前一个应用中切换焦点
 ]]
hyperKey:bind('`'):toFunction('在相同应用中切换焦点', function()
    local focusedWindow = window.focusedWindow()
    local currentApp = focusedWindow:application()
    local allWindows = currentApp:allWindows()

    -- Filter out minimized/hidden windows
    local visibleWindows = {}
    for _, win in ipairs(allWindows) do
        if win:isVisible() and not win:isMinimized() then
            table.insert(visibleWindows, win)
        end
    end

    if #visibleWindows > 1 then
        -- Find current window index
        local currentIndex = 1
        for i, win in ipairs(visibleWindows) do
            if win:id() == focusedWindow:id() then
                currentIndex = i
                break
            end
        end

        -- Focus next window (wrap around to first if at end)
        local nextIndex = (currentIndex >= #visibleWindows) and 1 or (currentIndex + 1)
        visibleWindows[nextIndex]:focus()
    end
end)

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

-- superKey:bind('a'):toFunction('音量减小', changeVolume(-5))
-- superKey:bind('s'):toFunction('音量增大', changeVolume(5))

--[[ 切换静音/非静音 ]]
superKey:bind('m'):toFunction('切换静音/非静音', function()
    hs.audiodevice.defaultOutputDevice():setMuted(not hs.audiodevice.defaultOutputDevice():muted())
end)

--[[ 播放/暂停音乐 ]]
superKey:bind('f'):toFunction('播放/暂停音乐', function()
    hs.itunes.playpause()
end)

--[[ Hammer 开发调试，用 superKey 绑定 ]]
--[[ 重载配置Key ]]
superKey:bind('r'):toFunction('重载配置', function()
    hs.reload()
end)

hs.alert.show("Hammerspoon Config loaded")

--[[ Show HammerspoonKey Console ]]
superKey:bind('`'):toFunction('显示 Hammerspoon 控制台', function()
    hs.toggleConsole()
end)

--[[ 切换深色/浅色模式 ]]
superKey:bind('d'):toFunction('切换深色/浅色模式', function()
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

--[[ demo: 使用 URL 自动化 Hammerspoon ]]
--[[ 使用方式： `open -g hammerspoon://someAlert` ]]
hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)



--[[ 视窗管理 ]]
hs.loadSpoon("ModalMgr")
hs.loadSpoon("WinWin")


if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', '退出 ', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', '退出', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', '键位提示', function() spoon.ModalMgr:toggleCheatsheet() end)

    cmodal:bind('', '1', '移动到另外一个屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("next") end)

    --[[ 2/3 屏 ]]
    cmodal:bind('', 'A', '向左移动', function() spoon.WinWin:moveAndResize("twothirdsleft") end)
    cmodal:bind('', 'D', '向右移动', function() spoon.WinWin:moveAndResize("twothirdsright") end)
    cmodal:bind('', 'W', '向上移动', function() spoon.WinWin:moveAndResize("twothirdsup") end)
    cmodal:bind('', 'S', '向下移动', function() spoon.WinWin:moveAndResize("twothirdsdown") end)

    --[[ 移动 ]]
    cmodal:bind('', 'left', '向左移动', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
    cmodal:bind('', 'right', '向右移动', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
    cmodal:bind('', 'up', '向上移动', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
    cmodal:bind('', 'down', '向下移动', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)

    --[[ 半屏 ]]
    cmodal:bind('', 'H', '左半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end)
    cmodal:bind('', '[', '左半屏-2', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end)

    cmodal:bind('', 'L', '右半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end)
    cmodal:bind('', ']', '右半屏-2', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end)

    cmodal:bind('', 'K', '上半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfup") end)
    cmodal:bind('', ';', '上半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfup") end)

    cmodal:bind('', 'J', '下半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfdown") end)
    cmodal:bind('', '\'', '下半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfdown") end)

    cmodal:bind('', 'Y', '屏幕左上角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNW") end)
    cmodal:bind('', 'O', '屏幕右上角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNE") end)
    cmodal:bind('', 'U', '屏幕左下角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSW") end)
    cmodal:bind('', 'I', '屏幕右下角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSE") end)

    cmodal:bind('', 'F', '全屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'space', '全屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', '居中', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("center") end)

    cmodal:bind('', '=', '窗口放大', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind('', '-', '窗口缩小', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)

    cmodal:bind('', 'B', '撤销最后一个窗口操作', function() spoon.WinWin:undo() end)
    cmodal:bind('', 'R', '重做最后一个窗口操作', function() spoon.WinWin:redo() end)

    cmodal:bind('', 't', '将光标移至所在窗口中心位置', function() spoon.WinWin:centerCursor() end)

    local function enterResizeM()
        spoon.ModalMgr:deactivateAll()
        spoon.ModalMgr:activate({"resizeM"}, "#B22222", false)
    end

    spoon.ModalMgr.supervisor:bind('ctrl', "space", "进入窗口管理模式", enterResizeM)
    spoon.ModalMgr.supervisor:bind(hyper, "r", "进入窗口管理模式", enterResizeM)
    spoon.ModalMgr.supervisor:bind({"cmd", "ctrl"}, "space", "进入窗口管理模式", enterResizeM)
end



spoon.ModalMgr.supervisor:enter()
