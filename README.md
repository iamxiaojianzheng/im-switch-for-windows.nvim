# im-switch-for-windows.nvim

By differentiating the distinct cursor colors in the Chinese, English, and caps lock states, we can gain a better understanding of the current status of the input method and make informed decisions regarding the next operation.

https://github.com/user-attachments/assets/8bf1949b-e2f2-466e-8f03-34d97f5ec3ae

## Install and check binary

`im-switch-for-windows.nvim` use binary tools to switch IM, you need to:

1. Install binary tools on different OS.
2. Make sure the executable file in a path that Neovim can read them.

### 1.1 Windows

#### Install

Please install `im-switch.exe` and put it into your `PATH`.

Download URL: [im-switch](https://github.com/iamxiaojianzheng/im-switch-for-windows.nvim/releases)

#### Check

You can check if the `im-switch` executable can be properly accessed from Neovim by running the following command from your Command Prompt:

```bash
# find the command
$ where im-switch.exe

# Get current im name
$ im-switch.exe

# Try to switch to English keyboard
$ im-switch.exe en

# Try to switch to Chinese keyboard
$ im-switch.exe zh
```

Or run shell command directly from Neovim

```bash
:!where im-switch.exe

:!im-switch.exe zh
```

## Install and setup this plugin

A good-enough minimal config in Lazy.nvim

```lua
{
    "iamxiaojianzheng/im-switch-for-windows.nvim",
    config = function()
        require("im_select").setup({})
    end,
}
```

Options with its default values

```lua
{
    "iamxiaojianzheng/im-switch-for-windows.nvim",
    opts = {
      color = {
        -- The color the cursor displays when caps mode is enabled.
        caps = "yellow",
        -- The color of the cursor when Chinese mode is enabled.
        zh = "red",
      },
    },
    config = function(_, opts)
        require("im_select").setup(opts)
    end,
}
```

## Limitations

- Required Lua, so only work in Neovim
- Required guicursor support
