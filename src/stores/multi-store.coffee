mobx = require 'mobx'
path = require 'path'
mkdirp = require 'mkdirp'
fs = require 'fs'

DocsService = require '../services/docs-service'
MacrosService = require '../services/macros-service'

MacroExpanderPage = require '../components/right-panel/pages/macro-expander-page'
SettingsPage = require '../components/right-panel/pages/settings-page'
CrystalDocsPage = require '../components/right-panel/pages/crystal-docs-page'

module.exports =
class MultiStore
  constructor: ->
    @errors = [] # empty is undefined!
    @active = true
    @initialized = false

    @loading = false

    @workspacePath = null
    @crystalEntryPath = null
    @crystalSelectedPath = null
    @crystalActiveFileRow = null
    @crystalActiveFileColumn = null

    @pages = [ MacroExpanderPage, CrystalDocsPage, SettingsPage ]
    @activePage = MacroExpanderPage

    @dirInAtom = atom.packages.resolvePackagePath('crystal-support-atom-extension')

    atom.grammars.getGrammars().map (grammar) =>
      if grammar.id && grammar.id.toLowerCase().indexOf('crystal') > -1
        @crystalGrammar = grammar
    if !@crystalGrammar
      @addError "Failed to load Crystal grammar", "Grammar for Crystal not found - please install some", "Crystal Support Atom Extension"

    @docsService = new DocsService(@)
    @macrosService = new MacrosService(@)

    @baseRightPanelWidth = 500
    @rightPanelWidth = @baseRightPanelWidth

    @forceRerenderers = 0

    @initWorkspace()

  switchActive: ->
    @active = !@active

  setActivePage: (newPage) ->
    @activePage = newPage

  loadingOn: ->
    @loading = true

  loadingOff: ->
    @loading = false

  addError: (title, content, type) ->
    @errors.push
      title: title
      content: content
      type: type

  removeOneError: ->
    @errors.shift()

  selectApiPage: (href) =>
    @selectedApiPage = href

  setRightPanelWidth: (newWidth) ->
    @rightPanelWidth = newWidth

  forceRerender: ->
    @forceRerenderers += 1

  setInitialized: ->
    @initialized = true

################################################ WORKSPACE
  setCrystalEntryPath: ->
    editor = atom.workspace.getActivePaneItem()
    if editor
      @crystalEntryPath = editor.buffer.file.path
      @saveWorkspaceConfig()

  setCrystalSelectedPath: ->
    editor = atom.workspace.getActivePaneItem()
    if editor
      @crystalSelectedPath = editor.buffer.file.path
      cursor = atom.workspace.getActiveTextEditor().getCursorBufferPosition()
      @crystalActiveFileRow = cursor.row+1
      @crystalActiveFileColumn = cursor.column+1
      @saveWorkspaceConfig()

  loadWorkspaceConfig: ->
    if fs.existsSync @normalizedConfigPath
      workspaceConfig = fs.readFileSync @normalizedConfigPath
      if workspaceConfig
        workspaceConfig = JSON.parse(workspaceConfig)
        @crystalEntryPath = workspaceConfig.crystalEntryPath
        @crystalSelectedPath = workspaceConfig.crystalSelectedPath
        @crystalActiveFileRow = workspaceConfig.crystalActiveFileRow
        @crystalActiveFileColumn = workspaceConfig.crystalActiveFileColumn

  saveWorkspaceConfig: ->
    config = JSON.stringify(
      crystalEntryPath: @crystalEntryPath
      crystalSelectedPath: @crystalSelectedPath
      crystalActiveFileRow: @crystalActiveFileRow
      crystalActiveFileColumn: @crystalActiveFileColumn
    )
    fs.writeFileSync @normalizedConfigPath, config

  createConfigPath: ->
    if workspacePaths = atom.project.getPaths()
      if @workspacePath = workspacePaths[0]
        @normalizedConfigPath = path.resolve(@workspacePath, '.c-s-a-extension')

  initWorkspace: ->
    @createConfigPath()
    @loadWorkspaceConfig()




############################################# MOBX
mobx.decorate MultiStore,
  active: mobx.observable
  pages: mobx.observable
  activePage: mobx.observable
  apiLinks: mobx.observable
  loading: mobx.observable
  errors: mobx.observable
  crystalEntryPath: mobx.observable
  crystalSelectedPath: mobx.observable
  workspacePath: mobx.observable
  crystalActiveFileRow: mobx.observable
  crystalActiveFileColumn: mobx.observable
  rightPanelWidth: mobx.observable
  forceRerenderers: mobx.observable
  initialized: mobx.observable

  switchActive: mobx.action # switch extension on/off
  setActivePage: mobx.action
  loadingOn: mobx.action
  loadingOff: mobx.action
  addError: mobx.action
  removeOneError: mobx.action
  setCrystalEntryPath: mobx.action
  setCrystalSelectedPath: mobx.action
  loadWorkspaceConfig: mobx.action
  setRightPanelWidth: mobx.action
  forceRerender: mobx.action
  setInitialized: mobx.action
