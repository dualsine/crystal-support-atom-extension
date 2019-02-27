React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

StyledPaper = require '../../misc/styled-paper-for-docs'

TextInput = require '../../ui/text-input'

import Fab from '@material-ui/core/Fab'
import MenuIcon from '@material-ui/icons/Menu'
import SearchIcon from '@material-ui/icons/Search'
import RefreshIcon from '@material-ui/icons/Refresh'
import SubtitlesIcon from '@material-ui/icons/Subtitles'

############################## CrystalApi
module.exports =
observer class CrystalDocsPage extends React.Component
  @title = "Docs (Api)"

  constructor: (props) ->
    super(props)
    @props = props

    @activeMenu = true

    @filter = ""

    @showTemp = false
    @tempContent = null

    @filterLinesRef = React.createRef()

    @tempKey = 0

    # @loadPage()

  setContent: (html) ->
    @content = html + "<br/><br/>"

  setTempContent: (html) ->
    @tempContent = "<div class=\"main-content\">#{html}</div>"

  showMenu: ->
    @activeMenu = true

  hideMenu: ->
    @activeMenu = false

    @clearFilterDocs()

  linkClick: (ev) ->
    @props.store.loadingOn()

    setTimeout (((target) =>
      html = @props.store.docsService.loadPage(target.parentElement.getAttribute('data-link'))
      @setContent(html)
      @hideMenu()
      @props.store.loadingOff()
    ).bind(@, ev.target)), 10

  filterDocs: (ev, space, txt) ->
    @filter = ev.target.value

  clearFilterDocs: ->
    @filter = ""

  filterLines: (ev, space, txt) ->
    if ev.target.value.length > 0
      # @showTemp = true
      # @tempContent = ""
      # for line, idx in @rawContent.split("\n")
      #   if line.indexOf(ev.target.value) > -1
      #     @tempContent += "#{idx}: #{line}<br>"
      # console.log @tempContent
      @showTemp = true
      entries = @props.store.docsService.filterMethods(ev.target.value)
      @setTempContent( entries )
    else
      @showTemp = false

  openFirstResult: ->
    if @activeMenu
      document.querySelector('#crystal-support-atom-extension-right-panel .docs-menu .list-item > span').click()

  genNestedDocFilterLink: (nestedLink, link) ->
    @tempKey += 1
    <li key={@tempKey} className='list-nested-item'>
      <div className='list-item' onClick={@linkClick.bind(@)} data-link={nestedLink.href}>
        <span className='icon icon-code'>{link.title}::{nestedLink.title}</span>
      </div>
    </li>

  genNestedDocLink: (nestedLink) ->
    @tempKey += 1
    <li key={@tempKey} className='list-nested-item'>
      <div className='list-item' onClick={@linkClick.bind(@)} data-link={nestedLink.href}>
        &nbsp;&nbsp;<span className='icon icon-code'>{nestedLink.title}</span>
      </div>
    </li>

  genPrimaryDocLink: (link) ->
    @tempKey += 1
    <li key={@tempKey} className="list-nested-item">
      <div className='list-item' onClick={@linkClick.bind(@)} data-link={link.href}>
        <span className='icon icon-file-text'>{link.title}</span>
      </div>
    </li>

  compareDocWithFilter: (link) ->
    # console.log link.title, link.href, @filter.length
    link.title.toLowerCase().indexOf(@filter.toLowerCase()) > -1 || link.href.toLowerCase().indexOf(@filter.toLowerCase()) > -1

  genHalfMenu: (links) ->
    for link in links
      results = []
      if @compareDocWithFilter(link)
        results.push @genPrimaryDocLink(link)
      if link.nestedLinks
        for nestedLink, nestedIdx in JSON.parse(link.nestedLinks)
          if @filter.length > 1
            if @compareDocWithFilter(nestedLink)
              results.push @genNestedDocFilterLink(nestedLink, link)
          else results.push @genNestedDocLink(nestedLink)
      results

  genMenu: (panelWidth) ->
    if @props.store.docsService.apiLinks
      # slice into halfs
      halfPoint = @props.store.docsService.apiLinks.length / 2 + 1
      leftLinks = @props.store.docsService.apiLinks.slice(0, halfPoint)
      rightLinks = @props.store.docsService.apiLinks.slice(halfPoint)
      #gen html for menu
      <div className="docs-menu #{if panelWidth > 600 && @filter.length < 1 then "concat" else ""}">
        <div className="docs-half-menu left list-tree">
          {
            @genHalfMenu(leftLinks)
          }
        </div>
        <div className="docs-half-menu right list-tree">
          {
            @genHalfMenu(rightLinks)
          }
        </div>
      </div>

  render: =>
    <div>
      {
        if @activeMenu || @props.store.loading
          <React.Fragment>
            <TextInput
              className="docs-filter-pages"
              disabled={false}
              label={@props.store.docsService.getVersion()}
              icon={SearchIcon}
              placeholder={"Search..."}
              onChange={@filterDocs.bind(@)}
              onKeyPress={(ev) => if ev.key == 'Enter' then @openFirstResult() }
              />
            {@genMenu(@props.store.rightPanelWidth)}
          </React.Fragment>
        else
          <React.Fragment>
            <Fab hidden variant="extended" onClick={@showMenu.bind(@)} aria-label="Show Menu" className="show-menu">
              <MenuIcon />
              Go back
            </Fab>
            <TextInput
              className="docs-filter-lines"
              disabled={false}
              label=""
              placeholder={"Filter by text in methods..."}
              onChange={@filterLines.bind(@)}
              ref={@filterLinesRef}
              />
            <StyledPaper className="docs-paper native-key-bindings" content={@content} tempContent={@tempContent} showTemp={@showTemp} />
          </React.Fragment>
      }
    </div>

mobx.decorate CrystalDocsPage,
  content: mobx.observable
  tempContent: mobx.observable
  showTemp: mobx.observable
  activeMenu: mobx.observable
  filter: mobx.observable

  setContent: mobx.action
  showMenu: mobx.action
  hideMenu: mobx.action
  filterDocs: mobx.action
  filterLines: mobx.action
  clearFilterDocs: mobx.action
