React = require 'react'
{observer} = require 'mobx-react'
mobx = require 'mobx'

TextInput = require '../ui/text-input'
import AdjustIcon from '@material-ui/icons/Adjust'

module.exports =
observer class SelectedPoint extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

    mobx.observe @props.store, "crystalSelectedPath", (change) =>
      @props.store.macrosService.process()
    mobx.observe @props.store, "crystalActiveFileRow", (change) =>
      @props.store.macrosService.process()
    mobx.observe @props.store, "crystalActiveFileColumn", (change) =>
      @props.store.macrosService.process()

  render: ->
    # create selectedPath string from raw path
    selectedPath = ""
    if @props.store.crystalSelectedPath
      selectedPath = @props.store.crystalSelectedPath.replace(@props.store.workspacePath, "").replace("/","")
    if @props.store.crystalActiveFileRow && @props.store.crystalActiveFileColumn
      selectedPath += "\nline: #{@props.store.crystalActiveFileRow}\ncolumn: #{@props.store.crystalActiveFileColumn}"

    <TextInput
      disabled={true}
      label="Selected point to expand macro"
      value={selectedPath}
      icon={AdjustIcon}
      onClickIcon={@props.store.setCrystalSelectedPath.bind(@props.store)}
      multiline={true}
      className='refresh-btn'
      />
