React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

import Tabs from '@material-ui/core/Tabs'
import Tab from '@material-ui/core/Tab'



module.exports =
observer class Menu extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

  menuClick: (page) =>
    if page != @props.store.activePage
      @props.store.removeOneError()
      @props.store.setActivePage page

  render: =>
    @props.store.forceRerenderers # this causes rerender on demand

    classes = @props.classes

    <Tabs
      value={@props.store.pages.indexOf(@props.store.activePage)}
      indicatorColor="primary"
      textColor="primary"
      centered
    >
      {
        for page, idx in @props.store.pages
          <Tab
            key={idx}
            style={{minWidth: 125, width: 125}}
            className={ if @props.store.activePage == page then "selected" else "" }
            label={page.title}
            onClick={@menuClick.bind(@, page)}
          />
      }
    </Tabs>
