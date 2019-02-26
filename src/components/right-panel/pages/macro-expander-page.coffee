React = require 'react'
{observer} = require 'mobx-react'
mobx = require 'mobx'

TextInput = require '../../ui/text-input'

import Switch from '@material-ui/core/Switch'
import InputIcon from '@material-ui/icons/Input'
import AdjustIcon from '@material-ui/icons/Adjust'
import FormControlLabel from '@material-ui/core/FormControlLabel'

module.exports =
observer class MacroExpanderPage extends React.Component
  @title = "Macro Expander"

  constructor: (props) ->
    super(props)
    @props = props

    @editorRef = React.createRef()

    mobx.observe @props.store, "crystalSelectedPath", (change) =>
      @props.store.macrosService.processMacro()
    mobx.observe @props.store, "crystalActiveFileRow", (change) =>
      @props.store.macrosService.processMacro()
    mobx.observe @props.store, "crystalActiveFileColumn", (change) =>
      @props.store.macrosService.processMacro()
    mobx.observe @props.store, "crystalEntryPath", (change) =>
      @props.store.macrosService.processMacro()

  componentDidMount: ->
    @editorRef.current.appendChild @props.store.macrosService.getEditorElement()

  componentWillUnmount: ->
    clearInterval @macroInterval

  render: ->
    # create entryPath string from raw path
    entryPath = ""
    if @props.store.crystalEntryPath
      entryPath = @props.store.crystalEntryPath.replace(@props.store.workspacePath, "").replace("/","")

    # create selectedPath string from raw path
    selectedPath = ""
    if @props.store.crystalSelectedPath
      selectedPath = @props.store.crystalSelectedPath.replace(@props.store.workspacePath, "").replace("/","")
    if @props.store.crystalActiveFileRow && @props.store.crystalActiveFileColumn
      selectedPath += "\nline: #{@props.store.crystalActiveFileRow}\ncolumn: #{@props.store.crystalActiveFileColumn}"

    <div>
      <div ref={@editorRef} className="macro-editor"></div>

      <TextInput
        disabled={true}
        label="Crystal entry point"
        value={entryPath}
        icon={InputIcon}
        onClickIcon={@props.store.setCrystalEntryPath.bind(@props.store)}
        />
      <TextInput
        disabled={true}
        label="Selected point to expand macro"
        value={selectedPath}
        icon={AdjustIcon}
        onClickIcon={@props.store.setCrystalSelectedPath.bind(@props.store)}
        multiline={true}
        className='refresh-btn'
        />
      <FormControlLabel
          control={
            <Switch
              checked={@props.store.macrosService.expandEntireFile}
              onChange={@props.store.macrosService.switchExpandEntireFile}
              value="entire-file"
            />
          }
          label="Show entire file"
        />
    </div>
