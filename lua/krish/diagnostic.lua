local last_echo = { false, -1, -1 }

-- The timer used for displaying a diagnostic in the command line.
local echo_timer = nil

-- The timer after which to display a diagnostic in the command line.
local echo_timeout = 250

-- The highlight group to use for warning messages.
local warning_hlgroup = 'WarningMsg'

-- The highlight group to use for error messages.
local error_hlgroup = 'ErrorMsg'

-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

-- Shows the current line's diagnostics in a floating window.
local function show_line_diagnostics()
  vim.diagnostic.open_float(nil, {
    scope = 'line',
    severity = { min = vim.diagnostic.severity.WARN }
  })
end

-- Prints the first diagnostic for the current line.
local function echo_diagnostic()
  if echo_timer then
    echo_timer:stop()
    echo_timer = nil
  end

  echo_timer = vim.defer_fn(function()
    local line = vim.fn.line('.') - 1
    local bufnr = vim.api.nvim_get_current_buf()

    if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
      return
    end

    local diags = vim.diagnostic.get(bufnr, {
      lnum = line,
      severity = { min = vim.diagnostic.severity.WARN },
    })

    if #diags == 0 then
      -- Clear the echo area if a diagnostic was previously displayed.
      if last_echo[1] then
        last_echo = { false, -1, -1 }
        vim.api.nvim_echo({ { '' } }, false, {})
      end
      return
    end

    last_echo = { true, bufnr, line }

    local diag = diags[1]
    local width = vim.o.columns - 15
    local lines = vim.split(diag.message, '\n', {})
    local message = lines[1]

    if #lines > 1 and #message + #lines[2] <= 80 then
      message = message .. ' ' .. lines[2]
    end

    if width > 0 and #message >= width then
      message = message:sub(1, width) .. '...'
    end

    local kind = 'warning'
    local hlgroup = warning_hlgroup

    if diag.severity == vim.diagnostic.severity.ERROR then
      kind = 'error'
      hlgroup = error_hlgroup
    end

    local chunks = {
      { kind .. ': ', hlgroup },
      { message }
    }

    vim.api.nvim_echo(chunks, false, {})
  end, echo_timeout)
end

return {
  show_line_diagnostics = show_line_diagnostics,
  echo_diagnostic = echo_diagnostic,
}

