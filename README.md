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
- `⌘⌃⌥⇧ + f` - 切换到 Figma
- `⌘⌃⌥⇧ + m` - 切换到 iPhone Mirroring
- `⌘⌃⌥⇧ + q` - 切换到 Telegram
- `⌘⌃⌥⇧ + y` - 切换到 DingTalk

### 系统控制

使用 `⌘⌥⌃` (Command + Option + Control) 组合键控制系统功能：

- `⌘⌥⌃ + a` - 降低音量 5%
- `⌘⌥⌃ + s` - 提高音量 5%
- `⌘⌥⌃ + m` - 切换静音
- `⌘⌥⌃ + f` - 播放/暂停音乐
- `⌘⌥⌃ + d` - 切换深色/浅色模式
- `⌘⌥⌃ + r` - 重载 Hammerspoon 配置
- `⌘⌥⌃ + `` - 显示 Hammerspoon 控制台

### 智能场景

- 自动根据 WiFi 网络调整系统音量
  - 连接到家庭 WiFi 时自动设置音量为 25%
  - 离开家庭 WiFi 时自动静音
  - 支持办公室 WiFi 场景识别

### 窗口管理

- 支持在 Mission Control 中显示窗口标签
- 支持通过数字键快速切换窗口

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
- `⌘⌃⌥⇧ + r`

进入后，支持如下窗口操作（部分常用键位）：

- `1`  移动到下一个屏幕
- `A/D/W/S`  向左/右/上/下移动窗口（2/3 屏）
- `H/L/K/J`  左/右/上/下半屏
- `Y/O/U/I`  屏幕四角
- `F/Space`  全屏
- `C`  居中
- `=/ -`  放大/缩小窗口
- `B`  撤销窗口操作
- `R`  重做窗口操作
- `t`  将光标移至当前窗口中心
- `Tab`  显示键位提示
- `Escape/Q`  退出窗口管理模式

> 详细键位请进入窗口管理模式后按 `Tab` 查看。

### 其它功能

- 支持在同一应用内循环切换窗口（`⌘⌃⌥⇧ + \\``）
- 支持将当前窗口最大化（`⌘⌃⌥⇧ + f`）
- 自动显示配置加载提示

## 安装要求

- macOS 操作系统
- [Hammerspoon](https://www.hammerspoon.org/) 应用
- 位置服务权限（用于场景识别）
- WiFi 权限（用于网络场景识别）

## 安装步骤

1. 安装 Hammerspoon
2. 将配置文件复制到 `~/.hammerspoon/init.lua`
3. 重启 Hammerspoon
4. 确保授予必要的系统权限

## 自定义配置

### WiFi 场景配置

在配置文件中修改以下变量来自定义 WiFi 场景：

```lua
homeSSID = "你的家庭WiFi名称"
officeSSID = "你的办公室WiFi名称"
```

### 应用切换配置

在配置文件中修改 `switch_to_app` 函数调用来自定义应用切换快捷键。

## 注意事项

- 确保 Hammerspoon 在系统启动时自动运行
- 某些功能可能需要额外的系统权限
- 建议定期备份配置文件

## 许可证

MIT License
