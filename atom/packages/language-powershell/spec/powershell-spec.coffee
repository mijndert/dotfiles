path = require 'path'
fs = require 'fs'

describe "PowerShell grammar", ->

  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-powershell")
    this.addMatchers
      toHaveScopes: (scopes) ->
        notText = if @isNot then "not" else ""
        this.message = (expected) =>
          "Expected token \"#{@actual.value}\" to #{notText} have scopes [#{expected}]. Instead found: [#{@actual.scopes.toString()}]"

        allScopesPresent = scopes.every (scope) =>
          return scope in @actual.scopes

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.powershell')

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.powershell"

  describe "comments", ->
    it "parses comments at the end of lines", ->
      {tokens} = grammar.tokenizeLine("$foo = 'bar' # a trailing comment")
      expect(tokens[0]).toEqual value: "$", scopes: ["source.powershell", "keyword.other.powershell"]
      expect(tokens[1]).toEqual value: "foo", scopes: ["source.powershell", "variable.other.readwrite.powershell"]
      expect(tokens[2]).toEqual value: " ", scopes: ["source.powershell"]
      expect(tokens[3]).toEqual value: "=", scopes: ["source.powershell", "keyword.operator.assignment.powershell"]
      expect(tokens[4]).toEqual value: " ", scopes: ["source.powershell"]
      expect(tokens[5]).toEqual value: "'", scopes: ["source.powershell", "string.quoted.single.powershell"]
      expect(tokens[6]).toEqual value: "bar", scopes: ["source.powershell", "string.quoted.single.powershell"]
      expect(tokens[7]).toEqual value: "'", scopes: ["source.powershell", "string.quoted.single.powershell"]
      expect(tokens[8]).toEqual value: " ", scopes: ["source.powershell"]
      expect(tokens[9]).toEqual value: "#", scopes: ["source.powershell", "comment.line.number-sign.powershell"]
      expect(tokens[10]).toEqual value: " a trailing comment", scopes: ["source.powershell", "comment.line.number-sign.powershell"]

    it "parses comments at the beginning of lines", ->
      {tokens} = grammar.tokenizeLine("# a leading comment")
      expect(tokens[0]).toEqual value: "#", scopes: ["source.powershell", "comment.line.number-sign.powershell"]
      expect(tokens[1]).toEqual value: " a leading comment", scopes: ["source.powershell", "comment.line.number-sign.powershell"]

  describe "start of variable", ->
    it "parses the dollar sign at the beginning of a variable separately", ->
      {tokens} = grammar.tokenizeLine("$var")
      expect(tokens[0]).toEqual value: "$", scopes: ["source.powershell", "keyword.other.powershell"]
      expect(tokens[1]).toEqual value: "var", scopes: ["source.powershell", "variable.other.readwrite.powershell"]

  describe "Double-quoted strings", ->
    describe "String with content", ->
      tokens = null

      beforeEach ->
        {tokens} = grammar.tokenizeLine("\"Hi there! and welcome to 'string-making': 101.\"")

      it "should mark all parts of the string with the same scope", ->
        for token in tokens
          expect(token).toHaveScopes ["string.quoted.double.powershell"]

      it "should tokenize the opening double-quote", ->
        expect(tokens[0].value).toEqual "\""
        expect(tokens[0]).toHaveScopes ["string.quoted.double.powershell"]

      it "should tokenize content of the string", ->
        expect(tokens[1].value).toEqual "Hi there! and welcome to 'string-making': 101."

      it "should tokenize the closing double-quote", ->
        expect(tokens[2].value).toEqual "\""
        expect(tokens[2]).toHaveScopes ["string.quoted.double.powershell"]

    describe "Empty string", ->
      tokens = null

      beforeEach ->
        {tokens} = grammar.tokenizeLine("\"\"")

      it "should mark all parts of the string with the same scope", ->
        for token in tokens
          expect(token).toHaveScopes ["string.quoted.double.powershell"]

    describe "Variables within a string", ->
      tokens = null
      expectedDollarSignScopes = ["keyword.other.powershell"]

      beforeEach ->
        {tokens} = grammar.tokenizeLine("\"Hi there $name `$bob\"")

      it "should mark all parts of the string with the same scope", ->
        for token in tokens
          expect(token).toHaveScopes ["source.powershell", "string.quoted.double.powershell"]

      it "should tokenize content", ->
        expect(tokens[1].value).toEqual "Hi there "

      it "should tokenize the beginning of variable names as embedded punctuation", ->
        expect(tokens[2].value).toEqual "$"
        expect(tokens[2]).toHaveScopes expectedDollarSignScopes

      it "should tokenize variable names", ->
        expect(tokens[3].value).toEqual "name"
        expect(tokens[3]).toHaveScopes ["source.powershell", "string.quoted.double.powershell", "variable.other.readwrite.powershell"]

      it "should not tokenize as a variable when leading $ has been escaped", ->
        expect(tokens[5].value).toEqual "`$"
        expect(tokens[5]).toHaveScopes ["source.powershell", "string.quoted.double.powershell", "constant.character.escape.powershell"]
        expect(tokens[5]).not.toHaveScopes ["source.powershell", "embedded.variable.other.powershell"]

        expect(tokens[6].value).toEqual "bob"
        expect(tokens[6]).not.toHaveScopes ["source.powershell", "embedded.variable.other.powershell"]

  describe "Keywords", ->
    describe "Block keywords", ->
      # TODO: Add "sequence", "workflow" to keywords
      keywords = [
        "begin", "data", "dynamicparam", "end", "inlinescript", "parallel", "process"
      ]

      it "tokenizes keywords", ->
        for keyword in keywords
          {tokens} = grammar.tokenizeLine keyword
          expect(tokens[0].value).toEqual keyword
          expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

    describe "Flow keywords", ->
      describe "If-else statements", ->
        tokens = null

        beforeEach ->
          {tokens} = grammar.tokenizeLine("if($answer.length -lt 10) { echo $answer } elseif($answer.length -lt 100) { echo \"You talk a lot\" } else { echo \"?\"}")

        it "should highlight 'if'", ->
          expect(tokens[0]).toEqual value: "if", scopes: ["source.powershell","keyword.control.powershell"]

        it "should highlight 'elseif'", ->
          expect(tokens[14]).toEqual value: "elseif", scopes: ["source.powershell","keyword.control.powershell"]

        it "should highlight 'else'", ->
          expect(tokens[29]).toEqual value: "else", scopes: ["source.powershell","keyword.control.powershell"]

      describe "Do-until statements", ->
        tokens = null

        beforeEach ->
          {tokens} = grammar.tokenizeLine("do { echo $i; $i += 1 } until($i -gt 100)")

        it "should highlight 'do'", ->
          expect(tokens[0]).toEqual value: "do", scopes: ["source.powershell","keyword.control.powershell"]
        it "should highlight 'until'", ->
          expect(tokens[13]).toEqual value: "until", scopes: ["source.powershell","keyword.control.powershell"]

      describe "'For' statements", ->
        tokens = null

        beforeEach ->
          {tokens} = grammar.tokenizeLine("for($i=0;i<10;$i++) { echo $i }")

        it "should highlight 'for'", ->
          expect(tokens[0]).toEqual value: "for", scopes: ["source.powershell","keyword.control.powershell"]

      describe "'ForEach' statements", ->
        tokens = null

        beforeEach ->
          {tokens} = grammar.tokenizeLine("foreach($i in $array) { echo $i }")

        it "should tokenize 'ForEach'", ->
          expect(tokens[0].value).toEqual "foreach"
          expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

        it "should tokenize 'in'", ->
          expect(tokens[5].value).toEqual "in"
          expect(tokens[5]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

      describe "Try-Catch-Finally statements", ->
        tokens = null

        beforeEach ->
          {tokens} = grammar.tokenizeLine("try { throw \"FAIL\" } catch [System.IO.IOException] { Get-OutOfTrouble } finally { Get-OutOfTown }")

        it "should tokenize 'Try'", ->
          expect(tokens[0].value).toEqual "try"
          expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

        it "should tokenize 'Catch'", ->
          expect(tokens[8].value).toEqual "catch"
          expect(tokens[8]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

        it "should tokenize 'Finally'", ->
          expect(tokens[36].value).toEqual "finally"
          expect(tokens[36]).toHaveScopes ["source.powershell", "keyword.control.powershell"]

    describe "Logical operator keywords", ->
      logicalOperators = [ "-and", "-or", "-xor", "-not", "-eq", "-lt", "-gt", "-le", "-ge", "-ne" ]

      it "tokenizes logical operators", ->
        for operator in logicalOperators
          {tokens} = grammar.tokenizeLine operator
          expect(tokens[0]).toEqual value: operator, scopes: ["source.powershell","keyword.operator.logical.powershell"]

    describe "Unary operators", ->
      unaryOperators = ["!"]

      it "tokenizes unary operators", ->
        for operator in unaryOperators
          {tokens} = grammar.tokenizeLine operator
          expect(tokens[0]).toEqual value: operator, scopes: ["source.powershell","keyword.operator.unary.powershell"]

    describe "Bitwise operator keywords", ->
      # TODO: add `-shl` and `-sh` upon resolution of SublimeText/PowerShell#101
      bitwiseOperators = [ "-bAnd", "-bOr", "-bXor", "-bNot" ]

      it "tokenizes bitwise operators", ->
        for operator in bitwiseOperators
          {tokens} = grammar.tokenizeLine operator
          expect(tokens[0]).toEqual value: operator, scopes: ["source.powershell","keyword.operator.bitwise.powershell"]

    describe "Comparison operator keywords", ->
      comparisonOperators = [
        "-notlike", "-like", "-match", "-notmatch", "-contains", "-notcontains",
        "-in", "-notin", "-replace"
      ]

      it "tokenizes comparison operators", ->
        for operator in comparisonOperators
          {tokens} = grammar.tokenizeLine operator
          expect(tokens[0]).toEqual value: operator, scopes: ["source.powershell","keyword.operator.comparison.powershell"]

      it "tokenizes comparison operators regardless of case", ->
        for operator in comparisonOperators
          {tokens} = grammar.tokenizeLine operator.toUpperCase()
          expect(tokens[0]).toEqual value: operator.toUpperCase(), scopes: ["source.powershell","keyword.operator.comparison.powershell"]

      it "tokenizes comparison operators when prepended with a case sensitivity marker", ->
        for operator in comparisonOperators
          insensitiveOperator = operator.replace('-', '-i')
          {tokens} = grammar.tokenizeLine insensitiveOperator
          expect(tokens[0]).toEqual value: insensitiveOperator, scopes: ["source.powershell","keyword.operator.comparison.powershell"]

          sensitiveOperator = operator.replace('-', '-c')
          {tokens} = grammar.tokenizeLine sensitiveOperator
          expect(tokens[0]).toEqual value: sensitiveOperator, scopes: ["source.powershell","keyword.operator.comparison.powershell"]

      it "will not tokenize the operators if there's more characters", ->
        for operator in comparisonOperators
          operatorPlus = operator + "ual"
          {tokens} = grammar.tokenizeLine operatorPlus
          expect(tokens.length).toBe(2)
          expect(tokens[0]).not.toHaveScopes ["source.powershell", "keyword.operator.comparison.powershell"]
          expect(tokens[1]).not.toHaveScopes ["source.powershell", "keyword.operator.comparison.powershell"]

  # Automatic variables. Ref: https://technet.microsoft.com/en-us/library/hh847768.aspx
  # Skip while things settle out on the parent grammar: SublimeText/PowerShell#103
  xdescribe "Automatic variables", ->
    automaticVariables = [
      "$$", "$?", "$^", "$_",
      "$Args",
      "$ConsoleFileName",
      "$Event", "$EventArgs", "$EventSubscriber", "$ExecutionContext",
      "$false", "$ForEach",
      "$Host", "$Home",
      "$Input",
      "$LastExitCode",
      "$Matches", "$MyInvocation",
      "$NestedPromptLevel", "$null",
      "$OFS",
      "$PID", "$Profile", "$PSBoundParameters", "$PSCmdlet", "$PSCommandPath",
      "$PSCulture", "$PSDebuggingContext", "$PSHome", "$PSItem", "$PSScriptRoot",
      "$PSSenderInfo", "$PSUICulture", "$PSVersionTable", "$Pwd",
      "$Sender", "$ShellID", "$StackTrace",
      "$This", "$true"
    ]

    it "tokenizes automatic variables", ->
      for automaticVariable in automaticVariables
        {tokens} = grammar.tokenizeLine automaticVariable
        expect(tokens[0].value).toEqual "$"
        expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.other.powershell"]
        if tokens[1]?
          expect(tokens[1].value).toEqual automaticVariable.substr(1)
          expect(tokens[1]).toHaveScopes ["source.powershell", "support.constant.automatic.powershell"]

  describe "Escaped characters", ->
    # TODO: add `--%` upon resolution of SublimeText/PowerShell#104
    escapedCharacters = [
      "`n", "`\"", "`\'", "`a", "`b", "`r", "`t", "`f", "`0", "`v", "``"
    ]

    it "tokenizes escaped characters", ->
      for character in escapedCharacters
        {tokens} = grammar.tokenizeLine character
        expect(tokens[0].value).toEqual character
        expect(tokens[0]).toHaveScopes ["source.powershell", "constant.character.escape.powershell"]

  describe "Constants", ->
    describe "Constant values in kilobytes, megabytes, and gigabytes", ->
      constants = [ "10GB", "53gb", "12MB", "128mb", "1000KB", "1200kb" ]

      it "tokenizes constant value in bytes", ->
        for constant in constants
          {tokens} = grammar.tokenizeLine constant
          for token in tokens
            expect(token).toHaveScopes ["source.powershell", "constant.numeric.scientific.powershell"]

    describe "Constant float values", ->
      constants = [
        "1.0", "0.89324", "123124235.2385923234"
      ]

      scientificConstants = [
        "3.23e24", "2.33e-12", "9.11e+21", "21e6", "7e-12", "12e+24"
      ]

      it "tokenizes constant float values", ->
        for constant in constants
          {tokens} = grammar.tokenizeLine constant
          expect(tokens[0].value).toEqual constant
          expect(tokens[0]).toHaveScopes ["source.powershell", "support.constant.powershell", "constant.numeric.scientific.powershell"]

      it "tokenizes scientific numbers", ->
        for scientificConstant in scientificConstants
          {tokens} = grammar.tokenizeLine scientificConstant
          expect(tokens[0]).toHaveScopes ["source.powershell", "support.constant.powershell", "constant.numeric.scientific.powershell"]
          expect(tokens[1].value.substr(0, 1)).toBe "e"
          expect(tokens[1]).toHaveScopes ["source.powershell", "constant.numeric.scientific.powershell", "keyword.operator.math.powershell"]
          expect(tokens[2]).toHaveScopes ["source.powershell", "support.constant.powershell", "constant.numeric.scientific.powershell"]

    describe "Constant hexadecimal values", ->
      constants = [ "0x1234", "0x1FF2", "0xff2e" ]

      it "tokenizes constant hexadecimal integer values", ->
        for constant in constants
          {tokens} = grammar.tokenizeLine constant
          expect(tokens[0].value).toEqual "0x"
          expect(tokens[0]).toHaveScopes ["source.powershell", "constant.numeric.hexadecimal.powershell", "keyword.operator.math.powershell"]
          expect(tokens[1].value).toEqual constant.substr(2)
          expect(tokens[1]).toHaveScopes ["source.powershell", "constant.numeric.hexadecimal.powershell", "support.constant.powershell"]

  # TODO: Fix these later. They seem to highlight correctly but the tests are weird
  xdescribe "Types", ->
    types = [ "[string]", "[Int32]", "[System.Diagnostics.Process]"]

    it "tokenizes type annotations", ->
      for type in types
        {tokens} = grammar.tokenizeLine type
        expectedType = type.substr(1, type.length - 2)
        expect(tokens[0].value).toEqual "["
        expect(tokens[0]).toHaveScopes ["source.powershell", "storage.type.powershell", "punctuation.storage.type.begin.powershell"]
        expect(tokens[1].value).toEqual expectedType
        expect(tokens[1]).toHaveScopes ["source.powershell", "storage.type.powershell"]
        expect(tokens[2].value).toEqual "]"
        expect(tokens[2]).toHaveScopes ["source.powershell", "punctuation.storage.type.end.powershell"]

  describe "Escape characters", ->

    it "escapes variables", ->
      {tokens} = grammar.tokenizeLine("`$a")
      expect(tokens[0].value).toBe "`$"
      expect(tokens[0]).toHaveScopes ["source.powershell", "constant.character.escape.powershell"]

    it "escapes any character", ->
      {tokens} = grammar.tokenizeLine("`_")
      expect(tokens[0].value).toBe '`'
      expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.operator.other.powershell"]

    it "escapes single quotes within a string", ->
      {tokens} = grammar.tokenizeLine("$command = \'.\\myfile.ps1 -param1 `\'$myvar`\' -param2 whatever\'")
      expect(tokens[7].value).toBe '\''
      expect(tokens[7]).toHaveScopes ["source.powershell", "string.quoted.single.powershell"]

    it "escapes double quotes within a string", ->
      {tokens} = grammar.tokenizeLine("$command = \".\\myfile.ps1 -param1 `\"$myvar`\" -param2 whatever\"")
      expect(tokens[7].value).toBe '`"'
      expect(tokens[7]).toHaveScopes ["source.powershell", "constant.character.escape.powershell", "string.quoted.double.powershell"]

  describe "Line continuations", ->

    it "considers a backtick followed by a newline as a line continuation", ->
      {tokens} = grammar.tokenizeLine("`\n")
      expect(tokens[0].value).toEqual("`")
      expect(tokens[0]).toHaveScopes ["source.powershell", "keyword.operator.other.powershell"]

  describe "indentation", ->
    editor = null

    beforeEach ->
      editor = atom.workspace.buildTextEditor()
      editor.setGrammar(grammar)

    expectPreservedIndentation = (text) ->
      editor.setText(text)
      editor.autoIndentBufferRows(0, text.split("\n").length - 1)
      expect(editor.getText()).toBe text

    it "preserves indentation", ->
      indentFixturesFolder = path.join(__dirname, "fixtures", "indents")

      fixtures = for fixture in fs.readdirSync(indentFixturesFolder)
        fs.readFileSync(path.join(indentFixturesFolder, fixture), 'utf8')

      for fixture in fixtures
        expectPreservedIndentation fixture
