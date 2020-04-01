local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Server/LLTURNTWEAKS_TurnOrder.lua")
Ext.Require(MOD_UUID, "Server/LLTURNTWEAKS_Debug.lua")

local GAME_STARTED = false
local startClientTimer = false

function LLTURNTWEAKS_Ext_OnGameStarted()
	GAME_STARTED = true
	if startClientTimer then
		Osi.LLTURNTWEAKS_StartClientTimer()
		startClientTimer = false
	end
end

function LLTURNTWEAKS_Ext_ClearCombatData(combat)

end

function LLTURNTWEAKS_Ext_SetupOptionsMenu()
	Ext.Print("[TurnOrderTweaks:BootstrapServer.lua] Sending (LLTURNTWEAKS_ConfigureOptionsUI) message to clients.")
	Ext.BroadcastMessage("LLTURNTWEAKS_ConfigureOptionsUI", "", nil)
end

local function LLTURNTWEAKS_StartClientTimer(call,data)
	if GAME_STARTED then
		Ext.Print("[TurnOrderTweaks:BootstrapServer.lua:LLTURNTWEAKS_StartClientTimer] Starting client UI check timer.")
		Osi.LLTURNTWEAKS_StartClientTimer()
		startClientTimer = false
	else
		Ext.Print("[TurnOrderTweaks:BootstrapServer.lua:LLTURNTWEAKS_StartClientTimer] Game not started yet. Delaying timer start.")
		startClientTimer = true
	end
end

Ext.RegisterNetListener("LLTURNTWEAKS_StartClientTimer", LLTURNTWEAKS_StartClientTimer)

function LLTURNTWEAKS_Ext_AddRandomFinesse(character)
	local fin = LeaderLib.Common.GetRandom(20, -3)
	CharacterAddAttribute(character, "Finesse", fin)
end

local function LLTURNTWEAKS_Server_GameSessionLoad()
	Ext.Print("[TurnOrderTweaks:BootstrapServer.lua] Session is loading.")
end

--Ext.RegisterListener("SessionLoading", LLTURNTWEAKS_Server_GameSessionLoad)