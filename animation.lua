-- Filename:        animation.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- Target Frame animation functions.


-- Submodule declaration
TFF.Animation = {}

-----
-- Initialization
-----
function TFF.Animation:Initialize()
    -- Initialize in-combat animation
    self.inCombatAnim, self.inCombatTimeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFF.TARGET_FRAME, 0)
    self.inCombatAnim:SetAlphaValues(0.0, TFF.vars.inCombatOpacity/100)
    self.inCombatAnim:SetEasingFunction(ZO_EaseOutQuadratic)
    self.inCombatAnim:SetDuration(TFF.vars.inCombatFadeDurationMs)
    self.inCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)

    -- Initialize out-of-combat animation
    self.outOfCombatAnim, self.outOfCombatTimeline = CreateSimpleAnimation(ANIMATION_ALPHA, TFF.TARGET_FRAME, 0)
    self.outOfCombatAnim:SetAlphaValues(0.0, TFF.vars.outOfCombatOpacity/100)
    self.outOfCombatAnim:SetEasingFunction(ZO_EaseOutQuadratic)
    self.outOfCombatAnim:SetDuration(TFF.vars.outOfCombatFadeDurationMs)
    self.outOfCombatTimeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
end


-----
-- Public Functions
-----

-- Reset animations to starting point
function TFF.Animation:Reset()
    self.inCombatTimeline:Stop()
    self.inCombatTimeline:SetProgress(0)
    
    self.outOfCombatTimeline:Stop()
    self.outOfCombatTimeline:SetProgress(0)
end

-- Play the In-Combat animation
function TFF.Animation:PlayInCombat()
    -- Get the current Alpha level to use as starting point
    local startAlpha = TFF.TARGET_FRAME:GetAlpha()

    -- Update animation parameters
    self.inCombatAnim:SetAlphaValues(startAlpha, TFF.vars.inCombatOpacity/100)

    -- Unhide and play
    TFF.TARGET_FRAME:SetHidden(false)
    self.inCombatTimeline:PlayForward()
end

-- Play the Out-of-Combat animation
function TFF.Animation:PlayOutOfCombat()
    -- Unhide and play
    TFF.TARGET_FRAME:SetHidden(false)
    self.outOfCombatTimeline:PlayForward()
end

-- Rewind In-Combat to Out-of-Combat max alpha
function TFF.Animation:RewindInCombat()
    -- Get the current Alpha level to use as starting point
    local startAlpha = TFF.TARGET_FRAME:GetAlpha()

    -- Update Animation parameters
    self.inCombatAnim:SetAlphaValues(startAlpha, TFF.vars.outOfCombatOpacity/100)

    -- Unhide and play
    TFF.TARGET_FRAME:SetHidden(false)
    self.inCombatTimeline:PlayForward()
end