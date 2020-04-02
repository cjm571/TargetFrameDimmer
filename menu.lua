-- Filename:        menu.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
-- 
-- Menu and settings handling functions


local TFF = TFF
TFF.Menu = {}
LAM2     = LibAddonMenu2

function TFF.Menu:Initialize()

    -- Configure master panel
    TFF.Menu.panel = {
        type                = "panel", 
        name                = GetString(TFF_Name), 
        displayName         = GetString(TFF_Name),
        author              = "cjm571", 
        version             = TFF.version, 
        registerForRefresh  = true,
        registerForDefaults = false,
    }
    -- Setup the initial panel
    LAM2:RegisterAddonPanel("TFF_Menu" , TFF.Menu.panel)

    -- Configure menu control options
    TFF.Menu:PopulateOptions()

    -- Setup the menus
    LAM2:RegisterOptionControls("TFF_Menu", TFF.Menu.options)
end

function TFF.Menu:Update(setting, value)
    TFF.vars[setting] = value
end

function TFF.Menu:PopulateOptions()
    TFF.Menu.options = {
        -----
        -- Header
        -----
        {
            type    = "header",
            name    = GetString(TFF_Menu_Header),
            width   = "full"
        },

        -----
        -- In-Combat
        -----

        -- Opacity
        {
            type    = "slider",
            name    = GetString(TFF_Opac_Slider_Title),
            tooltip = GetString(TFF_Opac_Slider_Tooltip),
            min     = 0,
            max     = 100,
            step    = 1,
            getFunc = function() return TFF.vars.inCombatOpacity end,
            setFunc = function(value) TFF.Menu:Update('inCombatOpacity', value) end,
            default = TFF.defaults.inCombatOpacity,
        },
        -- Duration
        {
            type    = "slider",
            name    = GetString(TFF_Dur_Slider_Title),
            tooltip = GetString(TFF_Dur_Slider_Tooltip),
            min     = 500,
            max     = 5000,
            step    = 100,
            getFunc = function() return TFF.vars.fadeDurationMs end,
            setFunc = function(value) TFF.Menu:Update('fadeDurationMs', value) end,
            default = TFF.defaults.fadeDurationMs,
        },
    }
end