-- Filename:        menu.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
-- 
-- Menu and settings handling functions



-- Submodule declaration
TFF.Menu = {}
LAM2     = LibAddonMenu2


-----
-- Initialization
-----
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

-----
-- Settings Update
-----
function TFF.Menu.Update(setting, value)
    -- Set new value into settings
    TFF.vars[setting] = value

    -- Re-init animations to reflect new settings
    TFF.Animation:Initialize()
end


-----
-- Menu Creation
-----
function TFF.Menu:PopulateOptions()
    TFF.Menu.options = {
        -----
        -- In-Combat
        -----
        -- Header
        {
            type    = "header",
            name    = GetString(TFF_InCombat_Header),
            width   = "full"
        },
        -- Opacity
        {
            type    = "slider",
            name    = GetString(TFF_Opac_Slider_Title),
            tooltip = GetString(TFF_Opac_Slider_Tooltip),
            min     = 0,
            max     = 100,
            step    = 5,
            getFunc = function() return TFF.vars.inCombatOpacity end,
            setFunc = function(value) TFF.Menu.Update('inCombatOpacity', value) end,
            default = TFF.defaults.inCombatOpacity,
        },
        -- Duration
        {
            type    = "slider",
            name    = GetString(TFF_Dur_Slider_Title),
            tooltip = GetString(TFF_Dur_Slider_Tooltip),
            min     = 500,
            max     = 1000,
            step    = 50,
            getFunc = function() return TFF.vars.inCombatFadeDurationMs end,
            setFunc = function(value) TFF.Menu.Update('inCombatFadeDurationMs', value) end,
            default = TFF.defaults.inCombatFadeDurationMs,
        },
        -----
        -- Out-of-Combat
        -----
        -- Header
        {
            type    = "header",
            name    = GetString(TFF_OutOfCombat_Header),
            width   = "full"
        },
        -- Opacity
        {
            type    = "slider",
            name    = GetString(TFF_Opac_Slider_Title),
            tooltip = GetString(TFF_Opac_Slider_Tooltip),
            min     = 0,
            max     = 100,
            step    = 5,
            getFunc = function() return TFF.vars.outOfCombatOpacity end,
            setFunc = function(value) TFF.Menu.Update('outOfCombatOpacity', value) end,
            default = TFF.defaults.outOfCombatOpacity,
        },
        -- Duration
        {
            type    = "slider",
            name    = GetString(TFF_Dur_Slider_Title),
            tooltip = GetString(TFF_Dur_Slider_Tooltip),
            min     = 500,
            max     = 2000,
            step    = 50,
            getFunc = function() return TFF.vars.outOfCombatFadeDurationMs end,
            setFunc = function(value) TFF.Menu.Update('outOfCombatFadeDurationMs', value) end,
            default = TFF.defaults.outOfCombatFadeDurationMs,
        },
    }
end