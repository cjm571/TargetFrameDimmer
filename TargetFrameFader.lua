-- Filename:        TargetFramerFader.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
--
-- Top-level Addon file


-- Global TFF Data
TFF                 = {}
TFF.name            = "TargetFrameFader"
TFF.addonVersion    = 1.0
TFF.settingsVersion = 1.0

TFF.defaults = {
    ["inCombatOpacity"]             = 100,
    ["inCombatFadeDurationMs"]      = 250,
    ["outOfCombatOpacity"]          = 40,
    ["outOfCombatFadeDurationMs"]   = 500,
}


-----
-- Top-level Initialization
-----
function TFF.Initialize(eventCode, addOnName)
    -- Only do stuff for TFF
    if (addOnName ~= TFF.name) then
        return
    end

    -- Unregister setup event
    EVENT_MANAGER:UnregisterForEvent("TFF", EVENT_ADD_ON_LOADED)

    -- Load Saved Variables
    TFF.vars = ZO_SavedVars:NewAccountWide('TFF_VARS', (TFF.settingsVersion), nil, TFF.defaults)

    -- Initialize components
    TFF.TARGET_FRAME = ZO_TargetUnitFramereticleover
    TFF.Menu:Initialize()
    TFF.Animation:Initialize()

    -- Register for Events
    TFF.Events.Register()
end

 -- Hook initialization to EVENT_ADD_ON_LOADED
 EVENT_MANAGER:RegisterForEvent("TFF" , EVENT_ADD_ON_LOADED , TFF.Initialize)