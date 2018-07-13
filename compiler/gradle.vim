" Vim Compiler File
" Compiler: gradle

let s:gradlew = escape(findfile('gradlew', '.;') . " -b " . findfile('build.gradle', '.;'), ' \')

if exists("current_compiler")
    finish
endif
let current_compiler = "gradle"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

"""" Below code is better than hardcoded program name
" CompilerSet makeprg=gradle

execute "CompilerSet makeprg=" . s:gradlew

" Doesn't work with JDK1.8+
"CompilerSet errorformat=
"    \%-G:%.%\\+UP-TO-DATE,
"    \%E%f:\ %\\d%\\+:\ %m\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
"    \%E%>%f:\ %\\d%\\+:\ %m,%C\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
"    \%-G\\s%#,
"    \%-GBUILD\ SUCCESSFUL#,
"    \%-GTotal\ \time:\ %.%#

CompilerSet errorformat=%E:%.%#compileTarget%f:%l:\ %m,%-Z%p^,%E:%.%#compileJava%f:%l:\ %m,%-Z%p^,%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#
