local M = {}

M.input_state = "en"
M.timer = vim.loop.new_timer()
M.closed = false

M.opts = {
  default_command = "im-switch.exe",
  default_guicursor = nil,
  color = {
    caps = "yellow",
    zh = "red",
  },
}

function M.change_im_select(method)
  local handle
  handle, _ = vim.loop.spawn(
    M.opts.default_command,
    { args = { method }, detached = true },
    vim.schedule_wrap(function(code, signal)
      if handle and not handle:is_closing() then
        handle:close()
      end
      M.closed = true
    end)
  )

  if not handle then
    vim.api.nvim_err_writeln([[[im-select]: Failed to spawn process for ]] .. M.opts.default_command)
  end
end

function M.switch_to_zh()
  return M.change_im_select("zh")
end

function M.switch_to_en()
  return M.change_im_select("en")
end

local function update_cursor_color()
  local handle = io.popen("im-switch.exe", "r")
  local result = nil

  if handle ~= nil then
    result = handle:read("*a")
    handle:close()
  end

  if M.input_state == result then
    return
  end

  local guicursor = "n-v-c:block-Cursor,"

  if result == "caps" then
    guicursor = guicursor .. "i-ci-ve:ver25-CursorCaps/lCursorCaps"
    local color = M.opts.color.caps
    vim.api.nvim_set_hl(0, "CursorCaps", { fg = color, bg = color })
  elseif result == "zh" then
    local color = M.opts.color.zh
    guicursor = guicursor .. "i-ci-ve:ver25-CursorZh/lCursorZh"
    vim.api.nvim_set_hl(0, "CursorZh", { fg = color, bg = color })
  else
    guicursor = M.opts.default_guicursor
  end

  vim.opt.guicursor = guicursor
  M.input_state = result
end

function M.start_hilight()
  M.timer:stop()

  if M.opts.default_guicursor == nil then
    M.opts.default_guicursor = vim.opt.guicursor._value
  end
  M.timer:start(0, 500, vim.schedule_wrap(update_cursor_color))
end

function M.stop_hilight()
  M.timer:stop()
  if M.input_state ~= "en" then
    M.switch_to_en()
  end
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = M.start_hilight,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      M.stop_hilight()
    end,
  })
end

M.config = {}

return M
