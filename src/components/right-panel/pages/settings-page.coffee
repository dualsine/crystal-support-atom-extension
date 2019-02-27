React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

ConfigPoint = require '../../misc/config-point'

module.exports =
observer class SettingsPage extends React.Component
  @title = "Settings"

  constructor: (props) ->
    super(props)

  render: ->
    <div>
      <ConfigPoint store={@props.store} />
      <button className="btn" onClick={(ev) => @props.store.docsService.refresh(ev)}>
        Refresh Api (download new checkout from github)
      </button>
    </div>
