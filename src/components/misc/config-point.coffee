React = require 'react'
{observer} = require 'mobx-react'

TextInput = require '../ui/text-input'

module.exports =
observer class ConfigPoint extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  render: ->
    <TextInput
      disabled={true}
      label="Current workspace config location"
      value={@props.store.normalizedConfigPath}
      multiline={true}
    />
