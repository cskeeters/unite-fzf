This is a matcher for the Vim plugin [unite][unite].  It implements extended-search mode from [FZF][FZF]

# Configuration

If you already have unite configured, you can set the matcher by adding the following command to your `.vimrc`.

```vim
call unite#filters#matcher_default#use(['matcher_fzf'])
```

[unite]: https://github.com/Shougo/unite.vim
[FZF]: https://github.com/junegunn/fzf
