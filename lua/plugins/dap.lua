return { { "mfussenegger/nvim-dap",

config = function()
    local dap = require("dap")

    dap.set_log_level("TRACE")

    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap.exe",
        name = "lldb",
    }

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb.cmd",
            args = {"--port", "${port}"},
        },
    }

    dap.configurations.cpp = {
        {
            name = "Launch",
            type = "codelldb",
            request = "launch",
            program = function()
                local obj = vim.system({"make", "exe-path", "CONFIG=Debug"}, {
                    text = true,
                }):wait()
                if obj.code ~= 0 then return end
                return vim.fn.fnamemodify(vim.fn.trim(obj.stdout), ":p")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }

    vim.keymap.set("n", "<F4>", dap.terminate)
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_out)
    vim.keymap.set("n", "<F12>", dap.step_into)

    vim.keymap.set("n", "<F6>", dap.toggle_breakpoint)
    vim.keymap.set("n", "<F7>", function()
        require("dap").set_breakpoint(vim.fn.input("Condition: "))
    end)

    vim.keymap.set("n", "<F8>", dap.repl.open)
    vim.keymap.set("n", "<F9>", dap.run_to_cursor)

    vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
        text = "?",
        texthl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
    })

    -- Open DAP terminal in new tab
    dap.defaults.fallback.terminal_win_cmd = "tabnew"
end,

} }
