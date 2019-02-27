React = require 'react'
mobx = require 'mobx'
{observer} = require 'mobx-react'

StyledPaper = require '../../ui/styled-paper'

TextInput = require '../../ui/text-input'

import Fab from '@material-ui/core/Fab'
import MenuIcon from '@material-ui/icons/Menu'
import SearchIcon from '@material-ui/icons/Search'
import RefreshIcon from '@material-ui/icons/Refresh'

############################## CrystalApi
module.exports =
observer class CrystalDocsPage extends React.Component
  @title = "Docs (Api)"

  constructor: (props) ->
    super(props)
    @props = props

    @activeMenu = true

    @filter = ""

    # @loadPage()

  setContent: (html) ->
    @content = html + "<br/><br/>"

  showMenu: ->
    @activeMenu = true

  hideMenu: ->
    @activeMenu = false

  linkClick: (ev) ->
    # @props.store.selectApiPage ev.target.parentElement.getAttribute('data-link')
    html = @props.store.docsService.loadPage(ev.target.parentElement.getAttribute('data-link'))
    @setContent(html)
    @hideMenu()

  filterApi: (ev, space, txt) ->
    @filter = ev.target.value

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
              onChange={@filterApi.bind(@)}
              />
            {if @props.store.docsService.apiLinks
              <ul className='list-tree docs-menu'>
                  {
                    for link, idx in @props.store.docsService.apiLinks
                      if link.title.toLowerCase().indexOf(@filter.toLowerCase()) > -1
                        <li key={idx} className='list-nested-item'>
                          <div className='list-item' onClick={@linkClick.bind(@)} data-link={link.href}>
                            <span className='icon icon-file-text'>{link.title}</span>
                          </div>
                          {if link.nestedLinks
                            <ul className='list-tree'>
                            {for nestedLink, nestedIdx in JSON.parse(link.nestedLinks)
                              if nestedLink.title.toLowerCase().indexOf(@filter.toLowerCase()) > -1
                                <li key={nestedIdx} className='list-nested-item'>
                                  <div className='list-item' onClick={@linkClick.bind(@)} data-link={nestedLink.href}>
                                    <span className='icon icon-file-text'>{nestedLink.title}</span>
                                  </div>
                                </li>}
                            </ul>}
                        </li>
                  }
              </ul>}
          </React.Fragment>
        else
          <React.Fragment>
            <Fab hidden variant="extended" onClick={@showMenu.bind(@)} aria-label="Show Menu" className="show-menu">
              <MenuIcon />
              Go back
            </Fab>
            <StyledPaper className="docs-paper" content={@content} />
          </React.Fragment>
      }
    </div>

mobx.decorate CrystalDocsPage,
  content: mobx.observable
  activeMenu: mobx.observable
  filter: mobx.observable

  setContent: mobx.action
  showMenu: mobx.action
  hideMenu: mobx.action
  filterApi: mobx.action
