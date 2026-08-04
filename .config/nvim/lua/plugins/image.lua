-- Inline image rendering in the buffer via the Kitty graphics protocol (Ghostty
-- supports it). Snacks.image renders markdown images — including Obsidian
-- wikilink embeds ![[name.png]] — right in the note. Toggle raw/render as usual
-- with render-markdown; images show whenever the buffer is rendered.
--
-- Requires ImageMagick (`magick`), installed via Homebrew (see Brewfile).
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true, -- doc.inline/float already default true; Ghostty = inline
        -- Obsidian wikilink embeds are bare filenames (e.g. "Pasted image ….png").
        -- Resolve them to the vault's _Attachments folder by finding the vault
        -- root (the dir containing .obsidian), regardless of cwd / note subfolder.
        resolve = function(file, src)
          if src:match("^%w+://") or src:find("/") then
            return nil -- URL or explicit path: use Snacks' normal resolution
          end
          local vault = vim.fs.root(file, ".obsidian")
          if vault then
            local p = vault .. "/_Attachments/" .. src
            if vim.fn.filereadable(p) == 1 then
              return p
            end
          end
          return nil
        end,
      },
    },
  },
}
