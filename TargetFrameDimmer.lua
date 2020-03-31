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

    -- Unregister setup event
    EVENT_MANAGER:UnregisterForEvent("TFD", EVENT_ADD_ON_LOADED)

    -- Load Saved Variables
    TFD.vars = ZO_SavedVars:NewAccountWide('TFD_VARS', (TFD.settingsVersion), nil, TFD.defaults)
    
    -- Initialize components
    TFD.TARGET_WINDOW = ZO_TargetUnitFramereticleover
    TFD.Menu:Initialize()

    -- Create a fade out animation and timeline
    TFD.TARGET_WINDOW.anim, TFD.TARGET_WINDOW.timeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFD.TARGET_WINDOW, 0)
    TFD.TARGET_WINDOW.anim:SetAlphaValues(1.0, TFD.vars.finalOpacity/100)
    TFD.TARGET_WINDOW.anim:SetEasingFunction(ZO_EaseOutQuadratic)  
    TFD.TARGET_WINDOW.anim:SetDuration(TFD.vars.fadeDurationMs)

    TFD.TARGET_WINDOW.timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)

    -- Register for Events
    TFD:RegisterForEvents()
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

    -- Gather current target data
    local curUnitName = GetUnitNameHighlightedByReticle()

    -- Hide Target Frame when reticle leaves target to avoid flashing
    if (curUnitName == "") then
        TFD.TARGET_WINDOW:SetHidden(true)
        
        -- Stop and reset progress to avoid "sticking" after animation completes
        TFD.TARGET_WINDOW.timeline:Stop()
        TFD.TARGET_WINDOW.timeline:SetProgress(0)
        return
    else
         -- Ensure reticle is not hidden when we get a new target
        TFD.TARGET_WINDOW:SetHidden(false)
    end

    -- Play from current point in animation timeline
    TFD.TARGET_WINDOW.timeline:PlayForward()
end

-----
-- Callback for Combat State change events
-----
function TFD.OnCombatStateChanged(eventCode, isInCombat)
    -- If prevent-combat-dim disabled, do nothing
    if not TFD.vars.preventDimInCombat then return end

    if isInCombat then
        -- Stop animation and set full opacity when entering combat
        TFD.TARGET_WINDOW.timeline:PlayInstantlyToStart()
    else
        -- Trigger animation when exiting combat
        TFD.OnTargetChanged(eventCode)
    end
end

 -- Hook initialization to EVENT_ADD_ON_LOADED
 EVENT_MANAGER:RegisterForEvent("TFD" , EVENT_ADD_ON_LOADED , TFD.Initialize)