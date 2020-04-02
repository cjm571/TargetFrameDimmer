-- Filename:        eventHandling.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- Target Frame animation functions.


-- Submodule declaration
TFD.Animation = {}

-----
-- Initialization
-----
function TFD.Animation:Initialize()
    -- Initialize in-combat animation
    self.inCombatAnim, self.inCombatTimeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFD.TARGET_FRAME, 0)
    self.inCombatAnim:SetAlphaValues(0.0, TFD.vars.inCombatOpacity/100)
    self.inCombatAnim:SetEasingFunction(ZO_EaseOutQuadratic)
    self.inCombatAnim:SetDuration(TFD.vars.fadeDurationMs)
    self.inCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)

    -- Initialize out-of-combat animation
    self.outOfCombatAnim, self.outOfCombatTimeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFD.TARGET_FRAME, 0)
    self.outOfCombatAnim:SetAlphaValues(0.0, TFD.vars.outOfCombatOpacity/100)
    self.outOfCombatAnim:SetEasingFunction(ZO_EaseOutQuadratic)
    self.outOfCombatAnim:SetDuration(TFD.vars.fadeDurationMs)
    self.outOfCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
end


-----
-- Execution
-----

-- Run the given animation forward
function TFD.Animation:RunForward(isInCombat)
    -- Determine appropriate timeline
    local timeline = isInCombat and self.inCombatTimeline or self.outOfCombatTimeline

    -- Unhide and play
    TFD.TARGET_FRAME:SetHidden(false)
    timeline:PlayForward()
    d("Running " .. (isInCombat and "In-Combat" or "Out-of-Combat") .. " animation...")
end

-- Reset animations to starting point
function TFD.Animation:Reset()
    self.inCombatTimeline:Stop()
    self.inCombatTimeline:SetProgress(0)
    
    self.outOfCombatTimeline:Stop()
    self.outOfCombatTimeline:SetProgress(0)
end