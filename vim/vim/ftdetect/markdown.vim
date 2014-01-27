" Detection rules for markdown files

au! BufNewFile,BufRead *.m*down setfiletype markdown
au! BufNewFile,BufRead *.md     setfiletype markdown
au! BufNewFile,BufRead README   setfiletype markdown
