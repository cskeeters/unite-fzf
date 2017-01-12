This is a matcher for the Vim plugin [unite][unite].  It implements extended-search mode from [FZF][FZF]

# Configuration

If you already have unite configured, you can set the matcher by adding the following command to your `.vimrc`.

```vim
call unite#filters#matcher_default#use(['matcher_fzf'])
```

# Help

Currently this plugin is not well tested and does not support performance boosts gained by utilizing lua as many of the other matchers do.  Pull requests are welcome.

[unite]: https://github.com/Shougo/unite.vim
[FZF]: https://github.com/junegunn/fzf
