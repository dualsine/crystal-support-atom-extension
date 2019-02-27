# React = require 'react'
mobx = require 'mobx'
# {observer} = require 'mobx-react'

# request = require 'request'
# mkdirp = require 'mkdirp'
# jsdom = require 'jsdom'
path = require 'path'
# { JSDOM } = jsdom
# os = require 'os'
# fs = require 'fs'
# low = require 'lowdb'
# FileSync = require 'lowdb/adapters/FileSync'
{ exec } = require('child_process')
# rimraf = require 'rimraf'
# import { Terminal } from 'xterm'
# import * as fit from 'xterm/lib/addons/fit/fit'

module.exports =
class LiveService
  constructor: (store) ->
    @store = store

    @active = false
    @processing = false

    @content = ""

  setActive: (bool) ->
    @active = bool

  switchActive: ->
    @active = !@active
    @process() if @active

    @store.saveWorkspaceConfig()

  process: ->
    return if @processing || !@active

    @processing = true
    @store.loadingOn()

    if @store.crystalEntryPath
      command = "crystal #{@store.crystalEntryPath}"

      exec(command, {cwd: path.dirname(@store.crystalEntryPath)}, (err, stdout, stderr) =>
        @store.loadingOff()
        @processing = false

        if err
          @replaceContent(err + "\n" + stderr)
        else
          @replaceContent(stdout)
      ) # end of exec
    else
      @store.loadingOff()
      @processing = false

  replaceContent: (newContent) ->
    # console.log 'new content', newContent

    @content = @escapeColors(newContent)
    # @term.reset()
    # @term.write(newContent)

  escapeColors: (content) ->
    return content if content.length > 40960

    newContent = ""
    content = content.split /\x1B\[([\d]+);?[\d]?m/g
    for part in content
      if part.length < 3
        number = parseInt(part)
        if number >= 0
          newContent += @getColorAttribute(number)
      else
        newContent += part
    newContent

  getColorAttribute: (color) ->
    normalizedColor = 'inherited'
    if color == 0
      return '</span>' # reset color attribute
    else if color == 30
      normalizedColor = 'black'
    else if color == 31
      normalizedColor = 'red'
    else if color == 32
      normalizedColor = 'green'
    else if color == 33
      normalizedColor = 'yellow'
    else if color == 34
      normalizedColor = 'blue'
    else if color == 35
      normalizedColor = 'magenta'
    else if color == 36
      normalizedColor = 'cyan'
    else if color == 37
      normalizedColor = '#D3D3D3'

    "<span style=\"color: #{normalizedColor};\">"

mobx.decorate LiveService,
  active: mobx.observable
  content: mobx.observable
  switchActive: mobx.action
  replaceContent: mobx.action
  setActive: mobx.action
