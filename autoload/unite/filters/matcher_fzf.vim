let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_fzf#define() abort
  return s:matcher
endfunction

let s:matcher = {
      \ 'name' : 'matcher_fzf',
      \ 'description' : 'fzf matcher',
      \}

" This is called for each element in conext.input_list
function! s:matcher.pattern(input) abort
  let input=a:input

  if input == '!' || input == "!$" || input == '' || input == "^" || input == "'"
    return ""

  elseif input =~ "^\^"
      "prefix-exact-match
    return "^".input[1:]

  elseif input =~ "^'"
    "exact-match
    return input[1:]

  elseif input =~ "\$$"
    "suffix-exact-match
    return input[:len(input)-2].'$'

  elseif input =~ "^!.*\$$"
    "inverse-suffix-exact-match
    return ""

  elseif input =~ "^!"
    "inverse-exact-match
    return ""

  else
    "fuzzy-match
    let searchchars=split(input, '\zs')
    let searchchars=map(searchchars, 'escape(v:val, "\\[]^$.*")')

    let searchterms=map(searchchars[:-2], "printf('%s[^%s]\\{-}', v:val, v:val)")
    let searchterms+= [ searchchars[-1] ]
    let search = join(searchterms, '')

    return search

  endif

  " Don't fully understand this
  "return substitute(unite#util#escape_match(a:input),
          "\ '\\\@<!|', '\\|', 'g')
endfunction

function! s:matcher.filter(candidates, context) abort
  if a:context.input == ''
    return a:candidates
  endif

  let candidates = a:candidates
  " Filter list by each term
  for input in a:context.input_list

    let regex_escape = '^$.*+()\\[]'

    if input == '!' || input == "!$" || input == '' || input == "^" || input == "'"
      continue

    elseif input =~ "^\^"
      "echom "prefix-exact-match on" input[1:]
      let expr = 'v:val.word =~ "^'.escape(input[1:], regex_escape).'"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    elseif input =~ "^'"
      "echom "exact-match on" input[1:]
      let expr = 'v:val.word =~ "'.escape(input[1:], regex_escape).'"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    elseif input =~ "\$$"
      echom "suffix-exact-match on" input[:len(input)-2]
      let expr = 'v:val.word =~ "'.escape(input[:len(input)-2], regex_escape).'$"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    elseif input =~ "^!.*\$$"
      "echom "inverse-suffix-exact-match on" input[1:len(input)-2]
      let expr = 'v:val.word !~ "'.escape(input[1:len(input)-2], regex_escape).'$"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    elseif input =~ "^!"
      "echom "inverse-exact-match on" input[1:]
      let expr = 'v:val.word !~ "'.escape(input[1:], regex_escape).'"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    else
      "echom "fuzzy-match on" input
      let searchchars=split(input, '\zs')
      let searchchars=map(searchchars, 'escape(v:val, "\\[]^$.*")')

      let searchterms=map(searchchars[:-2], "printf('%s[^%s]\\{-}', v:val, v:val)")
      let searchterms+= [ searchchars[-1] ]
      let search = join(searchterms, '')

      "echom "Search" search

      " Because this will go into an eval type string, it must be escaped again
      let expr = 'v:val.word =~ "'.escape(search, "\\").'"'
      let candidates = unite#filters#filter_matcher(l:candidates, expr, a:context)

    endif
  endfor

  return l:candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
