-- Markdown: the ONLY formatting we apply is prose hard-wrap, done natively.
--
-- Setting textwidth turns on auto-wrap of prose as you type (the `t` flag is
-- already in formatoptions). Nothing else is touched — tables, lists, links,
-- and code blocks stay exactly as written (no external formatter runs).
--
-- Reflow existing prose on demand:
--   gqap   reflow the current paragraph
--   gqip   reflow paragraph (inner)
--   gggqG  reflow the whole file
--   gq{motion} / (visual) gq   reflow a range
vim.opt_local.textwidth = 80

-- Keep prose auto-wrap (t) but don't auto-insert the comment leader, and don't
-- break already-long lines mid-insert. (Default md formatoptions: jtcqln)
vim.opt_local.formatoptions:remove("c") -- markdown has no real "comments"
