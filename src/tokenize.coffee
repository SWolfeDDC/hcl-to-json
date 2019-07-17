debug  = (require 'debug') 'hcltojson:tokenize'
TOKENS = require './tokens'

CHARS = [
  [','  , TOKENS.COMMA    ]
  [':'  , TOKENS.COLON    ]
  ['='  , TOKENS.ASSIGN   ]
  ['{'  , TOKENS.LBRACE   ]
  ['}'  , TOKENS.RBRACE   ]
  ['['  , TOKENS.LBRACKET ]
  [']'  , TOKENS.RBRACKET ]
  ['<<' , TOKENS.HEREDOC  ]
]

clearQuotes = (m) -> if m?[0] is '"' then m else ''

module.exports = tokenize = (input) ->

  debug 'input', input

  # remove comments
  input = input.replace ///
    ".+?"|\#[\s\S]*?.*
  ///igm, clearQuotes

  input = input.replace ///
    ".+?"|\/\*[\s\S]*?\*\/|\/\/.*
  ///gm, clearQuotes

  debug 'comments.removed', input

  # tokenize input
  for [char, token] in CHARS
    char = "\\#{char}"
    regex = ///(["'])(?:(?=(\\?))\2.)*?\1|(?<char>#{char})///g
    input = input.replace regex, (match, group1, group2, group3, group4, group5, group6) ->
      {char} = group6.char # ...rest parameter isn't compiling with coffee for some reason
      console.log({regex, match, groups, char } #, params: {group1, group2, group3, group4, group5, group6, group7, group8}})
      unless char then match else " #{token} "

  debug 'tokenized', input

  # mark spaces
  input = input.replace ///
    \s+(?=([^"]*"[^"]*")*[^"]*$)
  ///gm, TOKENS.SPACE

  debug 'spaces.marked', input

  return input
