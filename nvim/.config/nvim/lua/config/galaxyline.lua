local gl = require('galaxyline')
local gls = gl.section
local condition = require('galaxyline.condition')
gl.short_line_list = {'nerdtree','startify'}

local colors = require('galaxyline.theme').default
colors.section_bg = '#38393f'
colors.purple = '#b16286'

local mode_colors = {
    n = colors.blue,
    i = colors.green,
    c = colors.orange,
    v = colors.magenta,
    V = colors.purple,
    [''] = colors.magenta,
    R = colors.red,
    s = colors.red,
    t = colors.red,
}

local mode_map = {
    n = 'NORMAL',
    i = 'INSERT',
    c = 'COMMAND',
    v = 'VISUAL',
    V = 'VISUAL-LINE',
    [''] = 'VISUAL-BLOCK',
    R = 'REPLACE',
    s = 'SELECT',
    t = 'TERMINAL',
}

local mode_color = function()
    local mode = vim.fn.mode()
    if mode_colors[mode] then
        return mode_colors[mode];
    else
        return colors.blue
    end
end

local mode_alias = function()
    local mode = vim.fn.mode()
    if mode_map[mode] then
        return mode_map[mode];
    else
        return mode
    end
end

gls.short_line_left = {
    {
        FileType = {
            provider = function()
                return vim.bo.buftype
            end,
            highlight = {colors.fg,colors.bg},
        },
    },
}

gls.left = {
    {
        Start = {
            provider = function() return '▊ ' end,
            highlight = {colors.fg,colors.bg},
        },
    },
    {
        ViMode = {
            provider = function()
                vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color())
                return ' ' .. mode_alias() .. ' '
            end,
            highlight = { colors.bg, colors.bg, 'bold' },
            separator = "  ",
            separator_highlight = {colors.bg, colors.section_bg},
        },
    },
    {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.section_bg},
        },
    },
    {
        FileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty,
            highlight = { colors.fg, colors.section_bg },
            separator = "  ",
            separator_highlight = {colors.section_bg, colors.bg},
        }
    },
    {
        FileSize = {
            provider = 'FileSize',
            condition = condition.buffer_not_empty,
            highlight = { colors.fg, colors.bg },
            separator = "  ",
            separator_highlight = {colors.bg, colors.section_bg},
        }
    },
    {
        DiagnosticError = {
            provider = 'DiagnosticError',
            icon = ' ',
            highlight = {colors.red,colors.section_bg}
        }
    },
    {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            icon = ' ',
            highlight = {colors.yellow,colors.section_bg},
        }
    },
    {
        DiagnosticHint = {
            provider = 'DiagnosticHint',
            icon = ' ',
            highlight = {colors.cyan,colors.section_bg},
        }
    },
    {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            icon = ' ',
            highlight = {colors.blue,colors.section_bg},
        }
    },
    {
        ShowLspClient = {
            icon = ': ',
            provider = function() return require('galaxyline.provider_lsp').get_lsp_client() end,
            highlight = {colors.fg,colors.section_bg},
            separator = '  ',
            separator_highlight = { colors.section_bg, colors.bg },
        }
    },
}

gls.right= {
    {
        GitIcon = {
            provider = function() return '  ' end,
            condition = condition.check_git_workspace,
            highlight = {colors.red,colors.section_bg},
            separator = '  ',
            separator_highlight = { colors.bg,colors.section_bg },
        }
    },
    {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            highlight = {colors.fg,colors.section_bg},
        }
    },
    {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {colors.green,colors.section_bg},
        }
    },
    {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width,
            icon = ' 柳',
            highlight= {colors.orange,colors.section_bg},
        }
    },
    {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {colors.red,colors.section_bg},
        }
    },
    {
        FileEncode = {
            provider = 'FileEncode',
            highlight = {colors.cyan,colors.bg,'bold'},
            separator = ' ',
            separator_highlight = { colors.section_bg, colors.bg },
        }
    },
    {
        FileFormat = {
            provider = 'FileFormat',
            highlight = {colors.cyan,colors.bg},
            separator = ' ',
            separator_highlight = { colors.section_bg, colors.bg },
        }
    },
    {
        LineInfo = {
            provider = {'LineColumn', 'LinePercent'},
            highlight = {colors.fg,colors.section_bg},
            separator = '  ',
            separator_highlight = { colors.bg,colors.section_bg },
        },
    },
}
