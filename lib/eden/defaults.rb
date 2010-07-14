WhiteSpaceCleaner.configure do |w|
  # Remove any white space after the last non-whitespace token?
  w.remove_trailing_whitespace true
end

Indenter.configure do |i|
  # Make any change to code indents at all?
  i.adjust_indents true

  # What character should be used to pad the indents
  i.indent_character ' '

  # How many of the indent_character should be used at each level of indent
  i.indent_characters_per_step 2
end
