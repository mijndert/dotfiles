var fs    = require('fs'),
    plist = require('plist'),
    CSON  = require('cson');

// Read grammar from plist
var psGrammarPlist = fs.readFileSync('vendor/PowerShell/Support/PowershellSyntax.tmLanguage', 'utf8')
var grammar = plist.parse(psGrammarPlist);

// Write out grammar as CSON
var csonGrammar = CSON.stringifySync(filterObject(grammar))
fs.writeFileSync('grammars/powershell.cson', csonGrammar, 'utf8')

// Helper function
// References: https://github.com/atom/apm/blob/c0d657af13a0da4acda6fd4be39eddded7aac1e3/src/package-converter.coffee#L73-75
function filterObject(obj) {
   delete obj.uuid
   delete obj.keyEquivalent
   return obj
}
