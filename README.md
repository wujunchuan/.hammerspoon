# Hammerspoon Configuration

我的 Hammerspoon 配置文件，用于增强 macOS 的键盘控制和自动化功能。

## 功能特性

### 应用切换

使用 `⌘⌃⌥⇧` (Command + Control + Option + Shift) 组合键作为 Hyper Key 快速切换应用：

- `Hyper + x` - 切换到 WeChat
- `Hyper + g` - 切换到 Google Chrome
- `Hyper + e` - 切换到 Antigravity
- `Hyper + n` - 切换到 Obsidian
- `Hyper + i` - 切换到 Ghostty
- `Hyper + c` - 切换到 Codex
- `Hyper + o` - 切换到 iPhone Mirroring
- `Hyper + f` - 切换到 Finder
- `Hyper + s` - 切换到 Simulator
- `Hyper + a` - 切换到 Cherry Studio
- `Hyper + y` - 切换到 Fork
- `Super + e` - 切换到 Zed (`⌘⌥⌃ + e`)
- `Super + i` - 切换到 Warp (`⌘⌥⌃ + i`)

### 窗口操作及输入法

- `Hyper + 1` - 切换到 英文输入法
- `Hyper + 2` - 切换到 微信输入法
- `Hyper + 3` - 切换到 豆包输入法
- `Hyper + \`` - 在同一应用的多个窗口间循环切换

### 系统控制

使用 `⌘⌥⌃` (Command + Option + Control) 组合键作为 Super Key 控制系统功能：

- `Super + a` - 降低音量 5%
- `Super + s` - 提高音量 5%
- `Super + m` - 切换静音
- `Super + f` - 播放/暂停音乐 (iTunes)
- `Super + d` - 切换深色/浅色模式
- `Super + r` - 重载 Hammerspoon 配置
- `Super + \`` - 显示 Hammerspoon 控制台

### 智能场景

- **WiFi 自动音量调节**
  - 连接到家庭 WiFi (`xiaomiSB_5G`) 时自动设置音量为 60%
  - 离开家庭 WiFi 时自动静音 (音量设为 0%)
  - 支持办公室 WiFi (`GD-Office`) 场景识别和提示

- **位置服务**
  - 自动获取当前位置信息（获取 WiFi 信息前需要需要位置服务权限，这是 HammerSpoon 的缺陷）

### 视窗管理（WinWin + ModalMgr）

按下以下任意组合进入窗口管理模式：

- `Ctrl + Space`
- `Cmd + Ctrl + Space`
- `Hyper + r`

进入后，支持如下窗口操作：

**基本操作：**

- `1` - 移动到下一个屏幕
- `F / Space` - 全屏
- `C` - 居中
- `Tab` - 显示键位提示
- `Escape / Q` - 退出窗口管理模式

**窗口移动：**

- `A / D / W / S` - 向左/右/上/下移动窗口（2/3 屏）
- `↑ / ↓ / ← / →` - 精确移动窗口位置

**半屏布局：**

- `H / [` - 左半屏
- `L / ]` - 右半屏
- `K / ;` - 上半屏
- `J / '` - 下半屏

**四角布局：**

- `Y` - 屏幕左上角
- `O` - 屏幕右上角
- `U` - 屏幕左下角
- `I` - 屏幕右下角

**窗口调整：**

- `= / +` - 放大窗口
- `-` - 缩小窗口
- `B` - 撤销最后一个窗口操作
- `R` - 重做最后一个窗口操作
- `t` - 将光标移至当前窗口中心

> 详细键位请进入窗口管理模式后按 `Tab` 查看完整帮助。

### URL 事件自动化

支持通过 URL Scheme 触发 Hammerspoon 动作，例如：

```sh
open -g hammerspoon://someAlert
```

会弹出提示 `Received someAlert`。

## 安装要求

- macOS 操作系统
- [Hammerspoon](https://www.hammerspoon.org/) 应用
- HyperKey Spoon
- ModalMgr 和 WinWin Spoons

## 安装步骤

1. 安装 Hammerspoon
2. 安装必需的 Spoons：`HyperKey`, `ModalMgr`, `WinWin`
3. 将配置文件复制到 `~/.hammerspoon/init.lua`
4. 重启 Hammerspoon 或点击菜单栏中的 **Reload Config**

## 自定义配置

### 应用路径配置

在 `init.lua` 中修改 `hyperKey:bind()` 或 `superKey:bind()` 调用来自定义应用切换快捷键和应用路径。

### 音量调节幅度

修改 `changeVolume()` 函数中的数值来调整音量变化幅度（默认为 5%）。

## 注意事项

- 确保 Hammerspoon 在系统启动时自动运行。
- 某些功能可能需要额外的系统权限（辅助功能、位置服务等）。
- 建议定期备份配置文件。
- 首次运行时会显示 "Hammerspoon Config loaded" 提示。

## 许可证

MIT License
