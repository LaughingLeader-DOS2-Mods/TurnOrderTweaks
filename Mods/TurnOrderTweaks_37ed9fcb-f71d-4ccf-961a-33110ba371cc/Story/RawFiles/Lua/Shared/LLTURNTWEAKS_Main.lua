Ext.Require("LeaderLib_7e737d2f-31d2-4751-963f-be6ccc59cd0c", "Shared/LeaderLib_Common.lua")

-- Global variables are set up here.

LLTurnTweaks = {
	Types = {}
}

local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Shared/LLTURNTWEAKS_Classes.lua")

local TurnOrderModeEntry = LLTurnTweaks.Types["TurnOrderModeEntry"]
local TranslatedString = LLTurnTweaks.Types["TranslatedString"]

LLTurnTweaks.ORDER_MODE =
{
	INITIATIVE = TurnOrderModeEntry:Create(1, "INITIATIVE", 
		TranslatedString:Create("LLTURNTWEAKS_Order_Initiative_DisplayName", "hd8add845gf6feg4eb3g9d71g05c3c7ba4fce", "Initiative"),
		TranslatedString:Create("LLTURNTWEAKS_Order_Initiative_Description", "h46f805dcgf833g420dg8175g5f50f8202c9d", "Turn order is determined by highest Initiative.")
	),
	FINESSE = TurnOrderModeEntry:Create(2, "FINESSE", 
		TranslatedString:Create("LLTURNTWEAKS_Order_Finesse_DisplayName", "hc80e4571gab11g45fcg9920gdc32234e776f", "Finesse"),
		TranslatedString:Create("LLTURNTWEAKS_Order_Finesse_Description", "h4d0a58a5g7debg4170g937cg084bf0971ac7", "Turn order is determined by highest Finesse.")
	),
	FINESSE_INITIATIVE = TurnOrderModeEntry:Create(3, "FINESSE_INITIATIVE", 
		TranslatedString:Create("LLTURNTWEAKS_Order_FinesseInitiative_DisplayName", "hcb5d021cg88a4g4ec8ga9a0g938e021ea4cb", "Finesse & Initiative"),
		TranslatedString:Create("LLTURNTWEAKS_Order_FinesseInitiative_Description", "h6c916bfbgf30cg46degb035g3e376517c59b", "Turn order is determined by highest Finesse first, then highest Initiative second.")
	),
	DND_FINESSE = TurnOrderModeEntry:Create(4, "DND_FINESSE", 
		TranslatedString:Create("LLTURNTWEAKS_Order_DnDFinesse_DisplayName", "h6ca2d2d0g6ea7g4933g887dgbacf14dbe18c", "D&D Roll Initiative Mode (with Finesse Modifier)"),
		TranslatedString:Create("LLTURNTWEAKS_Order_DnDFinesse_Description", "h5e2905e6g8de1g4732g853bg7a08e702c311", "All characters in combat roll for initiative and add their Finesse value as a modifier.")
	),
	RANDOM = TurnOrderModeEntry:Create(5, "RANDOM", 
		TranslatedString:Create("LLTURNTWEAKS_Order_Random_DisplayName", "hba92cf91g8973g44ecga756gefcb7c818285", "Random"),
		TranslatedString:Create("LLTURNTWEAKS_Order_Random_Description", "haee13e4fga3efg4b2fgb108gfc17a336237d", "Turn order is random.")
	),
	DISABLED = TurnOrderModeEntry:Create(6, "DISABLED", 
		TranslatedString:Create("LLTURNTWEAKS_Order_Disabled_DisplayName", "h20b1f03fg9c7dg4371g83b8g61a5f7a4ede8", "Disabled"),
		TranslatedString:Create("LLTURNTWEAKS_Order_Disabled_Description", "h88e594fcgb0f7g4c70g8201g7761f468f2a8", "Turn order changes are disabled (uses the default game order).")
	),
}

LLTurnTweaks.ORDER_MODE_ORDER = {
	[1] = LLTurnTweaks.ORDER_MODE.INITIATIVE,
	[2] = LLTurnTweaks.ORDER_MODE.FINESSE,
	[3] = LLTurnTweaks.ORDER_MODE.FINESSE_INITIATIVE,
	[4] = LLTurnTweaks.ORDER_MODE.DND_FINESSE,
	[5] = LLTurnTweaks.ORDER_MODE.RANDOM,
	[6] = LLTurnTweaks.ORDER_MODE.DISABLED,
}

LLTurnTweaks.TurnOrderMode = LLTurnTweaks.ORDER_MODE.INITIATIVE;