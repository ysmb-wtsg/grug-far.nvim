local utils = require('grug-far.utils')
local gotoLocation = require('grug-far.actions.gotoLocation')

--- opens location at current cursor line in a new tab
---@param params { buf: integer, context: GrugFarContext, count: number?, increment: integer? }
local function openNewTab(params)
  local buf = params.buf
  local context = params.context
  local grugfar_win = vim.fn.bufwinid(buf)

  local cursor_row = unpack(vim.api.nvim_win_get_cursor(grugfar_win))
  local location, row = require('grug-far.actions.gotoLocation').getLocation(
    buf,
    context,
    cursor_row,
    params.count or 0
  )
  if not location then
    return
  end
  if row and row ~= cursor_row then
    vim.api.nvim_win_set_cursor(grugfar_win, { row, 0 })
  end

  vim.api.nvim_command([[execute "normal! m` "]])

  ---@diagnostic disable-next-line
  local bufnr = vim.fn.bufnr(location.filename)

  -- Open the file in a new tab
  if bufnr == -1 then
    vim.cmd('tabnew ' .. utils.escape_path_for_cmd(location.filename))
  else
    vim.cmd('tabnew')
    vim.api.nvim_win_set_buf(0, bufnr)
  end

  vim.api.nvim_win_set_cursor(
    0, -- 新しいタブの現在のウィンドウを指すため、0を使用
    { location.lnum or 1, location.col and location.col - 1 or 0 }
  )

  vim.api.nvim_set_current_win(0)
end

--- Expose getLocation for reuse
local gotoLocationModule = require('grug-far.actions.gotoLocation')
gotoLocationModule.getLocation = gotoLocation.getLocation

return openNewTab
