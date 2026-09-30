# Shell and terminal options

This catalog adds **120 options**: 112 nullable preferences and eight program
enable switches. Program options live at both `system.programs.<program>` and
`users.<name>.programs.<program>`. System program choices provide defaults for
managed users; explicit user choices override them.

| Module | Options | Coverage |
| --- | ---: | --- |
| `programs.bash` | 13 | Completion, history, aliases, variables, startup commands |
| `programs.zsh` | 23 | Suggestions, highlighting, history, aliases, editing keys |
| `programs.fish` | 9 | Completions, aliases, abbreviations, startup commands |
| `programs.tmux` | 20 | Mouse, keys, panes, scrollback, sessions, terminal settings |
| `programs.neovim` | 12 | Command aliases, default editor, plugin providers, Vimscript/Lua |
| `programs.fzf` | 14 | Shell integrations, picker sources, arguments, colors, Tmux wrapper |
| `programs.eza` | 8 | Shell integrations, icons, colors, Git status, arguments |
| `programs.direnv` | 8 | Shell integrations, Nix caching, mise, logging, helper commands |
| `system.shell` | 7 | Login-shell support, completion, global aliases and startup commands |
| `system.environment` | 6 | Shell/login variables, PATH directories, package profile links/outputs |

```zcfg
system.shell.zsh = true;
system.environment.localBinInPath = true;
system.programs.eza = { enable = true; icons = "auto"; showGitStatus = true; };

users.alex.programs = {
  zsh = {
    enable = true;
    suggestions = true;
    syntaxHighlighting = true;
    historyLines = 10000;
    editingMode = "vi";
    aliases = { ll = "eza -l"; };
  };
  tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    historyLines = 20000;
    escapeDelayMilliseconds = 0;
  };
  neovim = {
    enable = true;
    defaultEditor = true;
    aliasVim = true;
    luaConfiguration = "vim.opt.number = true";
  };
  fzf = { enable = true; zshIntegration = true; };
  direnv = { enable = true; zshIntegration = true; cacheNixEnvironments = true; };
};
```

Programs default to disabled; their preferences apply while enabled. All other
options default to `null`, which emits no backend assignment. Explicit false,
zero, and empty values are preserved. Lists and records retain normal backend
merging: an empty list does not necessarily clear inherited values.

Configuring a shell does not change the account login shell. Select that
separately with `users.<name>.profile.loginShell`; Zsh and Fish also need their
corresponding `system.shell` support. Integrations require a managed shell.
Direnv still requires explicit project authorization. Neovim's `defaultEditor`
sets EDITOR/VISUAL, so avoid contradictory environment settings.

History counts for Bash/Zsh, Tmux's first window index and Escape delay must be
nonnegative. Tmux scrollback and resize steps must be positive.

The complete option mapping is documented in the normative
[shell and terminal design](../../zenos-n-next/design/shell-terminal-options.md).

Lightweight checks compile all ten modules and evaluate their schemas and action
expressions using only the pinned Nix library:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 tests/check-shell-terminal-options.py \
  --nixpkgs /path/to/pinned/nixpkgs
```

These checks cover defaults, enable gating, user/shared routing, explicit empty
and false values, enum rejection, numeric bounds, and backend-value translations.
They do not establish runtime acceptance. VM testing and Explorer JSON regeneration
are deferred to avoid heavy builds on the host; existing exports predate this batch.
