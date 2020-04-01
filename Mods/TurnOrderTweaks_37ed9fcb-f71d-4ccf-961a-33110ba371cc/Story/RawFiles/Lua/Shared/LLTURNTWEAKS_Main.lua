Ext.Require("LeaderLib_7e737d2f-31d2-4751-963f-be6ccc59cd0c", "Shared/LeaderLib_Common.lua")

-- Global variables are set up here.

local ORDER_MODE = LeaderLib.Common.Enum(
{
	"DISABLED",
	"INITIATIVE",
	"FINESSE",
	"FINESSE_INITIATIVE",
	"DND_FINESSE",
	"RANDOM",
})

LLTurnTweaks = {
	ORDER_MODE = ORDER_MODE,
	TurnOrderMode = ORDER_MODE.DISABLED,
	Types = {}
}

local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Shared/LLTURNTWEAKS_Classes.lua")