-- Filename:        TargetFramerDimmer.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
--
-- Top-level Addon file


-- Global TFD Data
TFD                 = {}
TFD.name            = "TargetFrameDimmer"
TFD.addonVersion    = 1.0
TFD.settingsVersion = 1.0

TFD.defaults = {
    ["inCombatFadeDurationMs"]      = 250,
    ["inCombatOpacity"]             = 100,
    ["outOfCombatFadeDurationMs"]   = 500,
    ["outOfCombatOpacity"]          = 50,
}


-----
-- Top-level Initialization
-----
function TFD.Initialize(eventCode, addOnName)
    -- Only do stuff for TFD
    if (addOnName ~= TFD.name) then
        return
    end

    -- Unregister setup event
    EVENT_MANAGER:UnregisterForEvent("TFD", EVENT_ADD_ON_LOADED)

    -- Load Saved Variables
    TFD.vars = ZO_SavedVars:NewAccountWide('TFD_VARS', (TFD.settingsVersion), nil, TFD.defaults)

    -- Initialize components
    TFD.TARGET_FRAME = ZO_TargetUnitFramereticleover
    TFD.Menu:Initialize()
    TFD.Animation:Initialize()

    -- Register for Events
    TFD.Events.Register()
end

 -- Hook initialization to EVENT_ADD_ON_LOADED
 EVENT_MANAGER:RegisterForEvent("TFD" , EVENT_ADD_ON_LOADED , TFD.Initialize)