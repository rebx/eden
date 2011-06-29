WhiteSpaceCleaner.configure do |wsc|
  # Remove any white space after the last non-whitespace token?
  wsc.remove_trailing_whitespace true
end

Indenter.configure do |indent|
  # Make any change to code indents at all?
  indent.adjust_indents true

  # What character should be used to pad the indents
  indent.indent_character ' '

  # How many of the indent_character should be used at each level of indent
  indent.indent_characters_per_step 2
end

BlockFormatter.configure do |block_format|
  # Modify block spacing at all?
  block_format.adjust_blocks true

  # What charater to pad blocks with?
  block_format.padding_character " "

  # How many padding characters to use at each end of the inline block?
  block_format.padding_character_count 1
end
