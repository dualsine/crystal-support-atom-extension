React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

ReactHtmlParser = require('react-html-parser').default

import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'
import Typography from '@material-ui/core/Typography'

observer class Progress extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

    @interval = null
    @percent = 0
    @max = 200


  componentDidMount: ->
    clearInterval()
    @interval = setInterval =>
      if @props.reversePercents
        @decrease()
      else
        @increase()

      if @percent >= @max
        @clearInterval()
        @props.store.removeOneError()
    , 32

  clearInterval: =>
    clearInterval @interval

  reset: ->
    @percent = 0

  decrease: =>
    return if @percent < 1
    @percent -= @percent / 20

  increase: =>
    @percent += 1

  render: ->
    <div className='progress-container'>
      <progress className='progress-bar' max={@max} value={@percent}></progress>
    </div>

module.exports =
observer class Error extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

    @reversePercents = false

    @progressChild = React.createRef()

  hoverOn: ->
    @reversePercents = true

  hoverOff: ->
    @reversePercents = false

  render: ->
    if @props.store.errors.length
      error = @props.store.errors[0]

      <Card id="crystal-support-atom-extension-error" onMouseEnter={@hoverOn.bind(@)} onMouseLeave={@hoverOff.bind(@)}>
        <div className="close-button btn" onClick={ => @props.store.removeOneError()}>x</div>
        <CardContent className="inner-error">
          <Typography color="textSecondary" gutterBottom>
            {error.type}
          </Typography>
          <Typography variant="h5" component="h2">
            { ReactHtmlParser(error.title) }
          </Typography>
          <Typography component="pre">
            { ReactHtmlParser(error.content) }
          </Typography>
        </CardContent>
        <Progress ref={@progressChild} store={@props.store} reversePercents={@reversePercents} />
      </Card>

    else null



mobx.decorate Error,
  reversePercents: mobx.observable

  hoverOn: mobx.action
  hoverOff: mobx.action

mobx.decorate Progress,
  percent: mobx.observable

  reset: mobx.action
  increase: mobx.action
  decrease: mobx.action
