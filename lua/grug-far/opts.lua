local M = {}

function M.with_defaults(options)
  return vim.tbl_deep_extend('force', {
    -- debounce milliseconds for issuing search while user is typing
    -- prevents excesive searching
    debounceMs = 500,

    -- minimum number of chars which will cause a search to happen
    -- prevents performance issues in larger dirs
    minSearchChars = 2,

    -- extra args that you always want to pass to rg
    -- like for example if you always want context lines around matches
    extraRgArgs = '',

    -- highlight groups for various parts of the UI
    highlights = {
      helpHeader = 'WarningMsg',

      inputLabel = 'Identifier',
      inputPlaceholder = 'Comment',

      resultsHeader = 'Comment',
      resultsStats = 'Comment',
      resultsMatch = '@diff.delta',
      resultsPath = '@string.special.path',
      resultsLineNo = 'Number',
      resultsLineColumn = 'Number',
    },

    -- icons for UI, default ones depend on nerdfont
    icons = {
      -- whether to show icons
      enabled = true,

      searchInput = ' ',
      replaceInput = ' ',
      filesFilterInput = ' ',
      flagsInput = '󰮚 ',
    }
  }, options)
end

function M.getIcon(iconName, context)
  local icons = context.options.icons
  if not icons.enabled then
    return nil
  end

  return icons[iconName]
end

return M