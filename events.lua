-- Filename:        events.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- Event-handling functions.


-- Submodule declaration
TFF.Events = {}

-- Module variables
TFF.Events.lastTargetLost = false -- indicates last reticle event was for an empty target

-- Constants
TFF.Events.CALL_LATER_DELAY_MS = 10


-----
-- Private Helper Functions
-----

-- Target Acquired
local function targetAcquired()
    -- Register that we most recently acquired a target
    TFF.Events.lastTargetLost = false

    -- Determine combat state and play appropriate animation
    if IsUnitInCombat("player") then
        zo_callLater(
            function() TFF.Animation:PlayInCombat() end,
            TFF.Events.CALL_LATER_DELAY_MS)
    else
        zo_callLater(
            function() TFF.Animation:PlayOutOfCombat() end,
            TFF.Events.CALL_LATER_DELAY_MS)
    end
end

-- Target Lost
local function targetLost()
    -- Register that we most recently lost a target
    TFF.Events.lastTargetLost = true

    -- Hide and reset the animation for the next go-round
    TFF.TARGET_FRAME:SetHidden(true)
    TFF.Animation:Reset()
end

-----
-- Callback Functions
-----

-- Target Changed Event
function TFF.Events.OnTargetChanged(eventCode)
    -- Hide the target frame to avoid flicker if we didn't previously have a target
    if TFF.Events.lastTargetLost then
        TFF.TARGET_FRAME:SetHidden(true)
    end

    -- Pass off handling based on whether we acquired or lost a target
    if GetUnitNameHighlightedByReticle() == "" then
        targetLost()
    else
        targetAcquired()
    end
end

-- Combat State Changed event
function TFF.Events.OnCombatStateChanged(eventCode, isInCombat)
    if isInCombat then
        -- Play forward from out-of-combat alpha
        TFF.Animation:PlayInCombat()
    else
        -- Rewind back to out-of-combat alpha
        TFF.Animation:RewindInCombat()
    end
end


-----
-- ZOS Event Registration
-----
function TFF.Events.Register()
    EVENT_MANAGER:RegisterForEvent("TFF", EVENT_RETICLE_TARGET_CHANGED, TFF.Events.OnTargetChanged)
    EVENT_MANAGER:RegisterForEvent("TFF", EVENT_PLAYER_COMBAT_STATE,    TFF.Events.OnCombatStateChanged)
end