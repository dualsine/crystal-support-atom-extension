
import { createMuiTheme } from '@material-ui/core/styles'
import lime from '@material-ui/core/colors/lime'
import indigo from '@material-ui/core/colors/indigo'
import pink from '@material-ui/core/colors/pink'

module.exports =
theme = createMuiTheme(
  palette:
    type: 'dark'
    primary:
      main: '#dcdcdc',
      contrastText: '#dcdcdc'
    secondary:
      main: '#dcdcdc',
      contrastText: '#dcdcdc'
    error: pink
    # Used by `getContrastText()` to maximize the contrast between the background and
    # the text.
    contrastThreshold: 3
    # Used to shift a color's luminance by approximately
    # two indexes within its tonal palette.
    # E.g., shift from Red 500 to Red 300 or Red 700.
    tonalOffset: 0.2
  # props:
  #   MuiInputLabel:
  #
  typography:
    useNextVariants: true
    fontSize: 14
    htmlFontSize: 14
)
