local leet_arg = "leetcode.nvim"
return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax

  -- "andweeb/presence.nvim",
  -- Neotest
  {
    "nvim-neotest/neotest",
    ft = { "go", "rust", "python" },
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          if opts.library.plugins ~= true then
            opts.library.plugins = require("astronvim.utils").list_insert_unique(opts.library.plugins, "neotest")
          end
          opts.library.types = true
        end,
      },
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require "neotest-go",
          require "neotest-rust",
          require "neotest-python",
          require "neotest-jest" {
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path) return vim.fn.getcwd() end,
          },
          require "neotest-vitest",
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
    keys = {
      { "<leader>Tt", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Run File" },
      { "<leader>TT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      {
        "<leader>To",
        function() require("neotest").output.open { enter = true, auto_close = true } end,
        desc = "Show Output",
      },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
  },
  {
    "catppuccin/nvim",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { neotest = true } },
  },
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup {
        local_config_file_name = ".competitest.lua",

        floating_border = "rounded",
        floating_border_highlight = "FloatBorder",
        picker_ui = {
          width = 0.2,
          height = 0.3,
          mappings = {
            focus_next = { "j", "<down>", "<Tab>" },
            focus_prev = { "k", "<up>", "<S-Tab>" },
            close = { "<esc>", "<C-c>", "q", "Q" },
            submit = { "<cr>" },
          },
        },
        editor_ui = {
          popup_width = 0.4,
          popup_height = 0.6,
          show_nu = true,
          show_rnu = false,
          normal_mode_mappings = {
            switch_window = { "<C-h>", "<C-l>", "<C-i>" },
            save_and_close = "<C-s>",
            cancel = { "q", "Q" },
          },
          insert_mode_mappings = {
            switch_window = { "<C-h>", "<C-l>", "<C-i>" },
            save_and_close = "<C-s>",
            cancel = "<C-q>",
          },
        },
        runner_ui = {
          interface = "popup",
          selector_show_nu = false,
          selector_show_rnu = false,
          show_nu = true,
          show_rnu = false,
          mappings = {
            run_again = "R",
            run_all_again = "<C-r>",
            kill = "K",
            kill_all = "<C-k>",
            view_input = { "i", "I" },
            view_output = { "a", "A" },
            view_stdout = { "o", "O" },
            view_stderr = { "e", "E" },
            toggle_diff = { "d", "D" },
            close = { "q", "Q" },
          },
          viewer = {
            width = 0.5,
            height = 0.5,
            show_nu = true,
            show_rnu = false,
            close_mappings = { "q", "Q" },
          },
        },
        popup_ui = {
          total_width = 0.8,
          total_height = 0.8,
          layout = {
            { 4, "tc" },
            { 5, { { 1, "so" }, { 1, "si" } } },
            { 5, { { 1, "eo" }, { 1, "se" } } },
          },
        },
        split_ui = {
          position = "right",
          relative_to_editor = true,
          total_width = 0.3,
          vertical_layout = {
            { 1, "tc" },
            { 1, { { 1, "so" }, { 1, "eo" } } },
            { 1, { { 1, "si" }, { 1, "se" } } },
          },
          total_height = 0.4,
          horizontal_layout = {
            { 2, "tc" },
            { 3, { { 1, "so" }, { 1, "si" } } },
            { 3, { { 1, "eo" }, { 1, "se" } } },
          },
        },

        save_current_file = true,
        save_all_files = false,
        compile_directory = ".",
        compile_command = {
          c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
          cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
          rust = { exec = "rustc", args = { "$(FNAME)" } },
          java = { exec = "javac", args = { "$(FNAME)" } },
        },
        running_directory = ".",
        run_command = {
          c = { exec = "./$(FNOEXT)" },
          cpp = { exec = "./$(FNOEXT)" },
          rust = { exec = "./$(FNOEXT)" },
          python = { exec = "python", args = { "$(FNAME)" } },
          java = { exec = "java", args = { "$(FNOEXT)" } },
        },
        multiple_testing = -1,
        maximum_time = 5000,
        output_compare_method = "squish",
        view_output_diff = false,

        testcases_directory = ".",
        testcases_use_single_file = false,
        testcases_auto_detect_storage = true,
        testcases_single_file_format = "$(FNOEXT).testcases",
        testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
        testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

        companion_port = 27121,
        receive_print_message = true,
        template_file = false,
        evaluate_template_modifiers = false,
        date_format = "%c",
        received_files_extension = "cpp",
        received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
        received_problems_prompt_path = true,
        received_contests_directory = "$(CWD)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        received_contests_prompt_directory = true,
        received_contests_prompt_extension = true,
        open_received_problems = true,
        open_received_contests = true,
        replace_received_testcases = false,
      }
    end,
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = leet_arg ~= vim.fn.argv()[1],
    cmd = "Leet",
    opts = {
      ---@type string
      arg = leet_arg,

      ---@type lc.lang
      lang = "cpp",

      cn = { -- leetcode.cn
        enabled = false, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
      },

      ---@type lc.storage
      storage = {
        home = vim.fn.stdpath "data" .. "/leetcode",
        cache = vim.fn.stdpath "cache" .. "/leetcode",
      },

      plugins = {},

      ---@type boolean
      logging = true,

      injector = {
        ["python3"] = {
          before = true,
        },
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
        ["java"] = {
          before = "import java.util.*;",
        },
      }, ---@type table<lc.lang, lc.inject>

      cache = {
        update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
      },

      console = {
        open_on_runcode = true, ---@type boolean

        dir = "row", ---@type lc.direction

        size = { ---@type lc.size
          width = "90%",
          height = "75%",
        },

        result = {
          size = "60%", ---@type lc.size
        },

        testcase = {
          virt_text = true, ---@type boolean

          size = "40%", ---@type lc.size
        },
      },

      description = {
        position = "left", ---@type lc.position

        width = "40%", ---@type lc.size

        show_stats = true, ---@type boolean
      },

      hooks = {
        ---@type fun()[]
        ["enter"] = {},

        ---@type fun(question: lc.ui.Question)[]
        ["question_enter"] = {},
      },

      keys = {
        toggle = { "q", "<Esc>" }, ---@type string|string[]
        confirm = { "<CR>" }, ---@type string|string[]

        reset_testcases = "r", ---@type string
        use_testcase = "U", ---@type string
        focus_testcases = "H", ---@type string
        focus_result = "L", ---@type string
      },

      ---@type boolean
      image_support = false, -- setting this to `true` will disable question description wrap
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  -- IMPORTANT: colorscheme
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
    },
  },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup {
        -- optional configuration here
        style = "vulgaris",
        transparent = false,
        code_style = {
          comments = { italic = true },
          conditionals = { italic = true },
          keywords = { bold = true },
          functions = {},
          namespaces = { italic = true },
          parameters = { italic = true },
          strings = {},
          variables = {},
        },
        lualine = {
          transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {
          surface2 = "#504844",
          surface1 = "#3a3634",
          surface0 = "#252525",
          base = "#151515",
          mantle = "#0e0e0e",
          crust = "#080808",
        }, -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = false, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
      require("bamboo").load()
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = false, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      light_style = "day", -- The theme is used when the background is set to light
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      latte = {
        rosewater = "#c14a4a",
        flamingo = "#c14a4a",
        red = "#c14a4a",
        maroon = "#c14a4a",
        pink = "#945e80",
        mauve = "#945e80",
        peach = "#c35e0a",
        yellow = "#b47109",
        green = "#6c782e",
        teal = "#4c7a5d",
        sky = "#4c7a5d",
        sapphire = "#4c7a5d",
        blue = "#45707a",
        lavender = "#45707a",
        text = "#654735",
        subtext1 = "#73503c",
        subtext0 = "#805942",
        overlay2 = "#8c6249",
        overlay1 = "#8c856d",
        overlay0 = "#a69d81",
        surface2 = "#bfb695",
        surface1 = "#d1c7a3",
        surface0 = "#e3dec3",
        base = "#f9f5d7",
        mantle = "#f0ebce",
        crust = "#e8e3c8",
      },
      color_overrides = {
        mocha = {
          rosewater = "#ea6962",
          flamingo = "#ea6962",
          red = "#ea6962",
          maroon = "#ea6962",
          pink = "#d3869b",
          mauve = "#d3869b",
          peach = "#e78a4e",
          yellow = "#d8a657",
          green = "#a9b665",
          teal = "#89b482",
          sky = "#89b482",
          sapphire = "#89b482",
          blue = "#7daea3",
          lavender = "#7daea3",
          text = "#ebdbb2",
          subtext1 = "#d5c4a1",
          subtext0 = "#bdae93",
          overlay2 = "#a89984",
          overlay1 = "#928374",
          overlay0 = "#595959",
          surface2 = "#4d4d4d",
          surface1 = "#404040",
          surface0 = "#292929",
          base = "#1d2021",
          mantle = "#191b1c",
          crust = "#141617",
        },
      },
      transparent_background = false,
      show_end_of_buffer = false,
      integration_default = false,
      integrations = {
        barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
        cmp = true,
        gitsigns = true,
        hop = true,
        illuminate = { enabled = true },
        native_lsp = { enabled = true, inlay_hints = { background = true } },
        neogit = true,
        neotree = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        vimwiki = true,
        which_key = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            CmpItemMenu = { fg = colors.surface2 },
            CursorLineNr = { fg = colors.text },
            FloatBorder = { bg = colors.base, fg = colors.surface0 },
            GitSignsChange = { fg = colors.peach },
            LineNr = { fg = colors.overlay0 },
            LspInfoBorder = { link = "FloatBorder" },
            NeoTreeDirectoryIcon = { fg = colors.subtext1 },
            NeoTreeDirectoryName = { fg = colors.subtext1 },
            NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
            NeoTreeGitConflict = { fg = colors.red },
            NeoTreeGitDeleted = { fg = colors.red },
            NeoTreeGitIgnored = { fg = colors.overlay0 },
            NeoTreeGitModified = { fg = colors.peach },
            NeoTreeGitStaged = { fg = colors.green },
            NeoTreeGitUnstaged = { fg = colors.red },
            NeoTreeGitUntracked = { fg = colors.green },
            NeoTreeIndent = { fg = colors.surface1 },
            NeoTreeNormal = { bg = colors.mantle },
            NeoTreeNormalNC = { bg = colors.mantle },
            NeoTreeRootName = { fg = colors.subtext1, style = { "bold" } },
            NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
            NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
            NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
            NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
            NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
            NormalFloat = { bg = colors.base },
            Pmenu = { bg = colors.mantle, fg = "" },
            PmenuSel = { bg = colors.surface0, fg = "" },
            TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
            TelescopePreviewNormal = { bg = colors.crust },
            TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopePromptPrefix = { bg = colors.surface0 },
            TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
            TelescopeSelection = { bg = colors.surface0 },
            VertSplit = { bg = colors.base, fg = colors.surface0 },
            WhichKeyFloat = { bg = colors.mantle },
            YankHighlight = { bg = colors.surface2 },
            FidgetTask = { fg = colors.subtext2 },
            FidgetTitle = { fg = colors.peach },

            IblIndent = { fg = colors.surface0 },
            IblScope = { fg = colors.overlay0 },

            Boolean = { fg = colors.mauve },
            Number = { fg = colors.mauve },
            Float = { fg = colors.mauve },

            PreProc = { fg = colors.mauve },
            PreCondit = { fg = colors.mauve },
            Include = { fg = colors.mauve },
            Define = { fg = colors.mauve },
            Conditional = { fg = colors.red },
            Repeat = { fg = colors.red },
            Keyword = { fg = colors.red },
            Typedef = { fg = colors.red },
            Exception = { fg = colors.red },
            Statement = { fg = colors.red },

            Error = { fg = colors.red },
            StorageClass = { fg = colors.peach },
            Tag = { fg = colors.peach },
            Label = { fg = colors.peach },
            Structure = { fg = colors.peach },
            Operator = { fg = colors.peach },
            Title = { fg = colors.peach },
            Special = { fg = colors.yellow },
            SpecialChar = { fg = colors.yellow },
            Type = { fg = colors.yellow, style = { "bold" } },
            Function = { fg = colors.green, style = { "bold" } },
            Delimiter = { fg = colors.subtext2 },
            Ignore = { fg = colors.subtext2 },
            Macro = { fg = colors.teal },

            TSAnnotation = { fg = colors.mauve },
            TSAttribute = { fg = colors.mauve },
            TSBoolean = { fg = colors.mauve },
            TSCharacter = { fg = colors.teal },
            TSCharacterSpecial = { link = "SpecialChar" },
            TSComment = { link = "Comment" },
            TSConditional = { fg = colors.red },
            TSConstBuiltin = { fg = colors.mauve },
            TSConstMacro = { fg = colors.mauve },
            TSConstant = { fg = colors.text },
            TSConstructor = { fg = colors.green },
            TSDebug = { link = "Debug" },
            TSDefine = { link = "Define" },
            TSEnvironment = { link = "Macro" },
            TSEnvironmentName = { link = "Type" },
            TSError = { link = "Error" },
            TSException = { fg = colors.red },
            TSField = { fg = colors.blue },
            TSFloat = { fg = colors.mauve },
            TSFuncBuiltin = { fg = colors.green },
            TSFuncMacro = { fg = colors.green },
            TSFunction = { fg = colors.green },
            TSFunctionCall = { fg = colors.green },
            TSInclude = { fg = colors.red },
            TSKeyword = { fg = colors.red },
            TSKeywordFunction = { fg = colors.red },
            TSKeywordOperator = { fg = colors.peach },
            TSKeywordReturn = { fg = colors.red },
            TSLabel = { fg = colors.peach },
            TSLiteral = { link = "String" },
            TSMath = { fg = colors.blue },
            TSMethod = { fg = colors.green },
            TSMethodCall = { fg = colors.green },
            TSNamespace = { fg = colors.yellow },
            TSNone = { fg = colors.text },
            TSNumber = { fg = colors.mauve },
            TSOperator = { fg = colors.peach },
            TSParameter = { fg = colors.text },
            TSParameterReference = { fg = colors.text },
            TSPreProc = { link = "PreProc" },
            TSProperty = { fg = colors.blue },
            TSPunctBracket = { fg = colors.text },
            TSPunctDelimiter = { link = "Delimiter" },
            TSPunctSpecial = { fg = colors.blue },
            TSRepeat = { fg = colors.red },
            TSStorageClass = { fg = colors.peach },
            TSStorageClassLifetime = { fg = colors.peach },
            TSStrike = { fg = colors.subtext2 },
            TSString = { fg = colors.teal },
            TSStringEscape = { fg = colors.green },
            TSStringRegex = { fg = colors.green },
            TSStringSpecial = { link = "SpecialChar" },
            TSSymbol = { fg = colors.text },
            TSTag = { fg = colors.peach },
            TSTagAttribute = { fg = colors.green },
            TSTagDelimiter = { fg = colors.green },
            TSText = { fg = colors.green },
            TSTextReference = { link = "Constant" },
            TSTitle = { link = "Title" },
            TSTodo = { link = "Todo" },
            TSType = { fg = colors.yellow, style = { "bold" } },
            TSTypeBuiltin = { fg = colors.yellow, style = { "bold" } },
            TSTypeDefinition = { fg = colors.yellow, style = { "bold" } },
            TSTypeQualifier = { fg = colors.peach, style = { "bold" } },
            TSURI = { fg = colors.blue },
            TSVariable = { fg = colors.text },
            TSVariableBuiltin = { fg = colors.mauve },

            ["@annotation"] = { link = "TSAnnotation" },
            ["@attribute"] = { link = "TSAttribute" },
            ["@boolean"] = { link = "TSBoolean" },
            ["@character"] = { link = "TSCharacter" },
            ["@character.special"] = { link = "TSCharacterSpecial" },
            ["@comment"] = { link = "TSComment" },
            ["@conceal"] = { link = "Grey" },
            ["@conditional"] = { link = "TSConditional" },
            ["@constant"] = { link = "TSConstant" },
            ["@constant.builtin"] = { link = "TSConstBuiltin" },
            ["@constant.macro"] = { link = "TSConstMacro" },
            ["@constructor"] = { link = "TSConstructor" },
            ["@debug"] = { link = "TSDebug" },
            ["@define"] = { link = "TSDefine" },
            ["@error"] = { link = "TSError" },
            ["@exception"] = { link = "TSException" },
            ["@field"] = { link = "TSField" },
            ["@float"] = { link = "TSFloat" },
            ["@function"] = { link = "TSFunction" },
            ["@function.builtin"] = { link = "TSFuncBuiltin" },
            ["@function.call"] = { link = "TSFunctionCall" },
            ["@function.macro"] = { link = "TSFuncMacro" },
            ["@include"] = { link = "TSInclude" },
            ["@keyword"] = { link = "TSKeyword" },
            ["@keyword.function"] = { link = "TSKeywordFunction" },
            ["@keyword.operator"] = { link = "TSKeywordOperator" },
            ["@keyword.return"] = { link = "TSKeywordReturn" },
            ["@label"] = { link = "TSLabel" },
            ["@math"] = { link = "TSMath" },
            ["@method"] = { link = "TSMethod" },
            ["@method.call"] = { link = "TSMethodCall" },
            ["@namespace"] = { link = "TSNamespace" },
            ["@none"] = { link = "TSNone" },
            ["@number"] = { link = "TSNumber" },
            ["@operator"] = { link = "TSOperator" },
            ["@parameter"] = { link = "TSParameter" },
            ["@parameter.reference"] = { link = "TSParameterReference" },
            ["@preproc"] = { link = "TSPreProc" },
            ["@property"] = { link = "TSProperty" },
            ["@punctuation.bracket"] = { link = "TSPunctBracket" },
            ["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
            ["@punctuation.special"] = { link = "TSPunctSpecial" },
            ["@repeat"] = { link = "TSRepeat" },
            ["@storageclass"] = { link = "TSStorageClass" },
            ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
            ["@strike"] = { link = "TSStrike" },
            ["@string"] = { link = "TSString" },
            ["@string.escape"] = { link = "TSStringEscape" },
            ["@string.regex"] = { link = "TSStringRegex" },
            ["@string.special"] = { link = "TSStringSpecial" },
            ["@symbol"] = { link = "TSSymbol" },
            ["@tag"] = { link = "TSTag" },
            ["@tag.attribute"] = { link = "TSTagAttribute" },
            ["@tag.delimiter"] = { link = "TSTagDelimiter" },
            ["@text"] = { link = "TSText" },
            ["@text.danger"] = { link = "TSDanger" },
            ["@text.diff.add"] = { link = "diffAdded" },
            ["@text.diff.delete"] = { link = "diffRemoved" },
            ["@text.emphasis"] = { link = "TSEmphasis" },
            ["@text.environment"] = { link = "TSEnvironment" },
            ["@text.environment.name"] = { link = "TSEnvironmentName" },
            ["@text.literal"] = { link = "TSLiteral" },
            ["@text.math"] = { link = "TSMath" },
            ["@text.note"] = { link = "TSNote" },
            ["@text.reference"] = { link = "TSTextReference" },
            ["@text.strike"] = { link = "TSStrike" },
            ["@text.strong"] = { link = "TSStrong" },
            ["@text.title"] = { link = "TSTitle" },
            ["@text.todo"] = { link = "TSTodo" },
            ["@text.todo.checked"] = { link = "Green" },
            ["@text.todo.unchecked"] = { link = "Ignore" },
            ["@text.underline"] = { link = "TSUnderline" },
            ["@text.uri"] = { link = "TSURI" },
            ["@text.warning"] = { link = "TSWarning" },
            ["@todo"] = { link = "TSTodo" },
            ["@type"] = { link = "TSType" },
            ["@type.builtin"] = { link = "TSTypeBuiltin" },
            ["@type.definition"] = { link = "TSTypeDefinition" },
            ["@type.qualifier"] = { link = "TSTypeQualifier" },
            ["@uri"] = { link = "TSURI" },
            ["@variable"] = { link = "TSVariable" },
            ["@variable.builtin"] = { link = "TSVariableBuiltin" },

            ["@lsp.type.class"] = { link = "TSType" },
            ["@lsp.type.comment"] = { link = "TSComment" },
            ["@lsp.type.decorator"] = { link = "TSFunction" },
            ["@lsp.type.enum"] = { link = "TSType" },
            ["@lsp.type.enumMember"] = { link = "TSProperty" },
            ["@lsp.type.events"] = { link = "TSLabel" },
            ["@lsp.type.function"] = { link = "TSFunction" },
            ["@lsp.type.interface"] = { link = "TSType" },
            ["@lsp.type.keyword"] = { link = "TSKeyword" },
            ["@lsp.type.macro"] = { link = "TSConstMacro" },
            ["@lsp.type.method"] = { link = "TSMethod" },
            ["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
            ["@lsp.type.namespace"] = { link = "TSNamespace" },
            ["@lsp.type.number"] = { link = "TSNumber" },
            ["@lsp.type.operator"] = { link = "TSOperator" },
            ["@lsp.type.parameter"] = { link = "TSParameter" },
            ["@lsp.type.property"] = { link = "TSProperty" },
            ["@lsp.type.regexp"] = { link = "TSStringRegex" },
            ["@lsp.type.string"] = { link = "TSString" },
            ["@lsp.type.struct"] = { link = "TSType" },
            ["@lsp.type.type"] = { link = "TSType" },
            ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
            ["@lsp.type.variable"] = { link = "TSVariable" },
          }
        end,
        latte = function(colors)
          return {
            IblIndent = { fg = colors.mantle },
            IblScope = { fg = colors.surface1 },

            LineNr = { fg = colors.surface1 },
          }
        end,
      },
    },
  },
  -- NOTE: colorscheme
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "#ff6960", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "#a0dfa0", alt = { "COMPLETE", "TODO", "DONE" } },
        HACK = { icon = " ", color = "#ff9f9a" },
        WARN = { icon = " ", color = "#f98080", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "#a990c9", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "#b0d080", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "#95b9d0", alt = { "TESTING", "PASSED", "FAILED" } },
        INCOMPLETE = { icon = " ", color = "#f9905f", alt = { "INCOMPLETE", "PENDING" } },
        IMPORTANT = { icon = "⭐️", color = "#f9bd69", alt = { "IMPORTANT" } },
      },
    },
    event = "User AstroFile",
    cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
  },
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      client_id = "1009122352916857003",
      auto_update = true,
      neovim_image_text = "AstroNvim",
      main_image = "file",
      log_level = nil,
      debounce_timeout = 10,
      enable_line_number = false,
      blacklist = {},
      buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
      file_assets = {
        [".aliases"] = { ".aliases", "shell" },
        [".appveyor.yml"] = { "AppVeyor config", "appveyor" },
        [".babelrc"] = { "Babel config", "babel" },
        [".babelrc.cjs"] = { "Babel config", "babel" },
        [".babelrc.js"] = { "Babel config", "babel" },
        [".babelrc.json"] = { "Babel config", "babel" },
        [".babelrc.mjs"] = { "Babel config", "babel" },
        [".bash_login"] = { ".bash_login", "shell" },
        [".bash_logout"] = { ".bash_logout", "shell" },
        [".bash_profile"] = { ".bash_profile", "shell" },
        [".bash_prompt"] = { ".bash_prompt", "shell" },
        [".bashrc"] = { ".bashrc", "shell" },
        [".cshrc"] = { ".cshrc", "shell" },
        [".dockercfg"] = { "Docker", "docker" },
        [".dockerfile"] = { "Docker", "docker" },
        [".dockerignore"] = { "Docker", "docker" },
        [".editorconfig"] = { "EditorConfig", "editorconfig" },
        [".eslintignore"] = { "ESLint", "eslint" },
        [".eslintrc"] = { "ESLint", "eslint" },
        [".eslintrc.cjs"] = { "ESLint", "eslint" },
        [".eslintrc.js"] = { "ESLint", "eslint" },
        [".eslintrc.json"] = { "ESLint", "eslint" },
        [".eslintrc.yaml"] = { "ESLint", "eslint" },
        [".eslintrc.yml"] = { "ESLint", "eslint" },
        [".gitattributes"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        [".gitconfig"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        [".gitignore"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        [".gitlab-ci.yaml"] = { "GitLab CI", "gitlab" },
        [".gitlab-ci.yml"] = { "GitLab CI", "gitlab" },
        [".gitmodules"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        [".login"] = { ".login", "shell" },
        [".logout"] = { ".login", "shell" },
        [".luacheckrc"] = {
          ".luacheckrc",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Lua-Logo.svg/600px-Lua-Logo.svg.png",
        },
        [".npmignore"] = { "npm config", "npm" },
        [".npmrc"] = { "npm config", "npm" },
        [".nvmrc"] = {
          ".nvmrc",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Node.js_logo.svg/640px-Node.js_logo.svg.png",
        },
        [".prettierrc"] = { "Prettier", "prettier" },
        [".prettierrc.cjs"] = { "Prettier", "prettier" },
        [".prettierrc.js"] = { "Prettier", "prettier" },
        [".prettierrc.json"] = { "Prettier", "prettier" },
        [".prettierrc.json5"] = { "Prettier", "prettier" },
        [".prettierrc.toml"] = { "Prettier", "prettier" },
        [".prettierrc.yaml"] = { "Prettier", "prettier" },
        [".prettierrc.yml"] = { "Prettier", "prettier" },
        [".profile"] = { ".profile", "shell" },
        [".tcshrc"] = { ".tcshrc", "shell" },
        [".terraformrc"] = { "Terraform config", "terraform" },
        [".tmux.conf"] = { "tmux", "tmux" },
        [".travis.yml"] = { "Travis CI", "travis" },
        [".vimrc"] = { ".vimrc", "vim" },
        [".watchmanconfig"] = { "Watchman config", "watchman" },
        [".yarnrc"] = { "Yarn config", "yarn" },
        [".zlogin"] = { ".zlogin", "shell" },
        [".zprofile"] = { ".zprofile", "shell" },
        [".zshenv"] = { ".zshenv", "shell" },
        [".zshrc"] = { ".zshrc", "shell" },
        ["Brewfile"] = { "Brewfile", "homebrew" },
        ["Brewfile.lock.json"] = { "Brewfile.lock.json", "homebrew" },
        ["CHANGELOG"] = { "CHANGELOG", "text" },
        ["CODE_OF_CONDUCT"] = { "Code of Conduct", "text" },
        ["COMMIT_EDITMSG"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        ["CONTRIBUTING"] = { "CONTRIBUTING", "text" },
        ["Cargo.lock"] = { "Cargo lockfile", "cargo" },
        ["Cargo.toml"] = { "Cargo.toml", "cargo" },
        ["Dockerfile"] = { "Docker", "docker" },
        ["Gemfile"] = {
          "Gemfile",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/768px-Ruby_logo.svg.png",
        },
        ["Gemfile.lock"] = {
          "Gemfile lockfile",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/768px-Ruby_logo.svg.png",
        },
        ["LICENSE"] = { "LICENSE", "text" },
        ["Makefile"] = { "Makefile", "code" },
        ["Rakefile"] = {
          "Rakefile",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/768px-Ruby_logo.svg.png",
        },
        ["abookrc"] = { "abook", "abook" },
        ["alacritty.yaml"] = { "Alacritty config", "alacritty" },
        ["alacritty.yml"] = { "Alacritty config", "alacritty" },
        ["appveyor.yml"] = { "AppVeyor config", "appveyor" },
        ["babel.config.cjs"] = { "Babel config", "babel" },
        ["babel.config.js"] = { "Babel config", "babel" },
        ["babel.config.json"] = { "Babel config", "babel" },
        ["babel.config.mjs"] = { "Babel config", "babel" },
        ["brew.sh"] = { "brew.sh", "homebrew" },
        ["docker-compose.yaml"] = { "Docker", "docker" },
        ["docker-compose.yml"] = { "Docker", "docker" },
        ["gitconfig"] = {
          "git",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Git_icon.svg/768px-Git_icon.svg.png",
        },
        ["gitlab.rb"] = { "GitLab config", "gitlab" },
        ["gitlab.yml"] = { "GitLab config", "gitlab" },
        ["go.mod"] = {
          "go.mod",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/640px-Go_Logo_Blue.svg.png",
        },
        ["go.sum"] = {
          "go.sum",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/640px-Go_Logo_Blue.svg.png",
        },
        ["jest.config.js"] = { "Jest config", "jest" },
        ["jest.setup.js"] = { "Jest config", "jest" },
        ["jest.setup.ts"] = { "Jest config", "jest" },
        ["kitty.conf"] = { "Kitty config", "kitty" },
        ["next-env.d.ts"] = { "Next.js config", "nextjs" },
        ["next.config.js"] = { "Next.js config", "nextjs" },
        ["nginx"] = { "NGINX", "nginx" },
        ["nginx.conf"] = { "NGINX", "nginx" },
        ["nuxt.config.js"] = { "Nuxt config", "nuxtjs" },
        ["prettier.config.cjs"] = { "Prettier", "prettier" },
        ["prettier.config.js"] = { "Prettier", "prettier" },
        ["profile"] = { "profile", "shell" },
        ["renovate.json"] = { "Renovate config", "renovate" },
        ["requirements.txt"] = {
          "requirements.txt",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/701px-Python-logo-notext.svg.png",
        },
        ["tailwind.config.js"] = {
          "Tailwind",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tailwind_CSS_Logo.svg/640px-Tailwind_CSS_Logo.svg.png",
        },
        ["terraform.rc"] = { "Terraform config", "terraform" },
        ["v.mod"] = { "v.mod", "vlang" },
        ["watchman.json"] = { "Watchman config", "watchman" },
        ["webpack.config.js"] = { "Webpack", "webpack" },
        ["webpack.config.ts"] = { "Webpack", "webpack" },
        ["yarn.lock"] = { "Yarn lockfile", "yarn" },
        ["zlogin"] = { "zlogin", "shell" },
        ["zlogout"] = { "zlogout", "shell" },
        ["zprofile"] = { "zprofile", "shell" },
        ["zshenv"] = { "zshenv", "shell" },
        ["zshrc"] = { "zshrc", "shell" },
        addressbook = { "abook", "abook" },
        astro = { "astro", "https://pbs.twimg.com/profile_images/1632785343433908224/SnMGR19O_400x400.png" },
        ahk = { "Autohotkey", "autohotkey" },
        applescript = { "Applescript", "applescript" },
        bash = { "Bash script", "shell" },
        bib = {
          "BibTeX",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/LaTeX_logo.svg/640px-LaTeX_logo.svg.png",
        },
        c = { "C ", "https://upload.wikimedia.org/wikipedia/commons/1/19/C_Logo.png" },
        cabal = { "Cabal file", "haskell" },
        cc = {
          "C++",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/C%2B%2B_logo.png/533px-C%2B%2B_logo.png",
        },
        cf = { "Configuration file", "config" },
        cfg = { "Configuration file", "config" },
        cl = { "Common Lisp", "lisp" },
        clj = { "Clojure", "clojure" },
        cljs = { "ClojureScript", "clojurescript" },
        cls = { "Visual Basic class module", "visual_basic" },
        cnf = { "Configuration file", "config" },
        coffee = { "CoffeeScript", "coffeescript" },
        conf = { "Configuration file", "config" },
        config = { "Configuration file", "config" },
        cpp = {
          "C++",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/C%2B%2B_logo.png/533px-C%2B%2B_logo.png",
        },
        cr = { "Crystal", "crystal" },
        cs = { "C#", "c_sharp" },
        css = {
          "CSS",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/CSS3_logo_and_wordmark.svg/544px-CSS3_logo_and_wordmark.svg.png",
        },
        cxx = {
          "C++",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/C%2B%2B_logo.png/533px-C%2B%2B_logo.png",
        },
        d = { "D", "d" },
        dart = { "Dart", "dart" },
        dll = { "DLL file", "visual_basic" },
        e = { "Eiffel", "eiffel" },
        elm = { "Elm", "elm" },
        erl = { "Erlang", "erlang" },
        ex = { "Elixir", "elixir" },
        expect = { "Expect", "tcl" },
        fasl = { "Common Lisp", "lisp" },
        fish = { "Fish script", "fish" },
        fnl = { "Fennel", "fennel" },
        fs = { "F#", "f_sharp" },
        g = { "ANTLR grammar", "antlr" },
        g3 = { "ANTLR 3 grammar", "antlr" },
        g4 = { "ANTLR 4 grammar", "antlr" },
        gemspec = {
          "Gem Spec",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/768px-Ruby_logo.svg.png",
        },
        go = {
          "Go",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/640px-Go_Logo_Blue.svg.png",
        },
        gql = {
          "GraphQL",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/GraphQL_Logo.svg/768px-GraphQL_Logo.svg.png",
        },
        graphql = {
          "GraphQL",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/GraphQL_Logo.svg/768px-GraphQL_Logo.svg.png",
        },
        groovy = { "Groovy", "groovy" },
        gsh = { "Groovy", "groovy" },
        gvy = { "Groovy", "groovy" },
        gy = { "Groovy", "groovy" },
        h = { "C header file", "https://upload.wikimedia.org/wikipedia/commons/1/19/C_Logo.png" },
        hack = { "Hack", "hack" },
        haml = { "Haml", "haml" },
        hpp = {
          "C++ header file",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/C%2B%2B_logo.png/533px-C%2B%2B_logo.png",
        },
        hs = { "Haskell", "haskell" },
        html = {
          "HTML",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/HTML5_logo_and_wordmark.svg/768px-HTML5_logo_and_wordmark.svg.png",
        },
        hx = { "Haxe", "haxe" },
        hxx = {
          "C++ header file",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/C%2B%2B_logo.png/533px-C%2B%2B_logo.png",
        },
        idr = { "Idris", "idris" },
        ini = { "Configuration file", "config" },
        ino = { "Arduino", "arduino" },
        ipynb = { "Jupyter Notebook", "jupyter" },
        java = { "Java", "java" },
        jl = { "Julia", "julia" },
        js = {
          "JavaScript",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/JavaScript-logo.png/768px-JavaScript-logo.png",
        },
        json = { "JSON", "https://seeklogo.com/images/N/nodejs-logo-FBE122E377-seeklogo.com.png" },
        jsx = { "React", "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/React.svg/533px-React.svg.png" },
        ksh = { "KornShell script", "shell" },
        kshrc = { "KornShell config", "shell" },
        kt = { "Kotlin", "kotlin" },
        kv = { "Kivy", "kivy" },
        l = { "Common Lisp", "lisp" },
        less = { "Less", "less" },
        lidr = { "Idris", "idris" },
        liquid = { "Liquid", "liquid" },
        lisp = { "Common Lisp", "lisp" },
        log = { "Log file", "code" },
        lsp = { "Common Lisp", "lisp" },
        lua = { "Lua", "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Lua-Logo.svg/600px-Lua-Logo.svg.png" },
        m = { "MATLAB", "matlab" },
        markdown = {
          "Markdown",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/640px-Markdown-mark.svg.png",
        },
        mat = { "MATLAB", "matlab" },
        md = {
          "Markdown",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/640px-Markdown-mark.svg.png",
        },
        mdx = { "MDX", "mdx" },
        mjs = {
          "JavaScript",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/JavaScript-logo.png/768px-JavaScript-logo.png",
        },
        ml = { "OCaml", "ocaml" },
        nim = { "Nim", "nim" },
        nix = { "Nix", "nix" },
        norg = { "Neorg", "neorg" },
        org = { "Org", "org" },
        pb = { "Protobuf", "protobuf" },
        pcss = { "PostCSS", "postcss" },
        pgsql = { "PostgreSQL", "pgsql" },
        php = { "PHP", "php" },
        pl = { "Perl", "perl" },
        plist = { "Property List", "markup" },
        postcss = { "PostCSS", "postcss" },
        proto = { "Protobuf", "protobuf" },
        ps1 = { "PowerShell", "powershell" },
        psd1 = { "PowerShell", "powershell" },
        psm1 = { "PowerShell", "powershell" },
        purs = { "PureScript", "purescript" },
        py = {
          "Python",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/701px-Python-logo-notext.svg.png",
        },
        r = { "R", "r" },
        raku = { "Raku", "raku" },
        rakudoc = { "Raku", "raku" },
        rakumod = { "Raku", "raku" },
        rakutest = { "Raku", "raku" },
        rb = {
          "Ruby",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/768px-Ruby_logo.svg.png",
        },
        re = { "Reason", "reason" },
        res = { "ReScript", "rescript" },
        rkt = { "Racket", "racket" },
        rs = {
          "Rust",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Rust_programming_language_black_logo.svg/768px-Rust_programming_language_black_logo.svg.png",
        },
        sass = { "Sass", "sass" },
        scala = { "Scala", "scala" },
        scm = { "Scheme", "scheme" },
        scss = { "Sass", "scss" },
        sh = { "Shell script", "shell" },
        shrc = { "Shell config", "shell" },
        snap = { "Jest Snapshot", "jest" },
        sql = { "SQL", "database" },
        ss = { "Scheme", "scheme" },
        svelte = { "Svelte", "svelte" },
        svg = { "SVG", "markup" },
        swift = { "Swift", "swift" },
        tcl = { "Tcl", "tcl" },
        tex = {
          "LaTeX",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/LaTeX_logo.svg/640px-LaTeX_logo.svg.png",
        },
        text = { "Text file", "text" },
        tf = { "Terraform", "terraform" },
        tk = { "Tcl/Tk", "tcl" },
        tl = { "Teal", "teal" },
        toml = { "TOML", "toml" },
        ts = {
          "TypeScript",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Typescript_logo_2020.svg/768px-Typescript_logo_2020.svg.png",
        },
        tsx = { "React", "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/React.svg/533px-React.svg.png" },
        txt = { "Text file", "text" },
        uc = { "UnrealScript", "unreal" },
        v = { "Vlang", "vlang" },
        vsh = { "Vlang shell script", "vlang" },
        vb = { "Visual Basic", "visual_basic" },
        vbp = { "Visual Basic project file", "visual_basic" },
        vim = { "Vim", "vim" },
        viml = { "Vim", "vim" },
        vue = { "Vue", "vue" },
        wasm = { "WebAssembly", "webassembly" },
        wast = { "WebAssembly", "webassembly" },
        wat = { "WebAssembly", "webassembly" },
        xml = { "XML", "markup" },
        xsd = { "XML Schema", "markup" },
        xslt = { "XSLT", "markup" },
        yaml = { "YAML", "yaml" },
        yml = { "YAML", "yaml" },
        zig = { "Zig", "zig" },
        zsh = { "Zsh script", "shell" },
        zu = { "Zimbu", "zimbu" },
      }, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
      show_time = true, -- Show the timer

      -- Rich Presence text options
      editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
      file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
      git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
      plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
      reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
      workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
      line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    },
  },
}
