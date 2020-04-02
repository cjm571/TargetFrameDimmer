-- Filename:        TargetFramerDimmer.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
-- 
-- Menu and settings handling functions


local TFD = TFD
TFD.Menu = {}
LAM2     = LibAddonMenu2

function TFD.Menu:Initialize()

    -- Configure master panel
    TFD.Menu.panel = {
        type                = "panel", 
        name                = GetString(TFD_Name), 
        displayName         = GetString(TFD_Name),
        author              = "cjm571", 
        version             = TFD.version, 
        registerForRefresh  = true,
        registerForDefaults = false,
    }
    -- Setup the initial panel
    LAM2:RegisterAddonPanel("TFD_Menu" , TFD.Menu.panel)

    -- Configure menu control options
    TFD.Menu:PopulateOptions()

    -- Setup the menus
    LAM2:RegisterOptionControls("TFD_Menu", TFD.Menu.options)
end

function TFD.Menu:Update(setting, value)
    TFD.vars[setting] = value
end

function TFD.Menu:PopulateOptions()
    TFD.Menu.options = {
        -- Header
        {
            type    = "header",
            name    = GetString(TFD_Menu_Header),
            width   = "full"
        },

        -- In-Combat Fade Toggle
        {
            type    = "checkbox",
            name    = GetString(TFD_Combat_Dim_Toggle_Title),
            tooltip = GetString(TFD_Combat_Dim_Toggle_Tooltip),
            getFunc = function() return TFD.vars.preventDimInCombat end,
            setFunc = function(state) TFD.Menu:Update('preventDimInCombat', state) end,
            default = TFD.defaults.preventDimInCombat,
        },
        -- Duration Slider
        {
            type    = "slider",
            name    = GetString(TFD_Dur_Slider_Title),
            tooltip = GetString(TFD_Dur_Slider_Tooltip),
            min     = 500,
            max     = 5000,
            step    = 100,
            getFunc = function() return TFD.vars.fadeDurationMs end,
            setFunc = function(value) TFD.Menu:Update('fadeDurationMs', value) end,
            default = TFD.defaults.fadeDurationMs,
        },
        -- Opacity Slider
        {
            type    = "slider",
            name    = GetString(TFD_Opac_Slider_Title),
            tooltip = GetString(TFD_Opac_Slider_Tooltip),
            min     = 0,
            max     = 100,
            step    = 1,
            getFunc = function() return TFD.vars.finalOpacity end,
            setFunc = function(value) TFD.Menu:Update('finalOpacity', value) end,
            default = TFD.defaults.finalOpacity,
        }
    }
end