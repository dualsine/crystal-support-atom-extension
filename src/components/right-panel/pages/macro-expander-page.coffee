React = require 'react'
{observer} = require 'mobx-react'
mobx = require 'mobx'

TextInput = require '../../ui/text-input'
BottomMacroControls = require '../../misc/bottom-macro-controls'

module.exports =
observer class MacroExpanderPage extends React.Component
  @title = "Macro Expander"

  constructor: (props) ->
    super(props)
    @props = props

    @editorRef = React.createRef()

  componentDidMount: ->
    @editorRef.current.appendChild @props.store.macrosService.getEditorElement()
    @props.store.macrosService.process()

  componentWillUnmount: ->
    clearInterval @macroInterval

  render: ->
    <div>
      <div ref={@editorRef} className="macro-editor"></div>

      <BottomMacroControls store={@props.store} />
    </div>
