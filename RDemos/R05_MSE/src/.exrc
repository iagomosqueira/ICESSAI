if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <Down> gj
inoremap <Up> gk
imap <C-Space> "ap
noremap! <C-F1> :Man 
map! <S-Space> 
map! <S-Insert> <MiddleMouse>
nnoremap  :noh/<BS>
nmap  :wqa
noremap  :w
nnoremap s :Scratch
nnoremap t :ScratchFind
noremap   :call ToggleFold()
map ,p :call PreviewMarkdown()
nmap <silent> /cv <Plug>VCSVimDiff
nmap <silent> /cu <Plug>VCSUpdate
nmap <silent> /cU <Plug>VCSUnlock
nmap <silent> /cs <Plug>VCSStatus
nmap <silent> /cr <Plug>VCSReview
nmap <silent> /cq <Plug>VCSRevert
nmap <silent> /cn <Plug>VCSAnnotate
nmap <silent> /cN <Plug>VCSSplitAnnotate
nmap <silent> /cl <Plug>VCSLog
nmap <silent> /cL <Plug>VCSLock
nmap <silent> /ci <Plug>VCSInfo
nmap <silent> /cg <Plug>VCSGotoOriginal
nmap <silent> /cG <Plug>VCSClearAndGotoOriginal
nmap <silent> /cd <Plug>VCSDiff
nmap <silent> /cD <Plug>VCSDelete
nmap <silent> /cc <Plug>VCSCommit
nmap <silent> /ca <Plug>VCSAdd
nmap K <Plug>ManPageView
nnoremap blog :! python $HOME/.vim/perl/bg.py --f %:p --u iago.mosqueira@gmail.com --p inline
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
nnoremap <silent> <Plug>VCSVimDiff :VCSVimDiff
nnoremap <silent> <Plug>VCSUpdate :VCSUpdate
nnoremap <silent> <Plug>VCSUnlock :VCSUnlock
nnoremap <silent> <Plug>VCSStatus :VCSStatus
nnoremap <silent> <Plug>VCSSplitAnnotate :VCSAnnotate!
nnoremap <silent> <Plug>VCSReview :VCSReview
nnoremap <silent> <Plug>VCSRevert :VCSRevert
nnoremap <silent> <Plug>VCSLog :VCSLog
nnoremap <silent> <Plug>VCSLock :VCSLock
nnoremap <silent> <Plug>VCSInfo :VCSInfo
nnoremap <silent> <Plug>VCSClearAndGotoOriginal :VCSGotoOriginal!
nnoremap <silent> <Plug>VCSGotoOriginal :VCSGotoOriginal
nnoremap <silent> <Plug>VCSDiff :VCSDiff
nnoremap <silent> <Plug>VCSDelete :VCSDelete
nnoremap <silent> <Plug>VCSCommit :VCSCommit
nnoremap <silent> <Plug>VCSAnnotate :VCSAnnotate
nnoremap <silent> <Plug>VCSAdd :VCSAdd
nnoremap <F11> :Scratch
nmap <F10> :SCCompileRun 
nmap <F9> :SCCompile
nnoremap <Down> gj
nnoremap <Up> gk
noremap <C-Down> w
noremap <C-Up> W
nmap <C-Space> "aP
vmap <C-Space> "ay
nmap <F12> :wa|exe "mksession! ./.vim.session"
map <silent> <F2> :write
map <S-Insert> <MiddleMouse>
inoremap  :wi
inoremap  ui
imap ~N Ñ
imap ~n ñ
iabbr zimhead :call InsertZimHeader()i
let &cpo=s:cpo_save
unlet s:cpo_save
set autochdir
set autoindent
set background=dark
set backspace=start,indent,eol
set cmdheight=2
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set guifont=Inconsolata\ 12
set guioptions=gmrT
set helplang=en
set history=50
set hlsearch
set ignorecase
set laststatus=2
set listchars=eol:$,tab:|\ 
set mouse=a
set mousemodel=popup
set path=.,/usr/include,/usr/lib/R/include,,
set printdevice=PDF
set printoptions=paper:letter
set ruler
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
set shiftwidth=2
set statusline=%{GitBranchInfoString()}%f\ %y%([%R%M]%)%{'!'[&ff=='unix']}%{'$'[!&list]}%=#%n\ %l/%L,%c\ 
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=2
set tags=tags;
set termencoding=utf-8
set titlestring=/home/imosqueira/Work/Projects/training/ICESSAI/RDemos/R04_MSE/src/intro_r.md
set viminfo='20,\"50
set visualbell
set wildmenu
set window=35
" vim: set ft=vim :
