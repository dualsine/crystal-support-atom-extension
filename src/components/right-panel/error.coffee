React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

import Card from '@material-ui/core/Card'
import CardContent from '@material-ui/core/CardContent'
import Typography from '@material-ui/core/Typography'

module.exports =
observer class Error extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  render: ->
    if @props.store.errors.length
      error = @props.store.errors[0]

      setTimeout =>
        @props.store.removeOneError()
      , 5000

      <Card class="error-msg">
        <CardContent>
          <Typography color="textSecondary" gutterBottom>
            {error.type}
          </Typography>
          <Typography variant="h5" component="h2">
            {error.title}
          </Typography>
          <Typography component="p">
            {error.content}
          </Typography>
        </CardContent>
      </Card>

    else null
