React = require 'react'
{observer} = require 'mobx-react'

module.exports =
observer class Content extends React.Component
  constructor: (props) ->
    super(props)

  render: ->
    ActivePage = @props.store.activePage

    <div className="content padded">
      <div className="inset-panel padded">
        <ActivePage store={@props.store} />
      </div>
    </div>
