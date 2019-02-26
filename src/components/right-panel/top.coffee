React = require 'react'

Menu = require './menu'

class ClosePanelButton extends React.Component
  render: ->
    <div onClick={@props.onClick} className="close-button btn">
      x
    </div>

module.exports =
class Top extends React.Component
  constructor: (props) ->
    super(props)

  render: ->
    <div className="top">
      <h1>Crystal Support Extension</h1>
      <ClosePanelButton onClick={ @props.store.switchActive.bind(@props.store) } />
      <Menu store={ @props.store } />
    </div>
