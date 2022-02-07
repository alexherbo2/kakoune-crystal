# Crystal
# https://crystal-lang.org

# Configuration ────────────────────────────────────────────────────────────────

# Word pattern
# https://code.visualstudio.com/api/language-extensions/language-configuration-guide#word-pattern
declare-option -docstring 'Crystal word pattern' str crystal_word_pattern '\w+[?!]?'

# Indentation rules
# https://code.visualstudio.com/api/language-extensions/language-configuration-guide#indentation-rules
declare-option -docstring 'Crystal indentation rules to increase the indentation of the current line or next line' str crystal_indentation_rules_increase_indent_pattern '^[^#]*[({\[]$|^\h*(if|elsif|else|unless|case|when|case|in|while|until|class|private\h+class|abstract\h+class|private\h+abstract\h+class|def|private\h+def|protected\h+def|module|private\h+module|struct|private\h+struct|abstract\h+struct|private\h+abstract\h+struct|enum|private\h+enum|begin|rescue|ensure|macro|annotation|lib|private\h+lib)[^;]*$|^[^#]*\h(do)[^;]*$|^[^#]*=\h*(if|unless|case)[^;]*$'
declare-option -docstring 'Crystal indentation rules to decrease the indentation of the current line or next line' str crystal_indentation_rules_decrease_indent_pattern '^\h*[)}\]]\z|^\h*(elsif|else|end|when|in|rescue|ensure)\z'

# Reference
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/control_expressions.html
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/if.html
#
# value = if some_condition
# elsif some_other_condition
# else
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/unless.html
#
# value = unless some_condition
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/case.html
#
# value = case expression
# when value
# end
#
# value = case expression
# in value
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/while.html
#
# while some_condition
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/until.html
#
# until some_condition
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/types_and_methods.html
# https://crystal-lang.org/reference/master/syntax_and_semantics/visibility.html
# https://crystal-lang.org/reference/master/syntax_and_semantics/virtual_and_abstract_types.html
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/classes_and_methods.html
#
# class Person
# end
#
# private class Person
# end
#
# abstract class Person
# end
#
# private abstract class Person
# end
#
# def name
# end
#
# private def name
# end
#
# protected def name
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/modules.html
#
# module JSON
# end
#
# private module JSON
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/structs.html
#
# struct Point
# end
#
# private struct Point
# end
#
# abstract struct Point
# end
#
# private abstract struct Point
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/enum.html
#
# enum Color
# end
#
# private enum Color
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/blocks_and_procs.html
#
# loop do
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/exception_handling.html
#
# begin
# rescue exception
# ensure
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/macros/
#
# macro version
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/annotations/
#
# annotation Link
# end
#
# https://crystal-lang.org/reference/master/syntax_and_semantics/c_bindings/
# https://crystal-lang.org/reference/master/syntax_and_semantics/c_bindings/lib.html
#
# lib C
# end
#
# private lib C
# end

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
  hook -group crystal-indent window InsertChar '.*' crystal-indent-on-inserted-character
  # Increase and decrease indent with Tab.
  map -docstring 'Increase indent' window insert <tab> '<a-;><a-gt>'
  map -docstring 'Decrease indent' window insert <s-tab> '<a-;><lt>'
  map -docstring 'Decrease indent or erase character before cursor' window insert <backspace> '<a-;>: decrease-indent-or-erase-character-before-cursor<ret>'
  hook -always -once window WinSetOption 'filetype=.*' %{
    remove-hooks window crystal-indent
    unmap window insert <tab>
    unmap window insert <s-tab>
  }
}

# Backspace ⇒ Decrease indent or erase character before cursor.
define-command -override -hidden decrease-indent-or-erase-character-before-cursor %{
  try %{
    execute-keys -draft '<space><a-h><a-k>\A\h+.\z<ret>'
    execute-keys -draft '<lt>'
  } catch %{
    execute-keys -draft ';i<backspace>'
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

define-command -override -hidden crystal-indent-on-inserted-character %{
  evaluate-commands -draft -itersel %{
    # Select inserted character
    execute-keys h

    try %{
      # Indentation rules when inserting a new line
      execute-keys -draft '<a-k>\n<ret>'
      # Copy previous line indent
      execute-keys -draft 'L<a-&>'
      # Clean previous line indent
      try %[ execute-keys -draft '<a-x>s^\h+$<ret>d' ]

      # Increase the indentation of the next line
      try %{
        execute-keys -draft '<a-h><a-k>%opt{crystal_indentation_rules_increase_indent_pattern}<a-!><ret>'
        execute-keys -draft 'l<a-gt>'
      }

      # Decrease the indentation of the next line
      # when inserting a new line in the middle of line
      try %{
        execute-keys -draft 'l<a-x>_;<a-h><a-k>%opt{crystal_indentation_rules_decrease_indent_pattern}<a-!><ret>'
        execute-keys -draft 'l<lt>'
      }
    } catch %{
      # Indentation rules when inserting a character at the end of line
      execute-keys -draft 'l<a-k>\n<ret>'

      # Decrease the indentation of the current line
      try %{
        execute-keys -draft '<a-h><a-k>%opt{crystal_indentation_rules_decrease_indent_pattern}<a-!><ret>'
        execute-keys -draft '<lt>'
      }
    } catch %{}
  }
}

# Highlighters ─────────────────────────────────────────────────────────────────

# Creates the base regions
add-highlighter -override shared/crystal regions
add-highlighter -override shared/crystal/code default-region group

# Syntax and semantics ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Classes
# Comments
# Constants
# Entities
# Functions/Methods
# Keywords
# Language Built-ins
# Punctuation
# Storage
# Strings
# Variables

# Scope Naming
# Naming conventions
# Sublime Text
# TextMate
# https://docs.helix-editor.com/themes.html#syntax-highlighting
# https://macromates.com/manual/en/language_grammars
# https://github.com/crystal-lang-tools/vscode-crystal-lang/blob/master/syntaxes/crystal.json
# https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide
# https://sublimetext.com/docs/scope_naming.html

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

# Keywords ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Note:
# Generated with `crystal-check-news`.
# keyword
add-highlighter -override shared/crystal/code/keyword regex '\binstance_sizeof\b|\buninitialized\b|\bresponds_to\?|\bannotation\b|\bprotected\b|\bpointerof\b|\bverbatim\b|\boffsetof\b|\babstract\b|\brequire\b|\bprivate\b|\binclude\b|\bunless\b|\btypeof\b|\bstruct\b|\bsizeof\b|\bselect\b|\breturn\b|\brescue\b|\bmodule\b|\bextend\b|\bensure\b|\byield\b|\bwhile\b|\buntil\b|\bunion\b|\bsuper\b|\bmacro\b|\bis_a\?|\bfalse\b|\belsif\b|\bclass\b|\bbreak\b|\bbegin\b|\balias\b|\bwith\b|\bwhen\b|\btype\b|\btrue\b|\bthen\b|\bself\b|\bnil\?|\bnext\b|\benum\b|\belse\b|\bcase\b|\bout\b|\bnil\b|\blib\b|\bfun\b|\bfor\b|\bend\b|\bdef\b|\basm\b|\bas\?|\bof\b|\bin\b|\bif\b|\bdo\b|\bas\b' 0:keyword

# Built-in functions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Note:
# Generated with `crystal-check-news`.
add-highlighter -override shared/crystal/code/top-level-namespace regex '\braise_without_backtrace\b|\btimeout_select_action\b|\binstance_sizeof\b|\bread_line\b|\bpointerof\b|\boffsetof\b|\bdebugger\b|\bsprintf\b|\bat_exit\b|\btypeof\b|\bsystem\b|\bsizeof\b|\brecord\b|\bprintf\b|\bcaller\b|\bspawn\b|\bsleep\b|\braise\b|\bprint\b|\babort\b|\brand\b|\bputs\b|\bmain\b|\bloop\b|\bgets\b|\bexit\b|\bpp!|\bpp\b|\bp!|\bp\b' 0:builtin
add-highlighter -override shared/crystal/code/object-macro regex '\bdef_equals_and_hash\b|\bforward_missing_to\b|\bclass_property\?|\bclass_property!|\bclass_property\b|\bclass_getter\?|\bclass_getter!|\bclass_setter\b|\bclass_getter\b|\bdef_equals\b|\bproperty\?|\bproperty!|\bdef_clone\b|\bproperty\b|\bdelegate\b|\bdef_hash\b|\bgetter\?|\bgetter!|\bsetter\b|\bgetter\b' 0:builtin

# Punctuation ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# punctuation.separator
add-highlighter -override shared/crystal/code/punctuation.separator regex '\.|::' 0:meta

# Operators ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/operators.html

add-highlighter -override shared/crystal/code/operator regex '[!%&*+/<=>^|~-]' 0:operator
add-highlighter -override shared/crystal/code/operator.range regex '\.\.\.?' 0:operator

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
add-highlighter -override shared/crystal/code/constant.numeric.integer.decimal regex '\b\d(_?\d+)*(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/constant.numeric.float.decimal regex '\b\d(_?\d+)*\.\d(_?\d+)*(_(f32|f64))?\b' 0:value

# Examples:
#
# binary number ⇒ 0b1101
# octal number ⇒ 0o123
# hexadecimal number ⇒ 0xfe012d
#
add-highlighter -override shared/crystal/code/constant.numeric.integer.binary regex '\b0b[0-1]+(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/constant.numeric.integer.octal regex '\b0o[0-7]+(_[iu](8|16|32|64|128))?\b' 0:value
add-highlighter -override shared/crystal/code/constant.numeric.integer.hexadecimal regex '\b0x[0-9a-fA-F]+(_[iu](8|16|32|64|128))?\b' 0:value

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

# Defines Crystal raw string.
#
# Syntax:
#
# define-crystal-string <region-name> <face-name> [<region-switches>] <opening-pattern> <closing-pattern>
#
# Example:
#
# define-crystal-string raw-parenthesis-string string -recurse '\(' '%q\(' '\)'
#
# puts %q(hello world)
#
declare-option -hidden str-list crystal_optional_arguments
define-command -override -hidden define-crystal-string -params 4.. %{
  set-option global crystal_optional_arguments %arg{@}
  set-option -remove global crystal_optional_arguments %arg{1} %arg{2}
  add-highlighter -override "shared/crystal/%arg{1}" region %opt{crystal_optional_arguments} regions
  add-highlighter -override "shared/crystal/%arg{1}/content" default-region group
  add-highlighter -override "shared/crystal/%arg{1}/content/fill" fill %arg{2}
  add-highlighter -override "shared/crystal/%arg{1}/content/escaped-character" regex '\\.' 0:meta
  add-highlighter -override "shared/crystal/%arg{1}/content/escape-sequence" regex '\\(x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}|u\{[0-9a-fA-F]+\})' 0:meta
}

# Defines Crystal string interpolation.
#
# Syntax:
#
# define-crystal-interpolated-string <region-name> <face-name> [<region-switches>] <opening-pattern> <closing-pattern>
#
# Example:
#
# define-crystal-interpolated-string parenthesis-string string -recurse '\(' '%\(' '\)'
#
# name = "world"
# puts %(hello #{name})
#
define-command -override -hidden define-crystal-interpolated-string -params 4.. %{
  define-crystal-string %arg{@}
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
define-crystal-string string.character value "'" "(?<!\\)(\\\\)*'"

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
define-crystal-interpolated-string string.quoted.double string '"' '(?<!\\)(\\\\)*"'

# Percent string literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-literals

# Example:
#
# name = "world"
# puts %Q(hello #{name})
#
define-crystal-interpolated-string string.quoted.percent.parenthesis.interpolated string -recurse '\(' '%Q?\(' '\)'
define-crystal-interpolated-string string.quoted.percent.bracket.interpolated string -recurse '\[' '%Q?\[' '\]'
define-crystal-interpolated-string string.quoted.percent.brace.interpolated string -recurse '\{' '%Q?\{' '\}'
define-crystal-interpolated-string string.quoted.percent.angle.interpolated string -recurse '<' '%Q?<' '>'
define-crystal-interpolated-string string.quoted.percent.pipe.interpolated string '%Q?\|' '\|'

# Raw percent string literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-literals
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#percent-string-array-literal
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/symbol.html#percent-symbol-array-literal

# Example:
#
# puts %q(hello world)
#
define-crystal-string string.quoted.percent.parenthesis string -recurse '\(' '%[qwi]\(' '\)'
define-crystal-string string.quoted.percent.bracket string -recurse '\[' '%[qwi]\[' '\]'
define-crystal-string string.quoted.percent.brace string -recurse '\{' '%[qwi]\{' '\}'
define-crystal-string string.quoted.percent.angle string -recurse '<' '%[qwi]<' '>'
define-crystal-string string.quoted.percent.pipe string '%[qwi]\|' '\|'

# Here document ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/string.html#heredoc

# Example:
#
# <<-'EOF'
# EOF
#
define-crystal-interpolated-string string.unquoted.heredoc.interpolated string -match-capture '<<-(\w+)' '^\h*(\w+)$'
define-crystal-string string.unquoted.heredoc.raw string -match-capture "<<-'(\w+)'" '^\h*(\w+)$'

# Symbols ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/symbol.html

# Symbol literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# :"quoted symbol"
#
add-highlighter -override shared/crystal/code/constant.symbol regex ":%opt{crystal_word_pattern}" 0:value
define-crystal-string string.symbol value ':"' '(?<!\\)(\\\\)*"'

# Regular expressions ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/regex.html

# Regex literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# /foo/i.match("FOO")
#
define-crystal-interpolated-string string.regexp.interpolated meta '/' '(?<!\\)(\\\\)*/[imx]*'

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
define-crystal-interpolated-string interpolated-regex-with-percent-parentheses meta -recurse '\(' '%r\(' '\)[imx]*'
define-crystal-interpolated-string interpolated-regex-with-percent-brackets meta -recurse '\[' '%r\[' '\][imx]*'
define-crystal-interpolated-string interpolated-regex-with-percent-braces meta -recurse '\{' '%r\{' '\}[imx]*'
define-crystal-interpolated-string interpolated-regex-with-percent-angles meta -recurse '<' '%r<' '>[imx]*'
define-crystal-interpolated-string interpolated-regex-with-percent-pipes meta '%r\|' '\|[imx]*'

# Command literal ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Reference
# https://crystal-lang.org/reference/master/syntax_and_semantics/literals/command.html

# Example:
#
# `echo foo`
#
define-crystal-interpolated-string command meta '`' '(?<!\\)(\\\\)*`'

# Percent command literals ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Example:
#
# %x(echo foo)
#
define-crystal-interpolated-string parenthesis-command meta -recurse '\(' '%x\(' '\)'
define-crystal-interpolated-string bracket-command meta -recurse '\[' '%x\[' '\]'
define-crystal-interpolated-string brace-command meta -recurse '\{' '%x\{' '\}'
define-crystal-interpolated-string angle-command meta -recurse '<' '%x<' '>'
define-crystal-interpolated-string pipe-command meta '%x\|' '\|'

# What’s new ───────────────────────────────────────────────────────────────────

# Builds a ready for use `str-list` and `regex` with selections.
#
# Usage:
#
# Fetch a document, select keywords and call `crystal-build-result keywords`.
#
define-command -override -hidden crystal-build-result -params 1 %{
  # Initialization
  execute-keys -save-regs '' 'y'
  edit -scratch

  execute-keys '%<a-R>a<ret><esc>y%<a-R>%|sort -u<ret><a-s>_'
  echo -debug crystal %arg{1} as str-list:
  echo -debug -quoting kakoune %val{selections}

  execute-keys '%|awk ''{ print length, $0 }'' | sort -n -r | cut -d " " -f 2-<ret><a-s>_'
  execute-keys -save-regs '' '*'
  echo -debug crystal %arg{1} as regex:
  echo -debug -quoting kakoune %val{main_reg_slash}

  # Cleanup
  delete-buffer
  echo 'Open the *debug* buffer to see result.'
}

define-command -override -hidden crystal-build-result-with-static-words -params 1 %{
  crystal-build-result %arg{1}
  set-option -add window static_words %val{selections}
}

define-command -override -hidden crystal-check-news %{
  # Initialization
  edit -scratch
  set-option window static_words

  # Keywords ⇒ https://github.com/crystal-lang/crystal/blob/master/src/compiler/crystal/syntax/lexer.cr
  execute-keys '%|curl -sSL https://github.com/crystal-lang/crystal/raw/master/src/compiler/crystal/syntax/lexer.cr<ret>'
  execute-keys '%1<s>check_ident_or_keyword\(:(%opt{crystal_word_pattern}<a-!>),\h+\w+\)<ret>Z%1<s>@token\.value\h+=\h+:(%opt{crystal_word_pattern}<a-!>)<ret><a-z>a'
  crystal-build-result-with-static-words keywords

  # Top Level Namespace
  # https://crystal-lang.org/api/master/toplevel.html#method-summary
  # https://crystal-lang.org/api/master/toplevel.html#macro-summary
  execute-keys '%|curl -sSL https://crystal-lang.org/api/master/toplevel.html<ret>'
  execute-keys '%1<s>class="entry-detail"\h+id="(%opt{crystal_word_pattern}<a-!>)[^"]*-(method|macro)"<ret>'
  crystal-build-result-with-static-words top-level-namespace

  # Object macros ⇒ https://crystal-lang.org/api/master/Object.html#macro-summary
  execute-keys '%|curl -sSL https://crystal-lang.org/api/master/Object.html<ret>'
  execute-keys '%1<s>class="entry-detail"\h+id="(%opt{crystal_word_pattern}<a-!>)[^"]*-(macro)"<ret>'
  crystal-build-result-with-static-words object-macros

  # Static words
  set-register dquote %opt{static_words}
  execute-keys '%<a-R>'
  crystal-build-result static_words

  # Cleanup
  delete-buffer
  echo 'Open the *debug* buffer to see result.'
}
