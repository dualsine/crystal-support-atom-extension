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
class DocsService
  constructor: (store) ->
    @store = store

    @apiLink = 'https://crystal-lang.org/api/'
    @apiLinks = [] # empty is undefined!

    @apiPath = path.resolve(@store.dirInAtom, "crystal-api")

    @dbPath = path.resolve(@store.dirInAtom, 'api-db.json')

    document.addEventListener 'mousedown', @openLink

    @openDb()
    unless this.db.get('links').value()
      @clearDb()

    @loadLinksFromDb()

    @getVersion()

  openLink: (ev) =>
    if ev.target.getAttribute('data-crystal-support-atom-extension') == 'document-link'
      lineOffset = ev.target.getAttribute('data-column')
      href = ev.target.getAttribute('href')
      atom.workspace.open(href, {initialLine: lineOffset-1, initialColumn: 0}).then (editor) =>
        editor.getElement().focus()

  loadLinksFromDb: ->
    @apiLinks = @db.get('links').value()

  openDb: ->
    @dbAdapter = new FileSync @dbPath
    @db = low @dbAdapter
    @db.read()

  filterMethods: (text) ->
    if @lastPageDom
      entries = ""
      for entry in @lastPageDom.window.document.querySelectorAll('.entry-detail')
        if entry.textContent.toLowerCase().indexOf(text.toLowerCase()) > -1
          entries += entry.outerHTML
      entries

  refresh: -> # refresh all docs
    return if @store.loading

    @store.loadingOn()
    rimraf.sync @apiPath
    exec "git clone https://github.com/crystal-lang/crystal.git #{@apiPath} --depth=1", (err, stdout, stderr) =>
      @store.loadingOff()
      if err
        @store.addError "Failed to clone Crystal Docs", err.toString(), "Crystal Docs"
      else

        @store.loadingOn()
        exec "make docs", {cwd: @apiPath}, (err, stdout, stderr) =>
          @store.loadingOff()

          if err
            @store.addError "Failed to build Crystal docs", err.toString(), "Crystal Docs"
          else
            body = fs.readFileSync path.resolve(@apiPath, "docs", "String.html")
            body = body.toString()

            dom = new JSDOM(body)

            version = dom.window.document.querySelector('meta[name=generator]').getAttribute('content')
            @db.set('info.version', version).write()

            menu_a = '.types-list > ul > li > a'
            links = dom.window.document.querySelectorAll(menu_a)

            links = Array.prototype.slice.call(links)
            for link, idx in links
              nestedLinks = []
              sibling = link.nextElementSibling
              if sibling
                tempLinks = sibling.getElementsByTagName('a')
                for nestedLink in tempLinks
                  nestedLinks.push(
                    href: nestedLink.getAttribute('href')
                    title: nestedLink.innerHTML)
              href = link.getAttribute('href')
              title = href.replace('.html', '')
              (@db.get('links').push(
                href: href
                title: title.replace('toplevel', 'Top Level namespace')
                nestedLinks: JSON.stringify(nestedLinks)
              )).write()

          @loadLinksFromDb()

  getVersion: ->
    info = @db.get('info').value()
    @version = if info then "#{info.version}" else ""

  clearLinks: ->
    @apiLinks = []

  clearDb: ->
    await fs.unlink @dbPath, (err) =>
      if err
        @store.addError "Failed to clear database", err.toString(), "Crystal Docs"

      @openDb()

      (@db.defaults({ links: [], pages: [], info: {} })).write()

  loadPage: (href) ->
    body = fs.readFileSync path.resolve(@apiPath, "docs", href)
    body = body.toString()

    dom = new JSDOM(body)
    main_content_css = '.main-content'
    @lastPage = dom.window.document.querySelector(main_content_css).outerHTML

    setTimeout ( =>
      @lastPageDom = new JSDOM(@lastPage)
    ).bind(@), 10

    @lastPage


mobx.decorate DocsService,
  apiLinks: mobx.observable
  version: mobx.observable

  loadLinksFromDb: mobx.action
  clearLinks: mobx.action
  getVersion: mobx.action
