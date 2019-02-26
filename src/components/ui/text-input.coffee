React = require 'react'

import { withStyles } from '@material-ui/core/styles'
import TextField from '@material-ui/core/TextField'

import InputAdornment from '@material-ui/core/InputAdornment'
import IconButton from '@material-ui/core/IconButton'

module.exports =
class TextInputUnstyled extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  render: ->
    Icon = @props.icon
    <TextField
      fullWidth
      multiline={if @props.multiline then @props.multiline else false}
      id="standard-name"
      label={@props.label}
      className={"#{@props.className} native-key-bindings"}
      disabled={@props.disabled}
      value={@props.value}
      margin="normal"
      variant="outlined"
      placeholder={@props.placeholder}
      onChange={if @props.onChange then @props.onChange else null}
      InputLabelProps={{ shrink: true }}
      InputProps={@props.InputProps}
      InputProps={
        if Icon
          endAdornment: (
            <InputAdornment onClick={@props.onClickIcon} className="icon-container" position="end">
              <IconButton aria-label="Set entry point">
                <Icon />
              </IconButton>
            </InputAdornment>
          )}
    />
