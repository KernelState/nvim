local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.filetype.add({
  extension = {
    qml = "qml",
  },
})

vim.filetype.add({
  extension = {
    h = 'cpp',
  },
})

vim.g.mapleader        = " "
vim.g.maplocalleader   = " "
vim.g.netrw_banner     = 0

vim.opt.showtabline    = 0
vim.opt.undodir        = undodir
vim.opt.undofile       = true
vim.opt.swapfile       = false
vim.opt.backup         = false

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.clipboard      = "unnamedplus"
vim.opt.breakindent    = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.signcolumn     = "yes"
vim.opt.guicursor      = "a:block-blinkon0"
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.hlsearch       = false
vim.opt.incsearch      = true
vim.opt.termguicolors  = true
vim.opt.scrolloff      = 8
vim.opt.isfname:append("@-@")
vim.opt.updatetime     = 50
vim.opt.colorcolumn    = "80"

-- ==========================================================================
-- LAZY.NVIM BOOTSTRAP
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- PLUGINS  (your plugins + Prime's additions)
-- ==========================================================================
require("lazy").setup({

    -- ── Theme ────────────────────────────────────────────────────────────
    {
        "rose-pine/neovim",
        name     = "rose-pine",
        priority = 1000,
        config   = function()
            require("rose-pine").setup({
                variant = "main",
                styles  = { italic = true, bold = false, transparency = true },
            })
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    -- ── UI ───────────────────────────────────────────────────────────────
    "nvim-tree/nvim-web-devicons",
    "folke/which-key.nvim",
    "folke/zen-mode.nvim",

    -- ── Treesitter ───────────────────────────────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build  = ":TSUpdate",
        lazy   = false,
        config = function()
            vim.cmd("syntax off")  -- if treesitter handles everything
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "lua", "python", "c", "cpp", "rust", "go",
                    "javascript", "typescript", "tsx", "html", "css",
                    "json", "yaml", "toml", "bash", "nix", "ols",
                    "markdown", "markdown_inline", "vim", "vimdoc", "regex", "qmljs"
                },
                auto_install = true,
                highlight    = true,
                indent       = { enable = false },
            })
        end,
    },
    "nvim-treesitter/nvim-treesitter-context",  -- Prime's sticky context

    "lewis6991/gitsigns.nvim",
    "tpope/vim-fugitive",

    {
        "ThePrimeagen/harpoon",
        branch       = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "mbbill/undotree",

    -- ── Editor utilities ─────────────────────────────────────────────────
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",
    {
        "ThePrimeagen/refactoring.nvim",  -- Prime's refactoring helpers
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    },

    -- ── Telescope ────────────────────────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "nvim-telescope/telescope-ui-select.nvim",

    -- ── Completion ───────────────────────────────────────────────────────
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",         -- Prime includes this
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",

    -- ── LSP ──────────────────────────────────────────────────────────────
    "neovim/nvim-lspconfig",
    { "mason-org/mason.nvim" },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    },
    "j-hui/fidget.nvim",            -- LSP progress in the corner
})

-- ==========================================================================
-- PLUGIN SETUP
-- ==========================================================================
require("fidget").setup({})

local ok_ll, lualine = pcall(require, "lualine")
if ok_ll then
    lualine.setup({ options = { theme = "rose-pine" } })
end

local ok_ibl, ibl = pcall(require, "ibl")
if ok_ibl then ibl.setup() end

local ok_git, gitsigns = pcall(require, "gitsigns")
if ok_git then gitsigns.setup() end

local ok_pairs, autopairs = pcall(require, "nvim-autopairs")
if ok_pairs then autopairs.setup({}) end

local ok_com, comment = pcall(require, "Comment")
if ok_com then comment.setup() end

local ok_wk, whichkey = pcall(require, "which-key")
if ok_wk then whichkey.setup() end

-- Treesitter context (Prime uses this to keep function/class header visible)
local ok_ctx, tsctx = pcall(require, "treesitter-context")
if ok_ctx then
    tsctx.setup({ enable = true, max_lines = 3 })
end

-- Zen mode
local ok_zen = pcall(require, "zen-mode")
if ok_zen then
    vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").toggle()
    end, { desc = "Zen Mode" })
end

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })

-- Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git,       { desc = "Git status (Fugitive)" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>",   { silent = true, desc = "Git push" })
vim.keymap.set("n", "<leader>gP", ":Git pull<CR>",   { silent = true, desc = "Git pull" })

local ok_ref = pcall(require, "refactoring")
if ok_ref then
    require("refactoring").setup()
    vim.keymap.set({ "n", "x" }, "<leader>re", function()
        require("refactoring").select_refactor()
    end, { desc = "Refactor" })
end

local ok_harpoon, harpoon = pcall(require, "harpoon")
if ok_harpoon then
    harpoon:setup()
    vim.keymap.set("n", "<leader>a",  function() harpoon:list():add() end,          { desc = "Harpoon add" })
    vim.keymap.set("n", "<C-e>",      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
    vim.keymap.set("n", "<C-h>",      function() harpoon:list():select(1) end,      { desc = "Harpoon 1" })
    vim.keymap.set("n", "<C-t>",      function() harpoon:list():select(2) end,      { desc = "Harpoon 2" })
    vim.keymap.set("n", "<C-n>",      function() harpoon:list():select(3) end,      { desc = "Harpoon 3" })
    vim.keymap.set("n", "<C-s>",      function() harpoon:list():select(4) end,      { desc = "Harpoon 4" })
    vim.keymap.set("n", "<C-S-P>",    function() harpoon:list():prev() end,         { desc = "Harpoon prev" })
    vim.keymap.set("n", "<C-S-N>",    function() harpoon:list():next() end,         { desc = "Harpoon next" })
end

-- ── Telescope ──────────────────────────────────────────────────────────────
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
    telescope.setup({
        extensions = {
            ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
    })
    pcall(telescope.load_extension, "ui-select")

    local ok_builtin, builtin = pcall(require, "telescope.builtin")
    if ok_builtin then
        -- Your keybinds
        vim.keymap.set("n", "<leader>ff", builtin.find_files,  { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fs", builtin.live_grep,   { desc = "Live Grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers,     { desc = "Find Buffers" })
        -- Prime's aliases (feel the same, different muscle memory)
        vim.keymap.set("n", "<leader>pf", builtin.find_files,  { desc = "Find Files (Prime)" })
        vim.keymap.set("n", "<C-p>",      builtin.git_files,   { desc = "Git Files" })
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Grep string" })
        vim.keymap.set("n", "<leader>vh", builtin.help_tags,   { desc = "Help tags" })
    end
end

-- ==========================================================================
-- COMPLETION
-- ==========================================================================
local cmp      = require("cmp")
local luasnip  = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    enabled = function()
        return vim.g.cmp_enabled ~= false
    end,
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"]     = cmp.mapping.select_next_item(),
        ["<C-p>"]     = cmp.mapping.select_prev_item(),
        ["<C-d>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"]      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },   -- Prime includes this for vim.* completions
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
})

vim.g.cmp_enabled = true
vim.api.nvim_create_user_command("CmpToggle", function()
    vim.g.cmp_enabled = not vim.g.cmp_enabled
    vim.notify("Autocomplete " .. (vim.g.cmp_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle autocomplete" })
vim.keymap.set("n", "<leader>ct", "<cmd>CmpToggle<CR>", { desc = "Toggle autocomplete" })

-- ==========================================================================
-- LSP
-- ==========================================================================
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    opts)
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,   opts)
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,opts)
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,    opts)
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,         opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        opts)
        vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  opts)
        vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  opts)
        -- Prime's format binding
        vim.keymap.set("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end,
            { buffer = args.buf, desc = "Format buffer" })
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs        = true,
    underline    = true,
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "ols",
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime     = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace   = { checkThirdParty = false },
                        telemetry   = { enable = false },
                    },
                },
            })
        end,
    },
})

-- ==========================================================================
-- AUTOCOMMANDS
-- ==========================================================================

-- Highlight on yank (Prime has this)
vim.api.nvim_create_autocmd("TextYankPost", {
    desc     = "Highlight yanked text",
    group    = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Remove trailing whitespace on save (Prime has this)
vim.api.nvim_create_autocmd("BufWritePre", {
    desc     = "Remove trailing whitespace",
    group    = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
    pattern  = "*",
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- ==========================================================================
-- KEYMAPS  (your binds, preserved + Prime's additions)
-- ==========================================================================

-- File explorer
vim.keymap.set("n", "<leader>fe", ":Explore<CR>",  { silent = true, desc = "File Explorer" })
vim.keymap.set("n", "<leader>pv", ":Explore<CR>",  { silent = true, desc = "File Explorer (Prime)" })

-- Move selected lines up/down (Prime style)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join line without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centred when jumping / searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n",     "nzzzv")
vim.keymap.set("n", "N",     "Nzzzv")

-- Paste without overwriting clipboard
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- System clipboard yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]],  { desc = "Yank to clipboard" })
vim.keymap.set("n",          "<leader>Y", [["+Y]],  { desc = "Yank line to clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Quick escape from terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Prime: never press Q
vim.keymap.set("n", "Q", "<nop>")

-- Prime: make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })

-- Prime: replace word under cursor across file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })

-- Quick-open config (adjust path if needed)
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/init.lua<CR>",
    { desc = "Edit init.lua" })

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if vim.fn.isdirectory(bufname) == 1 or bufname == "" or buftype ~= "" then
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})

