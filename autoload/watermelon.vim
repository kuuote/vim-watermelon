" Linux only
function! watermelon#chdir() abort
  if has("nvim")
    let pid = jobpid(getbufvar(b:watermelon_bufnr, "terminal_job_id"))
  elseif has("patch-8.0.803")
    let pid = job_info(term_getjob(b:watermelon_bufnr)).process
  else
    return
  endif
  exe "silent! lcd" resolve(printf("/proc/%d/cwd", pid))
endfunction

function! watermelon#send(action) abort
  let cmd = getline(".") .. a:action
  if has("nvim")
    call jobsend(getbufvar(b:watermelon_bufnr, "terminal_job_id"), cmd)
  else
    call term_sendkeys(b:watermelon_bufnr, cmd)
  endif
endfunction

function! watermelon#goterm() abort
  call win_gotoid(b:watermelon_winid)
  startinsert
endfunction

function! watermelon#open() abort
  if has("nvim")
    tabnew
    terminal
    call cursor(line("$"), 1)
  else
    tab terminal
  endif
  let bufnr = bufnr("%")
  let winid = win_getid()
  belowright new
  setlocal buftype=nofile bufhidden=hide noswapfile
  let b:watermelon_bufnr = bufnr
  let b:watermelon_winid = winid
  execute "setfiletype" executable("zsh") ? "zsh" : "sh"
  execute "resize" &cmdwinheight
  nnoremap <buffer> <silent> <CR> :<C-u>call watermelon#send("\r")<CR>
  inoremap <buffer> <silent> <C-j> <C-o>:call watermelon#send("\r")<CR>
  inoremap <buffer> <silent> <CR> <C-o>:call watermelon#send("\r")<CR><End><CR>
  if g:watermelon_shellcomplete
    inoremap <buffer> <silent> <Tab> <Esc>:call watermelon#send("\t")<CR>:call watermelon#goterm()<CR>
  else
    inoremap <buffer> <Tab> <C-x><C-o>
  endif
  if g:watermelon_chdir && isdirectory("/proc")
    autocmd CursorMoved,CursorMovedI <buffer> call watermelon#chdir()
  endif
  execute printf("autocmd BufDelete <buffer=%d> stopinsert", bufnr)
  execute printf("autocmd BufDelete <buffer=%d> bdelete %d", bufnr, bufnr("%"))
  if filereadable(".watermelon")
    r .watermelon
    0d_
  endif
endfunction
