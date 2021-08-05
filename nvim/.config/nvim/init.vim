if !exists('g:vscode')
  let g:ale_disable_lsp = 1
  let g:loaded_python_provider = 0
  let g:node_host_prog=expand("~/.bin/neovim-node-host")
  let g:python3_host_prog=expand("~/.bin/python")
  let g:ruby_host_prog=expand("~/.bin/neovim-ruby-host")

  call plug#begin('~/.vim/plugged')
    " preferred color scheme
    Plug 'arcticicestudio/nord-vim'

    " linting and fixing
    Plug 'dense-analysis/ale'

    " vcs integrations
    Plug 'mhinz/vim-signify'

    " syntax
    Plug 'kevinoid/vim-jsonc'

    " completions
    Plug 'codota/tabnine-vim'

    " plugins to review
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'editorconfig/editorconfig-vim'
    " Plug 'ervandew/supertab'
    Plug 'sheerun/vim-polyglot'
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-rails'
    Plug 'tpope/vim-sensible'
    Plug 'vim-airline/vim-airline'
  call plug#end()

  syntax on
  filetype plugin indent on

  set termguicolors
  set background=dark
  let g:nord_italic=1
  let g:nord_underline=1
  colorscheme nord

  let mapleader=','

  set backspace=indent,eol,start
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
  \   'css': ['prettier'],
  \   'graphql': ['prettier'],
  \   'html': ['prettier'],
  \   'javascript': ['prettier'],
  \   'json': ['prettier'],
  \   'json5': ['prettier'],
  \   'less': ['prettier'],
  \   'markdown': ['prettier'],
  \   'php': ['remove_trailing_lines', 'trim_whitespace', 'prettier', 'phpcbf'],
  \   'python': ['isort', 'black'],
  \   'ruby': ['remove_trailing_lines', 'trim_whitespace', 'standardrb'],
  \   'scss': ['prettier'],
  \   'typescript': ['prettier'],
  \   'yaml': ['prettier'],
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
endif
