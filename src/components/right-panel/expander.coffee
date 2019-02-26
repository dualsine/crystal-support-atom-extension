React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

module.exports =
class Expander extends React.Component
  constructor: (props) ->
    super(props)
    @props = props

    @down = false
    @baseX = null
    @rerenderInterval = null

    document.addEventListener 'mousedown', (ev) =>
      if ev.target == document.getElementById('crystal-support-atom-extension-right-panel-expander')
        @setButtonDown()
        @baseX = ev.pageX
        @rightPanelBaseWidth = document.getElementById('crystal-support-atom-extension-right-panel').clientWidth
        @max = document.querySelector('atom-workspace-axis.vertical').clientWidth+@rightPanelBaseWidth
        @min = @props.store.baseRightPanelWidth - 40

        @rerenderInterval = setInterval =>
          @props.store.forceRerender()
        , 100

    document.addEventListener 'mouseup', (ev) =>
      @setButtonUp()
      clearInterval(@rerenderInterval)
      @props.store.forceRerender()

    document.addEventListener 'mousemove', (ev) =>
      if @down
        if @baseX > ev.pageX
          newWidth = @rightPanelBaseWidth + (@baseX-ev.pageX)
          newWidth = @max if newWidth > @max
          @props.store.setRightPanelWidth(newWidth)
        else
          newWidth = @rightPanelBaseWidth - (ev.pageX-@baseX)
          newWidth = @min if newWidth < @min
          @props.store.setRightPanelWidth(newWidth)

  setButtonDown: -> @down = true
  setButtonUp: -> @down = false

  set500: ->
    @props.store.setRightPanelWidth(@props.store.baseRightPanelWidth)

  render: ->
    <React.Fragment>
      <div id="crystal-support-atom-extension-right-panel-expander" />
    </React.Fragment>
