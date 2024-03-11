-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<leader>Tt"] = {
      function() require("neotest").run.run(vim.fn.expand "%") end,
      desc = "Run File",
    },
    ["<leader>TT"] = { function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
    ["<leader>Tr"] = { function() require("neotest").run.run() end, desc = "Run Nearest" },
    ["<leader>Tl"] = { function() require("neotest").run.run_last() end, desc = "Run Last" },
    ["<leader>Ts"] = { function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    ["<leader>To"] = {
      function() require("neotest").output.open { enter = true, auto_close = true } end,
      desc = "Show Output",
    },
    ["<leader>TO"] = { function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    ["<leader>TS"] = { function() require("neotest").run.stop() end, desc = "Stop" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
