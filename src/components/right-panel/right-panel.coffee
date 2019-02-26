React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

import CircularProgress from '@material-ui/core/CircularProgress'

Top = require './top'
Content = require './content'
Error = require './error'
Expander = require './expander'

module.exports =
observer class RightPanel extends React.Component
  @element = document.createElement 'div'
  @panel = atom.workspace.addRightPanel item: @element, visible: false

  componentWillUnmount: ->
    RightPanel.panel.destroy()
    RightPanel.element.remove()

  render: ->
    if @props.store.active
      RightPanel.panel.show()
    else
      RightPanel.panel.hide()
      return null

    loadingClass = 'loading'
    loadingClass += ' show' if @props.store.loading

    <div id="crystal-support-atom-extension-right-panel" style={{width: @props.store.rightPanelWidth}} className={"panel-active-"+@props.store.active.toString()}>
      <Expander store={@props.store} />
      <Error store={@props.store} />
      <CircularProgress className={loadingClass} />
      <Top store={@props.store} />
      <Content store={@props.store} />
    </div>
