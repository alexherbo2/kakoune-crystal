# Crystal
# https://crystal-lang.org

# Detection ────────────────────────────────────────────────────────────────────

# Sets Crystal filetype when opening `.cr` files.
remove-hooks global crystal-detection
hook -group crystal-detection global BufCreate '.+\.cr' %{
  set-option buffer filetype crystal
}

# Enables syntax highlighting for Crystal filetype.
remove-hooks global crystal-highlight
hook -group crystal-highlight global WinSetOption filetype=crystal %{
  add-highlighter -override window/crystal ref crystal
  hook -always -once window WinSetOption 'filetype=.*' %{
    remove-highlighter window/crystal
  }
}

# Sets indentation rules for Crystal filetype.
remove-hooks global crystal-indent
hook -group crystal-indent global WinSetOption filetype=crystal %{
  hook -group crystal-indent window InsertChar '\n' crystal-indent-on-new-line
  # Increase and decrease indent with Tab.
  map -docstring 'Increase indent' global insert <tab> '<a-;><a-gt>'
  map -docstring 'Decrease indent' global insert <s-tab> '<a-;><lt>'
  hook -always -once window WinSetOption 'filetype=.*' %{
    remove-hooks window crystal-indent-on-new-line
    unmap window insert <tab>
    unmap window insert <s-tab>
  }
}

# Configures word selection and completion for Crystal filetype.
# `static_words` option is generated with `crystal-check-news`.
remove-hooks global crystal-config
hook -group crystal-config global WinSetOption filetype=crystal %{
  set-option buffer extra_word_chars '_' '?' '!'
  set-option window static_words 'abort' 'abstract' 'alias' 'annotation' 'as' 'as?' 'asm' 'at_exit' 'begin' 'break' 'caller' 'case' 'class' 'class_getter' 'class_getter!' 'class_getter?' 'class_property' 'class_property!' 'class_property?' 'class_setter' 'debugger' 'def' 'def_clone' 'def_equals' 'def_equals_and_hash' 'def_hash' 'delegate' 'do' 'else' 'elsif' 'end' 'ensure' 'enum' 'exit' 'extend' 'false' 'for' 'forward_missing_to' 'fun' 'gets' 'getter' 'getter!' 'getter?' 'if' 'in' 'include' 'instance_sizeof' 'is_a?' 'lib' 'loop' 'macro' 'main' 'module' 'next' 'nil' 'nil?' 'of' 'offsetof' 'out' 'p' 'p!' 'pointerof' 'pp' 'pp!' 'print' 'printf' 'private' 'property' 'property!' 'property?' 'protected' 'puts' 'raise' 'raise_without_backtrace' 'rand' 'read_line' 'record' 'require' 'rescue' 'responds_to?' 'return' 'select' 'self' 'setter' 'sizeof' 'sleep' 'spawn' 'sprintf' 'struct' 'super' 'system' 'then' 'timeout_select_action' 'true' 'type' 'typeof' 'uninitialized' 'union' 'unless' 'until' 'verbatim' 'when' 'while' 'with' 'yield'
  hook -always -once window WinSetOption 'filetype=.*' %{
    unset-option buffer extra_word_chars
    unset-option window static_words
  }
}

# Indentation ──────────────────────────────────────────────────────────────────

define-command -override -hidden crystal-indent-on-new-line %{
  # Copy previous line indent
  try %[ execute-keys -draft 'K<a-&>' ]
  # Clean previous line indent
  try %[ execute-keys -draft 'k<a-x>s^\h+$<ret>d' ]
}

# Highlighters ─────────────────────────────────────────────────────────────────

# Internal variables
declare-option -hidden str crystal_word_pattern '\w+[?!]?'

add-highlighter -override shared/crystal regions
add-highlighter -override shared/crystal/code default-region group

# Syntax and semantics ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/

# Method definition and call ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/method_arguments.html

add-highlighter -override shared/crystal/code/instance-method-definition regex "\bdef\h+(%opt{crystal_word_pattern})\b" 1:function
add-highlighter -override shared/crystal/code/class-method-definition regex "\bdef\h+(self\.%opt{crystal_word_pattern})\b" 1:function
add-highlighter -override shared/crystal/code/method-call regex "\b(%opt{crystal_word_pattern})\(" 1:function

# Instance and class variables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/methods_and_instance_variables.html
# https://crystal-lang.org/reference/master/syntax_and_semantics/class_variables.html

add-highlighter -override shared/crystal/code/instance-and-class-variables regex '@@?\w+\b' 0:variable

# Keywords and operators ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Note:
# Generated with `crystal-check-news`.
add-highlighter -override shared/crystal/code/keywords regex '\babstract\b|\balias\b|\bannotation\b|\bas\b|\bas\?|\basm\b|\bbegin\b|\bbreak\b|\bcase\b|\bclass\b|\bdef\b|\bdo\b|\belse\b|\belsif\b|\bend\b|\bensure\b|\benum\b|\bextend\b|\bfalse\b|\bfor\b|\bfun\b|\bif\b|\bin\b|\binclude\b|\binstance_sizeof\b|\bis_a\?|\blib\b|\bmacro\b|\bmodule\b|\bnext\b|\bnil\b|\bnil\?|\bof\b|\boffsetof\b|\bout\b|\bpointerof\b|\bprivate\b|\bprotected\b|\brequire\b|\brescue\b|\bresponds_to\?|\breturn\b|\bselect\b|\bself\b|\bsizeof\b|\bstruct\b|\bsuper\b|\bthen\b|\btrue\b|\btype\b|\btypeof\b|\buninitialized\b|\bunion\b|\bunless\b|\buntil\b|\bverbatim\b|\bwhen\b|\bwhile\b|\bwith\b|\byield\b' 0:keyword
add-highlighter -override shared/crystal/code/operators regex '!|!=|!~|\$\?|\$~|%|%=|%\}|&|&&=|&\*|&\*\*|&\*=|&\+|&\+=|&-|&-=|&=|\*|\*\*|\*\*=|\*=|\+|\+=|-|-=|->|\.\.|\.\.\.|/|//|//=|/=|::|<|<<|<<=|<=|<=>|==|===|=>|=~|>|>=|>>|>>=|@\[|\[\]|\^|\^=|\{%|\{\{|\||\|=|\|\|=|\}\}|~' 0:operator
add-highlighter -override shared/crystal/code/top-level regex '\babort\b|\bat_exit\b|\bcaller\b|\bdebugger\b|\bexit\b|\bgets\b|\binstance_sizeof\b|\bloop\b|\bmain\b|\boffsetof\b|\bp\b|\bp!|\bpointerof\b|\bpp\b|\bpp!|\bprint\b|\bprintf\b|\bputs\b|\braise\b|\braise_without_backtrace\b|\brand\b|\bread_line\b|\brecord\b|\bsizeof\b|\bsleep\b|\bspawn\b|\bsprintf\b|\bsystem\b|\btimeout_select_action\b|\btypeof\b' 0:builtin
add-highlighter -override shared/crystal/code/object-macros regex '\bclass_getter\b|\bclass_getter!|\bclass_getter\?|\bclass_property\b|\bclass_property!|\bclass_property\?|\bclass_setter\b|\bdef_clone\b|\bdef_equals\b|\bdef_equals_and_hash\b|\bdef_hash\b|\bdelegate\b|\bforward_missing_to\b|\bgetter\b|\bgetter!|\bgetter\?|\bproperty\b|\bproperty!|\bproperty\?|\bsetter\b' 0:builtin

# Constants ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/constants.html

add-highlighter -override shared/crystal/code/constant regex '\b[A-Z]\w*\b' 0:value

# Numbers ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/integers.html
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/floats.html

# Examples:
#
# decimal number ⇒ 1_000_000
# float number ⇒ 1_000_000.111_111
#
add-highlighter -override shared/crystal/code/integer-decimal regex '\b\d(_?\d+)*(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/float-decimal regex '\b\d(_?\d+)*\.\d(_?\d+)*(_(f32|f64))?\b' 0:value

# Examples:
#
# binary number ⇒ 0b1101
# octal number ⇒ 0o123
# hexadecimal number ⇒ 0xfe012d
#
add-highlighter -override shared/crystal/code/integer-binary regex '\b0b[0-1]+(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/integer-octal regex '\b0o[0-7]+(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/integer-hexadecimal regex '\b0x[0-9a-fA-F]+(_[iu](8|16|32|64|128))?\b' 0:value

# Comments ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/comments.html

# Note: Avoid string literals with interpolation.
#
# Example:
#
# puts "hello #{name}"
#
add-highlighter -override shared/crystal/comment region '#(?!\{)' '$' group
add-highlighter -override shared/crystal/comment/fill fill comment

# Documenting code ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/documenting_code.html

# Example:
#
# A unicorn is a **legendary animal**.
#
# To create a unicorn:
#
# ```
# unicorn = Unicorn.new
# unicorn.speak
# ```
#
# Check the number of horns with `#horns`.
#
add-highlighter -override shared/crystal/comment/reference regex "`[#.]?%opt{crystal_word_pattern}`" 0:mono
add-highlighter -override shared/crystal/comment/parameter regex '\*\w+\*' 0:mono
add-highlighter -override shared/crystal/comment/code-block regex '```(\h*\w+)?$' 0:block
add-highlighter -override shared/crystal/comment/admonition regex '\h+([A-Z]+):\h+' 1:meta
add-highlighter -override shared/crystal/comment/directive regex ':\w+:' 0:meta

# Interpolation ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#interpolation
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#escaping

# Defines Crystal interpolation.
#
# Syntax:
#
# define-crystal-interpolation <region-name> <face-name> [<region-switches>] <opening-pattern> <closing-pattern>
#
# Example:
#
# define-crystal-interpolation parenthesis-string string -recurse '\(' '%\(' '\)'
#
# name = "world"
# puts %(hello #{name})
#
declare-option -hidden str-list crystal_optional_arguments
define-command -override -hidden define-crystal-interpolation -params .. %{
  set-option global crystal_optional_arguments %arg{@}
  set-option -remove global crystal_optional_arguments %arg{1} %arg{2}
  add-highlighter -override "shared/crystal/%arg{1}" region %opt{crystal_optional_arguments} regions
  add-highlighter -override "shared/crystal/%arg{1}/content" default-region group
  add-highlighter -override "shared/crystal/%arg{1}/content/fill" fill %arg{2}
  add-highlighter -override "shared/crystal/%arg{1}/content/escaped-character" regex '\\.' 0:meta
  add-highlighter -override "shared/crystal/%arg{1}/content/escape-sequence" regex '\\(x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}|u\{[0-9a-fA-F]+\})' 0:meta
  add-highlighter -override "shared/crystal/%arg{1}/interpolation" region -recurse '\{' '#\{' '\}' group # }
  add-highlighter -override "shared/crystal/%arg{1}/interpolation/delimiters" regex '(?<opening>..).+(?<closing>.)' opening:meta closing:meta
  add-highlighter -override "shared/crystal/%arg{1}/interpolation/crystal" ref crystal
}

# Characters ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/char.html

# Examples:
#
# simple character ⇒ 'a'
# single quote ⇒ '\''
# backslash ⇒ '\\'
#
define-crystal-interpolation character value "'" "(?<!\\)(\\\\)*'"

# Strings ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html

# String literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Examples:
#
# simple string ⇒ "hello world"
# double quote ⇒ "\""
# backslash ⇒ "\\"
#
define-crystal-interpolation string string '"' '(?<!\\)(\\\\)*"'

# Percent string literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-literals

# Example:
#
# name = "world"
# puts %Q(hello #{name})
#
define-crystal-interpolation parenthesis-string string -recurse '\(' '%Q?\(' '\)'
define-crystal-interpolation bracket-string string -recurse '\[' '%Q?\[' '\]'
define-crystal-interpolation brace-string string -recurse '\{' '%Q?\{' '\}'
define-crystal-interpolation angle-string string -recurse '<' '%Q?<' '>'
define-crystal-interpolation pipe-string string '%Q?\|' '\|'

# Raw percent string literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-literals
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-array-literal
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/symbol.html#percent-symbol-array-literal

# Example:
#
# puts %q(hello world)
#
add-highlighter -override shared/crystal/raw-parenthesis-string region -recurse '\(' '%[qwi]\(' '\)' fill string
add-highlighter -override shared/crystal/raw-bracket-string region -recurse '\[' '%[qwi]\[' '\]' fill string
add-highlighter -override shared/crystal/raw-brace-string region -recurse '\{' '%[qwi]\{' '\}' fill string
add-highlighter -override shared/crystal/raw-angle-string region -recurse '<' '%[qwi]<' '>' fill string
add-highlighter -override shared/crystal/raw-pipe-string region '%[qwi]\|' '\|' fill string

# Here document ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#heredoc

# Example:
#
# <<-'EOF'
# EOF
#
define-crystal-interpolation heredoc string -match-capture '<<-(\w+)' '^\h*(\w+)$'
add-highlighter -override shared/crystal/raw-heredoc region -match-capture "<<-'(\w+)'" '^\h*(\w+)$' fill string

# Symbols ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/symbol.html

# Symbol literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# :"quoted symbol"
#
add-highlighter -override shared/crystal/quoted-symbol region ':"' '(?<!\\)(\\\\)*"' fill value

# Regular expressions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/regex.html

# Regex literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# /foo/i.match("FOO")
#
define-crystal-interpolation regex meta '/' '(?<!\\)(\\\\)*/[imx]*'

# Note: Avoid unterminated regular expression and floor division as regex.
#
# Examples:
#
# division ⇒ 1 / 2
# floor division ⇒ 1 // 2
#
add-highlighter -override shared/crystal/division-as-region region ' //? ' '.\K' group
add-highlighter -override shared/crystal/division-as-region/operator regex '//?' 0:operator

# Percent regex literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# %r(foo|bar)
#
define-crystal-interpolation parenthesis-regex meta -recurse '\(' '%r\(' '\)[imx]*'
define-crystal-interpolation bracket-regex meta -recurse '\[' '%r\[' '\][imx]*'
define-crystal-interpolation brace-regex meta -recurse '\{' '%r\{' '\}[imx]*'
define-crystal-interpolation angle-regex meta -recurse '<' '%r<' '>[imx]*'
define-crystal-interpolation pipe-regex meta '%r\|' '\|[imx]*'

# Command literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/command.html

# Example:
#
# `echo foo`
#
define-crystal-interpolation command meta '`' '(?<!\\)(\\\\)*`'

# Percent command literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# %x(echo foo)
#
define-crystal-interpolation parenthesis-command meta -recurse '\(' '%x\(' '\)'
define-crystal-interpolation bracket-command meta -recurse '\[' '%x\[' '\]'
define-crystal-interpolation brace-command meta -recurse '\{' '%x\{' '\}'
define-crystal-interpolation angle-command meta -recurse '<' '%x<' '>'
define-crystal-interpolation pipe-command meta '%x\|' '\|'

# What’s new ───────────────────────────────────────────────────────────────────

# Builds a ready for use `str-list` and `regex` with selections.
#
# Usage:
#
# Fetch a document, select keywords and call `crystal-buffer-build-result keywords`.
#
define-command -override -hidden crystal-buffer-build-result -params 1 %{
  execute-keys 'a<ret><esc>y%<a-R>%|sort -u<ret><a-s>_'
  execute-keys -save-regs '' '*'
  echo -debug crystal %arg{1} as str-list:
  echo -debug -quoting kakoune %val{selections}
  echo -debug crystal %arg{1} as regex:
  echo -debug -quoting kakoune %val{main_reg_slash}
}

define-command -override -hidden crystal-buffer-build-result-with-static-words -params 1 %{
  crystal-buffer-build-result %arg{1}
  set-option -add window static_words %val{selections}
}

define-command -override -hidden crystal-check-news %{
  # Initialization
  edit! -scratch '*crystal*'
  set-option window static_words

  # Keywords ⇒ https://github.com/crystal-lang/crystal/blob/master/src/compiler/crystal/syntax/lexer.cr
  execute-keys '%|curl -sSL https://github.com/crystal-lang/crystal/raw/master/src/compiler/crystal/syntax/lexer.cr<ret>'
  execute-keys '%1<s>check_ident_or_keyword\(:(%opt{crystal_word_pattern}<a-!>),\h+\w+\)<ret>Z%1<s>@token\.value\h+=\h+:(%opt{crystal_word_pattern}<a-!>)<ret><a-z>a'
  crystal-buffer-build-result-with-static-words keywords

  # Operators ⇒ https://github.com/crystal-lang/crystal/blob/master/src/compiler/crystal/syntax/parser.cr
  execute-keys '%|curl -sSL https://github.com/crystal-lang/crystal/raw/master/src/compiler/crystal/syntax/parser.cr<ret>'
  execute-keys '%<a-s><a-k>AtomicWithMethodCheck\h+=<ret>1<s>:"([^"[]+)"<ret>Z%<a-s><a-k>(check|when)\h+:<ret>1<s>:"([^"]{2,3})"<ret><a-z>a'
  crystal-buffer-build-result operators

  # Top Level Namespace
  # https://crystal-lang.org/api/master/toplevel.html#method-summary
  # https://crystal-lang.org/api/master/toplevel.html#macro-summary
  execute-keys '%|curl -sSL https://crystal-lang.org/api/master/toplevel.html<ret>'
  execute-keys '%1<s>class="entry-detail"\h+id="(%opt{crystal_word_pattern}<a-!>)[^"]*-(method|macro)"<ret>'
  crystal-buffer-build-result-with-static-words top-level

  # Object macros ⇒ https://crystal-lang.org/api/master/Object.html#macro-summary
  execute-keys '%|curl -sSL https://crystal-lang.org/api/master/Object.html<ret>'
  execute-keys '%1<s>class="entry-detail"\h+id="(%opt{crystal_word_pattern}<a-!>)[^"]*-(macro)"<ret>'
  crystal-buffer-build-result-with-static-words object-macros

  # Static words
  set-register dquote %opt{static_words}
  execute-keys '%<a-R>'
  crystal-buffer-build-result static_words

  # Show result
  delete-buffer
  buffer '*debug*'
  execute-keys 'gj'
}
