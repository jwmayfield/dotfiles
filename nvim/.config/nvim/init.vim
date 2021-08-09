if !exists('g:vscode')
  let g:ale_disable_lsp = 1
  let g:loaded_python_provider = 0
  let g:node_host_prog=expand("~/.bin/neovim-node-host")
  let g:python3_host_prog=expand("~/.bin/python")
  let g:ruby_host_prog=expand("~/.bin/neovim-ruby-host")

  call plug#begin('~/.vim/plugged')
    " preferred color scheme
    Plug 'arcticicestudio/nord-vim'

    " completions
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " finding
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " indentation
    Plug 'tpope/vim-sleuth'

    " non-lsp linting and fixing
    Plug 'dense-analysis/ale'

    " project configuration
    Plug 'tpope/vim-projectionist'

    " syntax
    Plug 'sheerun/vim-polyglot'

    " vcs integrations
    Plug 'mhinz/vim-signify'

    " plugins to review
    Plug 'editorconfig/editorconfig-vim'
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-rails'
    Plug 'tpope/vim-sensible'
    Plug 'vim-airline/vim-airline'
  call plug#end()

  let g:coc_global_extensions = [
  \  'coc-json',
  \  'coc-phpls',
  \  'coc-prettier',
  \  'coc-snippets',
  \  'coc-spell-checker',
  \  'coc-tabnine',
  \  'coc-tsserver',
  \  ]

  syntax on
  filetype plugin indent on

  set termguicolors
  set background=dark
  let g:nord_italic=1
  let g:nord_underline=1
  colorscheme nord

  let mapleader=','

  set backspace=indent,eol,start
  set cmdheight=2
  set cursorline
  set ignorecase      " ignore case when searching
  set modeline        " last lines in document sets vim mode
  set modelines=3     " number lines checked for modelines
  set noerrorbells
  set notitle         " don't show 'Thanks for flying vim'
  set nowrap          " stop lines from wrapping
  set number
  set numberwidth=4   " line numbering takes up 5 spaces
  set shortmess=atI   " Abbreviate messages
  set ttyfast         " smoother changes
  set visualbell

  " set cursorline to center vertically
  set so=9999

  " Clear search by hitting space
  " nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
  " Clear search by hitting enter
  :nnoremap <CR> :nohlsearch<cr>

  " show extraneous spaces and where tabs are
  set list listchars=tab:>.,trail:·,eol:¬ " mark trailing white space

  " Quickly edit/reload the vimrc file
  nmap <silent> <leader>ev :e $MYVIMRC<CR>
  nmap <silent> <leader>sv :so $MYVIMRC<CR>

  " more informative status line
  if has('statusline') && !&cp
    let g:airline_powerline_fonts = 1
    set laststatus=2  " always show the status bar
    set noshowmode    " airline / lightline handles this
  endif

  " ALE for linting and fixing
  let g:airline#extensions#ale#enabled = 1

  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_enabled = 1
  " Linters default to all supported tools that are installed, but fixers must be
  " explicitly listed
  let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  \   'php': ['phpcbf'],
  \}
  let g:ale_fix_on_save = 1

  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)

  " settings :: Nvim-R plugin

  " R output is highlighted with current colorscheme
  let g:rout_follow_colorscheme = 1

  " R commands in R output are highlighted
  let g:Rout_more_colors = 1

  " vcs plugins configuration
  set updatetime=100

  augroup configure_projects
    autocmd!
    autocmd User ProjectionistActivate call s:linters()
  augroup END

  function! s:linters() abort
    let l:linters = projectionist#query('linters')
    if len(l:linters) > 0
      let b:ale_linters = {&filetype: l:linters[0][1]}
    endif

    let l:phpcs = projectionist#query('phpcs')
    if len(l:phpcs) > 0
      let g:ale_php_phpcbf_standard = l:phpcs[0][1]['standard']
      let g:ale_php_phpcs_standard = l:phpcs[0][1]['standard']
      let g:ale_php_phpcs_options = l:phpcs[0][1]['options']
    endif
  endfunction

  " map fzf to ctrl-p for muscle memory
  nmap <C-P> :FZF<CR>

  " navigate CoC completions using tab,
  " without auto-selecting the first one,
  " and jump through snippets
  " (combo of docs from coc and coc-snippets)
  inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" :
	  \ coc#expandableOrJumpable() ?
	  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	  \ <SID>check_back_space() ? "\<TAB>" :
	  \ coc#refresh()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'

  " confirm completion / snippet with <cr>,
  " bypassing conflict with vim-endwise
  " https://github.com/tpope/vim-endwise/issues/125#issuecomment-743921576
  inoremap <silent> <CR> <C-r>=<SID>coc_confirm()<CR>
  function! s:coc_confirm() abort
    if pumvisible()
      return coc#_select_confirm()
    else
      return "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    endif
  endfunction
endif
