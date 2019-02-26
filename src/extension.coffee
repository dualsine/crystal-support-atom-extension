{CompositeDisposable} = require 'atom'
React = require 'react'
ReactDOM = require 'react-dom'
mobx = require 'mobx'
mobx.configure enforceActions: "observed"
path = require 'path'

import { MuiThemeProvider } from '@material-ui/core/styles'

theme = require('./theme')

MultiStore = require './stores/multi-store'

MacroExpanderPage = require './components/right-panel/pages/macro-expander-page'

RightPanel = require './components/right-panel/right-panel'
StatusBar = require './components/status-bar/status-bar'

module.exports = CrystalSupportAtomExtension =
  activate: (state) ->
    console.log 'activate called'
    @multiStore = new MultiStore

    ReactDOM.render(
      <MuiThemeProvider theme={theme}>
        <RightPanel store={@multiStore} />
      </MuiThemeProvider>
      , RightPanel.element)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # atom.deserializers.add(CrystalSupportAtomExtension);
    @subscriptions.add atom.commands.add 'atom-workspace', 'crystal-support-atom-extension:toggle': => @toggle()

    this.subscriptions.add atom.workspace.observeTextEditors (textEditor) =>
      this.subscriptions.add textEditor.onDidSave () => @onSave(textEditor)

    @multiStore.setInitialized()

  deactivate: ->
    console.log 'deactivate called'
    # ReactDOM.unmountComponentAtNode(RightPanel.element)

    @subscriptions.dispose()

  toggle: ->
    @multiStore.switchActive()

  serialize: ->

  deserialize: (config) ->
    # new FancyComponent(config)

  # The returned object will be used to restore
  # or save your data by Atom.
  # The "deserializer" key must be the name of your class.
  serialize: ->
    # deserializer: 'FancyComponent'
    # data: @data
  consumeStatusBar: (statusBar) ->
    statusBar.addLeftTile
      item: StatusBar.element
      priority: -500
    ReactDOM.render(
      <MuiThemeProvider theme={theme}>
        <StatusBar store={@multiStore} />
      </MuiThemeProvider>
      , StatusBar.element)

  onSave: (textEditor) ->
    extension = null
    editor = atom.workspace.getActivePaneItem()
    if editor
      extension = path.extname(editor.buffer.file.path)

    if @multiStore.activePage == MacroExpanderPage && extension == 'cr'
      @multiStore.macrosService.processMacro()

    if atom.inDevMode() && extension == 'less'
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'dev-live-reload:reload-all')

    # if atom.inDevMode() # auto reload less file
    #   editor = atom.workspace.getActivePaneItem()
    #   if editor
    #     extension = path.extname(editor.buffer.file.path)
    #     if extension == 'less'
    #       atom.commands.dispatch(atom.views.getView(atom.workspace), 'dev-live-reload:reload-all')
