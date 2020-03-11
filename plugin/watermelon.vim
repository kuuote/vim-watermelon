" `:terminal` helper
" Author: kuuote
" License: NYSL

if exists('g:loaded_watermelon')
  finish
endif
let g:loaded_watermelon = 1

if !has("nvim") && !has("patch-8.0.712")
  echomsg "This plugin requires Vim +8.0.0712"
  finish
endif

let g:watermelon_shellcomplete = get(g:, "watermelon_shellcomplete", v:true)
let g:watermelon_chdir = get(g:, "watermelon_chdir", v:false)

command Watermelon call watermelon#open()
