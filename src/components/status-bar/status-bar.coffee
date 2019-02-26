React = require 'react'
{observer} = require 'mobx-react'

module.exports =
observer class StatusBar extends React.Component
  @element = document.createElement 'div'
  constructor: (props) ->
    super(props)

  render: ->
    <div id="crystal-support-atom-extension-status-bar" onClick={@props.store.switchActive.bind(@props.store)}>
      CSE { if @props.store.active then "ON" else "OFF" }
    </div>
