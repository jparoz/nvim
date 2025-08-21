local M = {}

-- Returns a list of config files and friendly names,
-- to be consumed by a fuzzy-finding picker (e.g. Telescope).
-- Different per machine.
function M.files()
    local hostname = vim.fn.hostname()

    local common = {
        { name = "Neovim", path = vim.fn.stdpath("config") .. "/init.lua" },
    }

    if hostname == "mini" then
        local added = {
            { name = "Hammerspoon", path = "~/.hammerspoon/init.lua" },
        }
        return vim.iter({common, added}):flatten():totable()
    end

    if hostname == "JESSE3DDG" then
        local added = {
            { name = "clangd", path = vim.env.LOCALAPPDATA .. "/clangd/config.yaml" },
        }
        return vim.iter({common, added}):flatten():totable()
    end

    return common
end

-- Opens a Telescope picker.
function M.picker()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local previewers = require "telescope.previewers"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local config = require "telescope.config".values

    local configs = M.files()

    pickers.new({}, {
        prompt_title = "Config Files",
        finder = finders.new_table {
            results = configs,
            entry_maker = function(entry)
                return {
                    value = entry.path,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        },
        sorter = config.generic_sorter {},
        previewer = previewers.vim_buffer_cat.new {},
        attach_mappings = function(prompt_bufnr, _map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("e " .. selection.value)
            end)
            return true
        end,
    }):find()
end

return M
