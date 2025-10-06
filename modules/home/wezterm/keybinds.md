# Wezterm Multiplexer Keybindings

## General Keybindings

| Key                    | Modifiers      | Action                          |
| ---------------------- | -------------- | ------------------------------- |
| `a`                    | LEADER + CTRL  | Send Ctrl-A (double-tap Ctrl-A) |
| `c`                    | LEADER         | Activate Copy Mode              |
| `p`                    | LEADER         | Activate Command Palette        |
| `l`                    | LEADER         | Activate Last Tab               |
| `l`                    | LEADER + SHIFT | Show Launcher                   |
| `UpArrow`, `DownArrow` | SHIFT          | Scroll to Prompt (-1/1)         |

## Tab Management

| Key | Modifiers      | Action                                |
| --- | -------------- | ------------------------------------- |
| `n` | LEADER         | Spawn New Tab in Current Pane Domain  |
| `[` | LEADER         | Activate Previous Tab                 |
| `]` | LEADER         | Activate Next Tab                     |
| `t` | LEADER + SHIFT | Show Tab Navigator                    |
| `&` | LEADER + SHIFT | Close Current Tab (with confirmation) |
| `!` | LEADER + SHIFT | Move Current Pane to New Tab          |

## Pane Management & Splits

| Key                | Modifiers      | Action                                             |
| ------------------ | -------------- | -------------------------------------------------- |
| `s`                | LEADER         | Pane Select Mode                                   |
| `%`, `\|`          | LEADER + SHIFT | Split Horizontally                                 |
| `"`, `_`           | LEADER + SHIFT | Split Vertically                                   |
| `t`                | LEADER         | Split Pane Down (20% size)                         |
| `z`                | LEADER         | Toggle Pane Zoom State                             |
| `h`, `j`, `k`, `l` | CTRL + SHIFT   | Activate Pane in Direction (Left, Down, Up, Right) |

## Key Tables (Manage Panes)

| Key               | Modifiers | Action                                 |
| ----------------- | --------- | -------------------------------------- |
| `LeftArrow`, `h`  | None      | Resize Pane Left (1)                   |
| `RightArrow`, `l` | None      | Resize Pane Right (1)                  |
| `UpArrow`, `k`    | None      | Resize Pane Up (1)                     |
| `DownArrow`, `j`  | None      | Resize Pane Down (1)                   |
| `LeftArrow`, `h`  | SHIFT     | Resize Pane Left (5)                   |
| `RightArrow`, `l` | SHIFT     | Resize Pane Right (5)                  |
| `UpArrow`, `k`    | SHIFT     | Resize Pane Up (5)                     |
| `DownArrow`, `j`  | SHIFT     | Resize Pane Down (5)                   |
| `r`               | None      | Rotate Panes Clockwise                 |
| `r`               | SHIFT     | Rotate Panes CounterClockwise          |
| `LeftArrow`, `h`  | CTRL      | Switch to Pane (Left)                  |
| `RightArrow`, `l` | CTRL      | Switch to Pane (Right)                 |
| `UpArrow`, `k`    | CTRL      | Switch to Pane (Up)                    |
| `DownArrow`, `j`  | CTRL      | Switch to Pane (Down)                  |
| `%`, `\|`         | SHIFT     | Split Pane Horizontally                |
| `"`, `_`          | SHIFT     | Split Pane Vertically                  |
| `x`               | None      | Close Current Pane (with confirmation) |
| `x`               | SHIFT     | Close Current Pane (no confirmation)   |

## Key Tables (Copy Mode)

| Key      | Modifiers | Action         |
| -------- | --------- | -------------- |
| `i`, `a` | None      | Exit Copy Mode |

## Number Keys (Tabs & Panes)

| Key   | Modifiers     | Action                       |
| ----- | ------------- | ---------------------------- |
| `1-9` | LEADER        | Activate Tab (1-9)           |
| `1-9` | LEADER + CTRL | Activate Pane by Index (1-9) |
