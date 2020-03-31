-- Filename:        TargetFramerDimmer.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Mar-29
-- 
-- Top-level Addon file


-- Global TFD Data
TFD                 = {}
TFD.name            = "TargetFrameDimmer"
TFD.addonVersion    = 0.1
TFD.settingsVersion = 0.1

TFD.defaults = {
    ["fadeDurationMs"]      = 1000,
    ["finalOpacity"]        = 50,
    ["preventDimInCombat"]  = true,
}

-----
-- Top-level initialization
-----
function TFD.Initialize(eventCode, addOnName)
    -- Only do stuff for TFD
    if (addOnName ~= TFD.name) then
        return
    end
    d("START INITIALIZING TFD")

    -- Unregister setup event
    EVENT_MANAGER:UnregisterForEvent("TFD", EVENT_ADD_ON_LOADED)

    -- Load Saved Variables
    TFD.vars = ZO_SavedVars:NewAccountWide('TFD_VARS', (TFD.settingsVersion), nil, TFD.defaults)
    
    -- Initialize components
    TFD.TARGET_WINDOW = ZO_TargetUnitFramereticleover
    TFD.Menu:Initialize()

    -- Register for Events
    TFD:RegisterForEvents()

    d("DONE INITIALIZING TFD")
end

-----
-- Event Registration
-----
function TFD:RegisterForEvents()
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_RETICLE_TARGET_CHANGED, TFD.OnTargetChanged)
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_PLAYER_COMBAT_STATE, TFD.OnCombatStateChanged)
end


-----
-- Callback for target change events
-----
function TFD.OnTargetChanged(eventCode)
    -- If prevent-combat-dim enabled, do nothing
    if TFD.vars.preventDimInCombat and
       IsUnitInCombat("player") then
        return
    end

    local unitName = GetUnitNameHighlightedByReticle()

    if (unitName == "") then
        TFD.TARGET_WINDOW:SetHidden(true)
        return
    else
        TFD.TARGET_WINDOW:SetHidden(false)
    end

    local frame = TFD.TARGET_WINDOW
    local opacityOut = 50
    local opacityIn = 100

    -- Create a fade out animation
    local animOut, timeOut = CreateSimpleAnimation(ANIMATION_ALPHA,frame,0)
    animOut:SetAlphaValues(1.0, TFD.vars.finalOpacity/100)
    animOut:SetEasingFunction(ZO_EaseOutQuadratic)  
    animOut:SetDuration(TFD.vars.fadeDurationMs)
    frame.timeline = timeOut

    -- Otherwise perform the appropriate animation
    frame.timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
    frame.timeline:PlayFromStart()
end

-----
-- Callback for Combat State change events
-----
function TFD.OnCombatStateChanged(eventCode, isInCombat)
    -- If prevent-combat-dim disabled, do nothing
    if not TFD.vars.preventDimInCombat then return end

    if isInCombat then
        -- Set full opacity when entering combat
        TFD.TARGET_WINDOW:SetAlpha(1.0)
    else
        -- Trigger animation when exiting combat
        TFD.OnTargetChanged(eventCode)
    end
end

 -- Hook initialization to EVENT_ADD_ON_LOADED
 EVENT_MANAGER:RegisterForEvent("TFD" , EVENT_ADD_ON_LOADED , TFD.Initialize)