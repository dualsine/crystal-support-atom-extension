React = require 'react'
{observer} = require 'mobx-react'

import Paper from '@material-ui/core/Paper'

import { withStyles } from '@material-ui/core/styles'

######################### PAPER
styles = `theme => ({
  root: {
    ...theme.mixins.gutters(),
    paddingTop: theme.spacing.unit * 2,
    paddingBottom: theme.spacing.unit * 2,
    background: "#2d2d2d"
  },
});`

observer class BadPaper extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  render: ->
    { classes } = @props
    <Paper elevation={1} className={"#{classes.root} #{@props.className}"}  tabIndex={0} margin="normal">
      {
        if @props.showTemp
          <div dangerouslySetInnerHTML={{ __html: @props.tempContent }} />
        else
          <div dangerouslySetInnerHTML={{ __html: @props.content }} />
      }
    </Paper>

module.exports = StyledPaper = withStyles(styles)(BadPaper)
