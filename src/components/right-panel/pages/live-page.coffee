React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

EntryPoint = require '../../misc/entry-point'

import Switch from '@material-ui/core/Switch'
import FormControlLabel from '@material-ui/core/FormControlLabel'

module.exports =
observer class LivePage extends React.Component
  @title = 'Live'
  constructor: (props) ->
    super(props)
    @props = props

    # mobx.observe @props.store, 'forceRerenderers', =>
    #   @props.store.liveService.term.fit()

  componentDidMount: ->
    # @props.store.liveService.term.open(document.getElementById('crystal-support-atom-extension-terminal'))
    # @props.store.liveService.term.fit()
    if @props.store.liveService.active
      @props.store.liveService.process()

  render: ->
    console.log 'live page render', @props.store.liveService.content
    <div>
      <div id="crystal-support-atom-extension-terminal">
        <pre>
          {@props.store.liveService.content}
        </pre>
      </div>

      <EntryPoint store={@props.store} />

      <FormControlLabel
          control={
            <Switch
              checked={@props.store.liveService.active}
              onChange={@props.store.liveService.switchActive.bind(@props.store.liveService)}
              value="live-preview"
            />
          }
          label={if @props.store.liveService.active then "Live preview ON" else "Live preview OFF"}
        />
    </div>
