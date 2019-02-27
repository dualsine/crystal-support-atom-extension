React = require 'react'
{observer} = require 'mobx-react'
mobx = require 'mobx'

TextInput = require '../ui/text-input'

EntryPoint = require './entry-point'
SelectedPoint = require './selected-point'

import Switch from '@material-ui/core/Switch'
import AdjustIcon from '@material-ui/icons/Adjust'
import AnnouncementIcon from '@material-ui/icons/Announcement'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Fab from '@material-ui/core/Fab'
import Table from '@material-ui/core/Table'
import TableCell from '@material-ui/core/TableCell'
import TableHead from '@material-ui/core/TableHead'
import TableRow from '@material-ui/core/TableRow'
import TableBody from '@material-ui/core/TableBody'

module.exports =
observer class BottomControls extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  render: ->
    <div className="bottom-controls">
      <EntryPoint store={@props.store} />
      <SelectedPoint store={@props.store} />
      <Table>
        <TableBody>
          <TableRow>
            <TableCell style={{maxWidth: '100px', borderBottom: 'none'}}>
              <FormControlLabel
                control={
                  <Switch
                    checked={@props.store.macrosService.active}
                    onChange={@props.store.macrosService.switchActive}
                    value="macro-expander"
                  />
                }
                label={if @props.store.macrosService.active then "Active" else "Off"}
              />
            </TableCell>
            <TableCell style={{width: '160px', maxWidth: '160px', borderBottom: 'none'}}>
              <FormControlLabel
                  control={
                    <Switch
                      checked={@props.store.macrosService.expandEntireFile}
                      onChange={@props.store.macrosService.switchExpandEntireFile}
                      value="entire-file"
                    />
                  }
                  label={if @props.store.macrosService.expandEntireFile then "Show entire file" else "Show only selected macro"}
                />
            </TableCell>
            <TableCell style={{borderBottom: 'none'}}>
              <Fab disabled={if @props.store.lastError then false else true} hidden variant="extended" onClick={@props.store.showLastError} aria-label="Show last error" className="last-error">
                <AnnouncementIcon style={{marginRight: '10px'}} />
                Last error
              </Fab>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </div>
