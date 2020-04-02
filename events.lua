-- Filename:        eventHandling.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- Event-handling functions.


-- Submodule declaration
TFD.Events = {}
TFD.Events.lastTargetLost = false -- indicates last reticle event was for an empty target


-----
-- Private Helper Functions
-----

-- Target Acquired
local function targetAcquired()
    -- Register that we most recently acquired a target
    TFD.Events.lastTargetLost = false

    -- Determine combat state and play appropriate animation
    if IsUnitInCombat("player") then
        zo_callLater(
            function() TFD.Animation:PlayInCombat() end,
            1)
    else
        zo_callLater(
            function() TFD.Animation:PlayOutOfCombat() end,
            1)
    end
end

-- Target Lost
local function targetLost()
    -- Register that we most recently lost a target
    TFD.Events.lastTargetLost = true

    -- Hide and reset the animation for the next go-round
    TFD.TARGET_FRAME:SetHidden(true)
    TFD.Animation:Reset()
end

-----
-- Callback Functions
-----

-- Target Changed Event
function TFD.Events.OnTargetChanged(eventCode)
    -- Hide the target frame to avoid flicker if we didn't previously have a target
    if TFD.Events.lastTargetLost then
        TFD.TARGET_FRAME:SetHidden(true)
    end

    -- Pass off handling based on whether we acquired or lost a target
    if GetUnitNameHighlightedByReticle() == "" then
        targetLost()
    else
        targetAcquired()
    end
end

-- Combat State Changed event
function TFD.Events.OnCombatStateChanged(eventCode, isInCombat)
    if isInCombat then
        -- Play forward from out-of-combat alpha
        TFD.Animation:PlayInCombat()
    else
        -- Rewind back to out-of-combat alpha
        TFD.Animation:RewindInCombat()
    end
end


-----
-- ZOS Event Registration
-----
function TFD.Events.Register()
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_RETICLE_TARGET_CHANGED, TFD.Events.OnTargetChanged)
    EVENT_MANAGER:RegisterForEvent("TFD", EVENT_PLAYER_COMBAT_STATE,    TFD.Events.OnCombatStateChanged)
end