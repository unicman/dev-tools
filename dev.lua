--------------------------------------------------------------------------------
-- File: dev.lua
--
-- Description: Global settings applicable for all files in Neo VIM.
--
-- Date (M/D/Y)         Name            Description
-- 20/03/2023           unicman   	Created
--
-- Usage on Mac: ln -s <path_to_dev.lua> ~/.config/nvim/init.lua
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Package managed @ https://github.com/folke/lazy.nvim replacement for packer.
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Short-cut variables
--------------------------------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local highlight = vim.api.nvim_set_hl       -- Create highlight

--------------------------------------------------------------------------------
-- Built-in and global configuration affects all files
--------------------------------------------------------------------------------

vim.cmd.colorscheme('default')
vim.opt.number=true
vim.opt.smartindent=true
vim.opt.autoindent=true
vim.opt.cursorline=true

--------------------------------------------------------------------------------
-- File type based customisations.
--------------------------------------------------------------------------------

autocmd('FileType', {
    pattern = { 
        'javascript', 'json', 'html', 
        'tf', 'terraform', 
        'yaml', 'yaml.docker-compose'
    },
    command = [[setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab]]
})

autocmd('FileType', {
    pattern = { 
        'vim', 'lua', 
        'xml', 'xslt', 
        'python', 
        'sh', 'bash', 
        'fish',
        'groovy', 
        'plantuml', 
        'Dockerfile'
    },
    command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab'
})

--------------------------------------------------------------------------------
-- nvim-lualine/lualine.nvim: Font settings
--
-- NOTE: In VimR change VimR -> Settings -> Appearance -> Default Font
-- Execute set guifont or set guifont=* to know exact font name that works.
--------------------------------------------------------------------------------

vim.opt.guifont='JetBrainsMono_NFM_Regular:h12'

--------------------------------------------------------------------------------
-- kamykn/spelunker.vim: Spelling check settings
--------------------------------------------------------------------------------

highlight(0, 'SpelunkerSpellBad', {undercurl=true, underline=false})
highlight(0, 'SpelunkerComplexOrCompoundWord', {undercurl=true, underline=false})

--------------------------------------------------------------------------------
-- Package Manager - Plugins
--------------------------------------------------------------------------------

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    -- Switches scheme w.r.t. system color scheme
    {
        "f-person/auto-dark-mode.nvim",
        config = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.api.nvim_set_option("background", "dark")
                vim.cmd("colorscheme evening")
            end,
            set_light_mode = function()
                vim.api.nvim_set_option("background", "light")
                vim.cmd("colorscheme shine")
            end,
        }
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        init = function()
		os.execute('pip3 install --upgrade neovim python-lsp-server && brew install hashicorp/tap/terraform-ls')
	end,
    },

    -- Improves Vim's spell checking function, ZL to see correct options
    {
        'kamykn/spelunker.vim',
        dependencies = 'kamykn/popup-menu.nvim',    -- Popup menu for spell checker
        config = function()
            vim.g.enable_spelunker_vim=1
            vim.g.spelunker_disable_uri_checking=1
            vim.g.spelunker_disable_account_name_checking=1
            vim.g.spelunker_disable_acronym_checking=1
            vim.g.spelunker_disable_backquoted_checking=1
            -- [[vim.highlight.create('SpelunkerSpellBad', {gui=undercurl, guifg=#9e9e9e}, false)]],
            -- [[vim.highlight.create('SpelunkerComplexOrCompoundWord', {gui=undercurl, guifg=#9e9e9e}, false)]],
            vim.opt.spell=false -- Disable default spell check
        end,
   },

    -- Tag line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
        init = function()
		os.execute('cd ~/Library/Fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf')
	end,
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = 'gruvbox',
                }
            })
        end,
    },

    -- Docker and docker-compose support
    'ekalinin/Dockerfile.vim',

    -- Fish shell syntax highlighting
    'nickeb96/fish.vim',

    -- Git / Bitbucket support
    {
        'tpope/vim-fugitive',
        dependencies = {
            'mhinz/vim-signify',    -- Highlight Git changes
            'tpope/vim-rhubarb',    -- GBrowse support for GitHub
        }
    },

    -- Change working directory intelligently
    {
        'notjedi/nvim-rooter.lua',
        config = function() require'nvim-rooter'.setup() end
    },
})


--------------------------------------------------------------------------------
-- hrsh7th/nvim-cmp: puto-completion configuration.
--------------------------------------------------------------------------------

local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}

require'lspconfig'.pylsp.setup{}

require'lspconfig'.terraformls.setup{}
vim.api.nvim_create_autocmd({'BufWritePre'}, {
    pattern={"*.tf", "*.tfvars"},
    callback=vim.lsp.buf.format
})

