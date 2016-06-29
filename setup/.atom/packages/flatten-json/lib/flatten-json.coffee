{CompositeDisposable} = require 'atom'

module.exports = FlattenJson =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'flatten-json:flatten': => @flatten()
    @subscriptions.add atom.commands.add 'atom-workspace', 'flatten-json:unflatten': => @flatten(mode:"unflatten")

  deactivate: ->
    @subscriptions.dispose()

  flatten: ({mode} = {mode: "flatten"})->

    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    text = editor.getSelectedText() or editor.getText()

    convert =
      flatten: require('flat')
      unflatten: require('flat').unflatten

    try
      text = JSON.stringify(
        convert[mode](JSON.parse(text)), null, 2)
    catch error
      return console.error(error)

    editor.setText(text)
