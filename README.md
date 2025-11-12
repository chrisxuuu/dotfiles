dotfiles backup


### Nvim-R

Requires Tree-Sitter CLI (install with cargo):
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
cargo install tree-sitter-cli
```

Color Theme in radian terminal:
```
uv tool install --force radian --with pygments
```

.radian_profile:
```
options(
  radian.color_scheme = "one-dark", # replace with other themes
  radian.prompt = "\033[1;97mR>\033[0m ",
  radian.complete_while_typing = TRUE,
  radian.highlight_matching_bracket = TRUE,
  radian.tab_size = 2,
  radian.indent_lines = TRUE,
  radian.history_search_no_duplicates = TRUE,
  radian.editing_mode = "emacs"
)
```
