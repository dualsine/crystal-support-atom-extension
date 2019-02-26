React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

request = require 'request'
mkdirp = require 'mkdirp'
jsdom = require 'jsdom'
path = require 'path'
{ JSDOM } = jsdom
os = require 'os'
fs = require 'fs'
low = require 'lowdb'
FileSync = require 'lowdb/adapters/FileSync'
{ exec } = require('child_process')
rimraf = require 'rimraf'

module.exports =
class MacrosService
  constructor: (store) ->
    @store = store

    @processing = false

    @expandEntireFile = false

    @editor = atom.workspace.buildTextEditor()
    @buffer = @editor.getBuffer()

    atom.textEditors.setGrammarOverride(@editor, @store.crystalGrammar.scopeName)

    mobx.observe @store, "initialized", =>
      @processMacro()

  switchExpandEntireFile: =>
    @expandEntireFile = !@expandEntireFile
    @processMacro()

  getEditorElement: ->
    atom.views.getView(@editor)

  expressionInCursorCheck: (expression) ->
    splitted_location = expression.location.split(":")
    expression_location_path = splitted_location[0]
    expression_location_row = parseInt(splitted_location[1])
    expression_location_column = parseInt(splitted_location[2])
    `if (this.store.crystalSelectedPath == expression_location_path &&
        this.store.crystalActiveFileRow == expression_location_row &&
        this.store.crystalActiveFileColumn >= expression_location_column &&
        this.store.crystalActiveFileColumn <= expression_location_column + expression.source.length) {
            return true;
    }`
    false

  processMacro: ->
    return if @processing

    @processing = true
    @store.loadingOn()

    if @store.crystalEntryPath && @store.crystalSelectedPath && @store.crystalActiveFileRow && @store.crystalActiveFileColumn
      crystalSrcPath = "#{@store.dirInAtom}/libs/extractor/crystal/src"
      crystalExtractorPath = "#{@store.dirInAtom}/libs/extractor/crystal_extractor"
      command = "CRYSTAL_PATH=#{crystalSrcPath} #{crystalExtractorPath} #{@store.crystalEntryPath} #{@store.crystalSelectedPath}"

      exec(command, {cwd: path.dirname(@store.crystalEntryPath)}, (err, stdout, stderr) =>
        @store.loadingOff()
        @processing = false

        if err
          errorResponse = JSON.parse(stderr)
          @store.addError "Failed to expand macro", errorResponse.error, "Crystal Macro Expander - #{errorResponse.errorClass}"
        else
          console.log stdout
          response = JSON.parse(stdout)

          allExpressions = response["nodes"]
          console.log allExpressions
          if @expandEntireFile
            @expandedCode = fs.readFileSync(@store.crystalSelectedPath).toString()
            codeSplitted = @expandedCode.split("\n")

            for expression in allExpressions.reverse()
              # if expression.typeOfNode == "normal"
              if (typeof expression.expandedSource != 'undefined')
                locationSplitted = expression.location.split(':')
                startLine = locationSplitted[1]-1
                startColumn = locationSplitted[2]-1
                endLocationSplitted = expression.endLocation.split(':')
                endLine = endLocationSplitted[1]-1
                endColumn = endLocationSplitted[2]-1

                startPos = 0
                endPos = 0
                chars = 0
                for line, idx in codeSplitted
                  (startPos = chars + startColumn) if idx == startLine
                  (endPos = chars + endColumn + 1) if idx == endLine

                  chars += line.length+1
                # reindent
                newExpandedSource = ""
                indent = null
                for line, idx in expression.expandedSource.split("\n")
                  indent = line.match(/\w/).index+1 unless indent
                  newExpandedSource = line if idx == 0
                  if indent && idx > 0
                    newExpandedSource += "\n#{" ".repeat(indent)}#{line}"

                @expandedCode = @expandedCode.substr(0, startPos) + newExpandedSource + @expandedCode.substr(endPos)
                # @expandedCode = @expandedCode.expression.expandedSource

              # else
                # @expandedCode += expression.source
              # else if expression.typeOfNode == "compiler"
                # @expandedCode += expression.expandedSource

            #   if (typeof expression.expandedSource != 'undefined')
            #     @expandedCode += expression.expandedSource
            #   else
            #     @expandedCode += expression.
          else
            @expandedCode = "no macro found"

            for expression in allExpressions
              if @expressionInCursorCheck(expression)
                continue if (typeof expression.expandedSource == 'undefined')
                @expandedCode = expression.expandedSource

          if @oldExpandedCode != @expandedCode
            @editor.setText(@expandedCode)
            cursor = @editor.getLastCursor()
            cursor.setScreenPosition([1,1], {autoscroll: true})

          @oldExpandedCode = @expandedCode
      ) # end exec
    else
      @store.loadingOff()
      @processing = false

mobx.decorate MacrosService,
  expandEntireFile: mobx.observable

  switchExpandEntireFile: mobx.action
