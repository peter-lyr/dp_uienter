-- Copyright (c) 2024 liudepei. All Rights Reserved.
-- create at 2024/04/22 22:56:03 星期一

EndTime           = vim.fn.reltimefloat(vim.fn.reltime(StartTime))

DataSub           = vim.fn.stdpath 'data' .. '\\DataSub\\'

DataSubStartupTxt = DataSub .. 'startup.txt'
RestartFlagTxt    = DataSub .. 'restart-flag.txt'
RestartReadyTxt   = DataSub .. 'restart-ready.txt'

vim.fn['GuiWindowFrameless'](1)

vim.fn.timer_start(1000, function()
  vim.fn.writefile({ string.format('[startup time] [%s] %.2f ms', vim.fn.strftime '%Y-%m-%d %H:%M:%S', EndTime * 1000), }, DataSubStartupTxt, 'a')
  vim.cmd 'GuiWindowOpacity 0.9'
  vim.fn['GuiWindowMaximized'](0)
  vim.fn['GuiWindowMaximized'](1)
  vim.fn['GuiWindowMaximized'](0)
end)

vim.fn.timer_start(1800, function()
  vim.cmd('echo "' .. string.format('[startup time] %.2f ms', EndTime * 1000) .. '"')
end)

-- see dp_test.lua:
vim.fn.timer_start(30, function()
  local content = {}
  local _sta, temp = pcall(vim.fn.readfile, RestartFlagTxt)
  if not _sta then
    pcall(vim.fn.writefile, {}, RestartFlagTxt)
  else
    content = vim.tbl_filter(function(line) return #line > 0 end, temp)
  end
  if content[1] == '1' then
    pcall(vim.cmd, 'Lazy load sessions.nvim')
    pcall(vim.cmd, 'SessionsLoad')
  elseif content[1] == '2' then
    if content[2] and vim.fn.filereadable(content[2]) == 1 then
      vim.cmd('e ' .. content[2])
    end
  end
  pcall(vim.fn.writefile, {}, RestartFlagTxt)
end)
