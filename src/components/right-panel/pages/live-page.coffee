React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

ReactHtmlParser = require('react-html-parser').default

EntryPoint = require '../../misc/entry-point'

import Switch from '@material-ui/core/Switch'
import FormControlLabel from '@material-ui/core/FormControlLabel'

module.exports =
observer class LivePage extends React.Component
  @title = 'Live'
  constructor: (props) ->
    super(props)
    @props = props

  componentDidMount: ->
    if @props.store.liveService.active
      @props.store.liveService.process()

  render: ->
    <div>
      <div id="crystal-support-atom-extension-terminal">
        <div className="pre native-key-bindings" tabIndex="1">
          { ReactHtmlParser(@props.store.liveService.content) }
        </div>
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
