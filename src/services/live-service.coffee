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

    # Terminal.applyAddon(fit)
    # @term = new Terminal()

    @content = ""

  switchActive: ->
    @active = !@active
    @process() if @active

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
    @content = newContent
    # @term.reset()
    # @term.write(newContent)

mobx.decorate LiveService,
  active: mobx.observable
  content: mobx.observable
  switchActive: mobx.action
  replaceContent: mobx.action
