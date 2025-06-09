# Hammerspoon Configuration

我的 Hammerspoon 配置文件，用于增强 macOS 的键盘控制和自动化功能。

## 功能特性

### 应用切换

使用 `⌘⌃⌥⇧` (Command + Control + Option + Shift) 组合键快速切换应用：

- `⌘⌃⌥⇧ + x` - 切换到 WeChat
- `⌘⌃⌥⇧ + g` - 切换到 Google Chrome
- `⌘⌃⌥⇧ + e` - 切换到 Cursor
- `⌘⌃⌥⇧ + n` - 切换到 Obsidian
- `⌘⌃⌥⇧ + i` - 切换到 Warp
- `⌘⌃⌥⇧ + c` - 切换到 Cherry Studio
- `⌘⌃⌥⇧ + m` - 切换到 Figma
- `⌘⌃⌥⇧ + r` - 切换到 iPhone Mirroring
- `⌘⌃⌥⇧ + q` - 切换到 Telegram
- `⌘⌃⌥⇧ + y` - 切换到 DingTalk (支持同应用多窗口循环切换)

### 窗口操作

- `⌘⌃⌥⇧ + f` - 将当前窗口设置为全屏
- `⌘⌃⌥⇧ + \`` - 在同一应用的多个窗口间循环切换

### 系统控制

使用 `⌘⌥⌃` (Command + Option + Control) 组合键控制系统功能：

- `⌘⌥⌃ + a` - 降低音量 5%
- `⌘⌥⌃ + s` - 提高音量 5%
- `⌘⌥⌃ + m` - 切换静音
- `⌘⌥⌃ + f` - 播放/暂停音乐
- `⌘⌥⌃ + d` - 切换深色/浅色模式
- `⌘⌥⌃ + r` - 重载 Hammerspoon 配置
- `⌘⌥⌃ + \`` - 显示 Hammerspoon 控制台

### 智能场景

- **WiFi 自动音量调节**
  - 连接到家庭 WiFi (`xiaomiSB_5G`) 时自动设置音量为 60%
  - 离开家庭 WiFi 时自动静音 (音量设为 0%)
  - 支持办公室 WiFi (`GD-Office`) 场景识别和提示

- **位置服务**
  - 自动获取当前位置信息（获取 WiFi 信息前需要需要位置服务权限，这是 HammerSpoon 的缺陷）

### URL 事件自动化

支持通过 URL Scheme 触发 Hammerspoon 动作，例如：

```sh
open -g hammerspoon://someAlert
```

会弹出提示 `Received someAlert`。

### 视窗管理（WinWin + ModalMgr）

按下以下任意组合进入窗口管理模式：

- `Ctrl + Space`
- `Cmd + Ctrl + Space`
- `⌘⌃⌥⇧ + r` (在窗口管理模式中)

进入后，支持如下窗口操作：

**基本操作：**

- `1` - 移动到下一个屏幕
- `F/Space` - 全屏
- `C` - 居中
- `Tab` - 显示键位提示
- `Escape/Q` - 退出窗口管理模式

**窗口移动：**

- `A/D/W/S` - 向左/右/上/下移动窗口（2/3 屏）
- `↑/↓/←/→` - 精确移动窗口位置

**半屏布局：**

- `H/[` - 左半屏
- `L/]` - 右半屏
- `K/;` - 上半屏
- `J/'` - 下半屏

**四角布局：**

- `Y` - 屏幕左上角
- `O` - 屏幕右上角
- `U` - 屏幕左下角
- `I` - 屏幕右下角

**窗口调整：**

- `=/+` - 放大窗口
- `-` - 缩小窗口
- `B` - 撤销最后一个窗口操作
- `R` - 重做最后一个窗口操作
- `t` - 将光标移至当前窗口中心

> 详细键位请进入窗口管理模式后按 `Tab` 查看完整帮助。

## 安装要求

- macOS 操作系统
- [Hammerspoon](https://www.hammerspoon.org/) 应用
- HyperKey Spoon（用于超级键功能）
- ModalMgr 和 WinWin Spoons（用于窗口管理）
- 位置服务权限（用于场景识别）
- WiFi 权限（用于网络场景识别）

## 安装步骤

1. 安装 Hammerspoon
2. 安装必需的 Spoons：
   - HyperKey
   - ModalMgr
   - WinWin
3. 将配置文件复制到 `~/.hammerspoon/init.lua`
4. 重启 Hammerspoon
5. 确保授予必要的系统权限

## 自定义配置

### WiFi 场景配置

在配置文件中修改以下变量来自定义 WiFi 场景：

```lua
homeSSID = "xiaomiSB_5G"  -- 你的家庭WiFi名称
officeSSID = "GD-Office"  -- 你的办公室WiFi名称
```

### 应用路径配置

在配置文件中修改 `hyperKey:bind()` 调用来自定义应用切换快捷键和应用路径。

### 音量调节幅度

修改 `changeVolume()` 函数中的数值来调整音量变化幅度（默认为 5%）。

## 注意事项

- 确保 Hammerspoon 在系统启动时自动运行
- 某些功能可能需要额外的系统权限（辅助功能、位置服务等）
- 建议定期备份配置文件
- 首次运行时会显示 "Hammerspoon Config loaded" 提示
- 部分应用需要确保路径正确，否则可能无法正常启动

## 许可证

MIT License
