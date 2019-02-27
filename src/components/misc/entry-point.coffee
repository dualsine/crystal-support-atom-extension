React = require 'react'
{observer} = require 'mobx-react'
mobx = require 'mobx'

TextInput = require '../ui/text-input'
import InputIcon from '@material-ui/icons/Input'

module.exports =
observer class EntryPoint extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

    mobx.observe @props.store, "crystalEntryPath", (change) =>
      @props.store.macrosService.process()

  render: ->
    # create entryPath string from raw path
    entryPath = ""
    if @props.store.crystalEntryPath
      entryPath = @props.store.crystalEntryPath.replace(@props.store.workspacePath, "").replace("/","")

    <TextInput
      disabled={true}
      label="Crystal entry point"
      value={entryPath}
      icon={InputIcon}
      onClickIcon={@props.store.setCrystalEntryPath.bind(@props.store)}
      />
