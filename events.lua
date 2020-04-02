-- Filename:        eventHandling.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- Event-handling functions.


-- Submodule declaration
TFD.Events = {}
TFD.Events.lastTargetLost = false -- indicates last reticle event was for an empty target

-----
-- ZOS Event Registration
-----
function TFD.Events.Register()
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_RETICLE_TARGET_CHANGED, TFD.Events.OnTargetChanged)
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_PLAYER_COMBAT_STATE,    TFD.Events.OnCombatStateChanged)
end


-----
-- Callback for target change events
-----
function TFD.Events.OnTargetChanged(eventCode)
    d("New Target: '" .. GetUnitNameHighlightedByReticle() .."'")
    -- Hide the target frame to avoid flicker if we didn't previously have a target
    if TFD.Events.lastTargetLost then
        TFD.TARGET_FRAME:SetHidden(true)
        d("Initial frame hide complete.")
    end

    -- If we have acquired new target, make a delayed call to run the animation
    if GetUnitNameHighlightedByReticle() ~= "" then
        -- Register that we have acquired a target
        TFD.Events.lastTargetLost = false
        zo_callLater(
            function() TFD.Animation:RunForward(IsUnitInCombat("player")) end,
            1)
        d("Delayed call registered.")
    else
        -- Register that we have lost a target for empty space
        TFD.Events.lastTargetLost = true

        -- Reset the animation for the next go-round
        TFD.Animation:Reset()

        d("Target lost - frame remaining hidden and rewinding animation.")
    end
end

-----
-- Callback for Combat State change events
-----
function TFD.Events.OnCombatStateChanged(eventCode, isInCombat)
    if isInCombat then
        --FIXME: Need anim module function
        -- Stop animation and set full opacity
        TFD.TARGET_FRAME.timeline:Stop()
        TFD.TARGET_FRAME.timeline:SetProgress(0)
        TFD.TARGET_FRAME:SetAlpha(1.0)
    else
        -- Trigger animation when exiting combat
        OnTargetChanged(eventCode)
    end
end