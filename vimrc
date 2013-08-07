" My currently working version Vimrc
"
" I kept all other settings in plugins/settings directory
"
" Eddie Kao
" http://blog.eddie.com.tw
" eddie@digik.com.tw

runtime bundle/vim-pathogen/autoload/pathogen.vim
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
call pathogen#infect()
call pathogen#helptags()

" hit enter to cancel searched highlight
noremap <CR> :nohlsearch<CR>

" select ALL
map <C-A> ggVG
colorscheme solarized
"let g:solarized_termcolors=256
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
"set background=light
set background=dark

"let g:DoxygenToolkit_briefTag_pre=""
"let g:DoxygenToolkit_paramTag_pre="@param "
"let g:DoxygenToolkit_returnTag="@returns   "
"let g:DoxygenToolkit_blockHeader=""
"let g:DoxygenToolkit_blockFooter=""
"let g:DoxygenToolkit_authorName="Robbin Han"
"let g:DoxygenToolkit_licenseTag=""
"
let g:myCodeCommenterConfigItems  = {
            \ 'author': 'robbin han',
            \ 'email': 'luckyhanbin@gmail.com',
            \ 'companyName': 'Kingnet',
            \ 'projectDecription': 'KingnetPay',
            \ }
nnoremap <SPACE> :
