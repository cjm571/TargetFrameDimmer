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
    self.inCombatAnim:SetDuration(TFD.vars.inCombatFadeDurationMs)
    self.inCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)

    -- Initialize out-of-combat animation
    self.outOfCombatAnim, self.outOfCombatTimeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFD.TARGET_FRAME, 0)
    self.outOfCombatAnim:SetAlphaValues(0.0, TFD.vars.outOfCombatOpacity/100)
    self.outOfCombatAnim:SetEasingFunction(ZO_EaseOutQuadratic)
    self.outOfCombatAnim:SetDuration(TFD.vars.outOfCombatFadeDurationMs)
    self.outOfCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
end


-----
-- Public Functions
-----

-- Reset animations to starting point
function TFD.Animation:Reset()
    self.inCombatTimeline:Stop()
    self.inCombatTimeline:SetProgress(0)
    
    self.outOfCombatTimeline:Stop()
    self.outOfCombatTimeline:SetProgress(0)
end

-- Play the In-Combat animation
function TFD.Animation:PlayInCombat()
    -- Get the current Alpha level to use as starting point
    local startAlpha = TFD.TARGET_FRAME:GetAlpha()

    -- Update animation parameters
    self.inCombatAnim:SetAlphaValues(startAlpha, TFD.vars.inCombatOpacity/100)

    -- Unhide and play
    TFD.TARGET_FRAME:SetHidden(false)
    self.inCombatTimeline:PlayForward()
end

-- Play the Out-of-Combat animation
function TFD.Animation:PlayOutOfCombat()
    -- Unhide and play
    TFD.TARGET_FRAME:SetHidden(false)
    self.outOfCombatTimeline:PlayForward()
end

-- Rewind In-Combat to Out-of-Combat max alpha
function TFD.Animation:RewindInCombat()
    -- Get the current Alpha level to use as starting point
    local startAlpha = TFD.TARGET_FRAME:GetAlpha()

    -- Update Animation parameters
    self.inCombatAnim:SetAlphaValues(startAlpha, TFD.vars.outOfCombatOpacity/100)

    -- Unhide and play
    TFD.TARGET_FRAME:SetHidden(false)
    self.inCombatTimeline:PlayForward()
end