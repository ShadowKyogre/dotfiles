# dotfiles

What ARE these for?

- **asciidoc**: Anything related to writing setup
- **awesome**: Awesome WM settings
- **bash**: bash configuration
- **common**: Things that I'm not sure if they should go into their own package
- **compiz-boxmenu**: Menu files for Compiz-Boxmenu
- **compiz-reloaded**: [Compiz-Reloaded](https://github.com/compiz-reloaded/) settings.
- **cmus**: cmus settings
- **fish**: fish shell configuration
- **fonts**: fontconfig settings
- **gtk-themes**: All my GTK themes
- **term-colors-tests**: tests for terminal colorspace
- **termite**: termite settings
- **tint2**: tint2 settings
- **tmux**: tmux settings. By tmux, I mean [ershov's TCL-capable
  tmux](https://github.com/ershov/tmux).
- **vim**: vim configuration... Minus the plugins. Not sure how to deal with these in dotfile repo yet.
- **zsh**: zsh configuration

To use any of these, run:
~~~~
stow -v -t ~ -d /path/to/cloned/dotfiles package_name
~~~~
