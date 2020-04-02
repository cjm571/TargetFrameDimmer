-- Filename:        strings.lua
-- Author:          CJ McAllister
-- Creation Date:   2020-Apr-1
--
-- String definitions.

---
-- Top-level
---
ZO_CreateStringId("TFF_Name", "Target Frame Fader")
ZO_CreateStringId("TFF_Author", "CJ McAllister")

---
-- Menu Components
---

-- In-Combat
ZO_CreateStringId("TFF_InCombat_Header", "In-Combat Options")
ZO_CreateStringId("TFF_InCombat_Opac_Slider_Title", "Opacity (100: fully opaque)")
ZO_CreateStringId("TFF_InCombat_Opac_Slider_Tooltip", "Sets the opacity at the end of the fade effect")
ZO_CreateStringId("TFF_InCombat_Dur_Slider_Title", "Effect Duration (ms)")
ZO_CreateStringId("TFF_InCombat_Dur_Slider_Tooltip", "Sets the duration of the dim effect in milliseconds")


ZO_CreateStringId("TFF_Combat_Dim_Toggle_Title", "Prevent Dimming In Combat")
ZO_CreateStringId("TFF_Combat_Dim_Toggle_Tooltip", "Check this to prevent the Target Frame from dimming during combat")