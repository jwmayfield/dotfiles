-- Highlight, edit, and navigate code.
-- nvim-treesitter main builds every parser with tree-sitter CLI >= 0.26.1
-- (Homebrew: tree-sitter-cli). After switching from master, this config rebuilds
-- Lua at the next startup and other parsers on first use into
-- stdpath('data')/site/parser. Old parsers under lazy/nvim-treesitter/parser
-- are shadowed by those builds and can be deleted.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter')
    treesitter.install { 'lua' }
    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    local function attach(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf)
        or vim.treesitter.language.get_lang(vim.bo[buf].filetype) ~= lang then
        return
      end
      if not vim.treesitter.language.add(lang) then
        return
      end
      vim.treesitter.start(buf, lang)
      if vim.treesitter.query.get(lang, 'indents') then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local function map(mode, key, callback, desc)
        vim.keymap.set(mode, key, callback, { buffer = buf, silent = true, desc = desc })
      end
      for key, capture in pairs {
        aa = '@parameter.outer', ia = '@parameter.inner',
        af = '@function.outer', ['if'] = '@function.inner',
        ac = '@class.outer', ic = '@class.inner',
      } do
        map({ 'x', 'o' }, key, function()
          require('nvim-treesitter-textobjects.select').select_textobject(capture, 'textobjects')
        end, 'Select textobject ' .. capture)
      end
      for method, keys in pairs {
        goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
        goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
        goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
        goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
      } do
        for key, capture in pairs(keys) do
          map({ 'n', 'x', 'o' }, key, function()
            require('nvim-treesitter-textobjects.move')[method](capture, 'textobjects')
          end, method:gsub('_', ' '):gsub('^%l', string.upper) .. ' ' .. capture)
        end
      end
      map('n', '<leader>a', function()
        require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
      end, 'Swap next @parameter.inner')
      map('n', '<leader>A', function()
        require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
      end, 'Swap previous @parameter.inner')

      -- Keep selection history so shrinking also undoes a whole scope expansion.
      local selections = {}
      local function selection()
        return { anchor = vim.fn.getpos('v'), cursor = vim.fn.getpos('.') }
      end
      local function selection_range()
        local regions = vim.fn.getregionpos(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = 'v' })
        local first, last = regions[1][1], regions[#regions][2]
        local row, col = last[2] - 1, last[3]
        if col > #vim.fn.getline(last[2]) then row, col = row + 1, 0 end
        return { first[2] - 1, first[3] - 1, row, col }
      end
      local function expand(scope)
        local before = selection()
        if scope then
          local range = selection_range()
          local parser = vim.treesitter.get_parser(buf)
          parser:parse()
          local tree = parser:language_for_range(range)
          local query = vim.treesitter.query.get(tree:lang(), 'locals')
          if not query then return end
          local node = tree:named_node_for_range(range)
          if not node then return end
          local scopes = {}
          for id, captured in query:iter_captures(node:tree():root(), buf) do
            if query.captures[id] == 'local.scope' then scopes[captured:id()] = true end
          end
          if vim.deep_equal({ node:range() }, range) then node = node:parent() end
          while node and not scopes[node:id()] do node = node:parent() end
          if not node then return end
          local srow, scol, erow, ecol = node:range()
          if ecol == 0 then
            erow = erow - 1
            ecol = #vim.fn.getline(erow + 1) + 1
          end
          local anchor, cursor = { 0, srow + 1, scol + 1, 0 }, { 0, erow + 1, ecol, 0 }
          if before.anchor[2] > before.cursor[2]
            or (before.anchor[2] == before.cursor[2] and before.anchor[3] > before.cursor[3]) then
            anchor, cursor = cursor, anchor
          end
          if vim.fn.mode() ~= 'v' then vim.cmd('normal! v') end
          vim.fn.setpos('.', anchor)
          vim.cmd('normal! o')
          vim.fn.setpos('.', cursor)
        else
          vim.treesitter.select('parent')
        end
        if not vim.deep_equal(before, selection()) then
          selections[#selections + 1] = before
        end
      end
      map('n', '<c-space>', function()
        selections = {}
        vim.treesitter.select('child')
      end, 'Start selecting nodes with treesitter')
      map('x', '<c-space>', function() expand(false) end, 'Increment selection to named node')
      map('x', '<c-s>', function() expand(true) end, 'Increment selection to surrounding scope')
      map('x', '<M-space>', function()
        local previous = table.remove(selections)
        if previous then
          vim.fn.setpos('.', previous.anchor)
          vim.cmd('normal! o')
          vim.fn.setpos('.', previous.cursor)
        end
      end, 'Shrink selection to previous named node')
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match)
        if not lang then return end
        if vim.list_contains(treesitter.get_installed(), lang) then
          attach(event.buf, lang)
        elseif vim.list_contains(treesitter.get_available(), lang) then
          treesitter.install({ lang }):await(vim.schedule_wrap(function(err)
            if not err then attach(event.buf, lang) end
          end))
        elseif vim.treesitter.language.add(lang) then
          attach(event.buf, lang)
        end
      end,
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
}
