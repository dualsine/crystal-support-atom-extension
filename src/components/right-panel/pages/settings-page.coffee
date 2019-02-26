React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

TextInput = require '../../ui/text-input'

module.exports =
observer class SettingsPage extends React.Component
  @title = "Settings"

  constructor: (props) ->
    super(props)

  render: ->
    <div>
      <TextInput
        disabled={true}
        label="Current workspace config location"
        value={@props.store.normalizedConfigPath}
        />
      <button className="btn" onClick={(ev) => @props.store.docsService.refresh(ev)}>
        Refresh Api (download new checkout from github)
      </button>
    </div>
