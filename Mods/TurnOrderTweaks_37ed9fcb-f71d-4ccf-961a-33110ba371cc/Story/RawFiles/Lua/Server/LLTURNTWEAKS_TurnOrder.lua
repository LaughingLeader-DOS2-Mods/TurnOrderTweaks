local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Shared/LLTURNTWEAKS_Main.lua")

local ORDER_MODE = LLTurnTweaks.ORDER_MODE
local TurnOrderMode = LLTurnTweaks.TurnOrderMode

local rolls = {}

local function compare(a,b)
    local score1 = 0
	local score2 = 0
	if TurnOrderMode.id == ORDER_MODE.FINESSE.id then
		if a.Character.Stats.Finesse > b.Character.Stats.Finesse then
			score1 = score1 + 100
		elseif a.Character.Stats.Finesse < b.Character.Stats.Finesse then
			score2 = score2 + 100
		end
	elseif TurnOrderMode.id == ORDER_MODE.INITIATIVE.id then
		if a.Character.Stats.Initiative > b.Character.Stats.Initiative then
			score1 = score1 + 100
		elseif a.Character.Stats.Initiative < b.Character.Stats.Initiative then
			score2 = score2 + 100
		end
	elseif TurnOrderMode.id == ORDER_MODE.FINESSE_INITIATIVE.id then
		if a.Character.Stats.Finesse > b.Character.Stats.Finesse then
			score1 = score1 + 200
		elseif a.Character.Stats.Finesse < b.Character.Stats.Finesse then
			score2 = score2 + 200
		end
		if a.Character.Stats.Initiative > b.Character.Stats.Initiative then
			score1 = score1 + 100
		elseif a.Character.Stats.Initiative < b.Character.Stats.Initiative then
			score2 = score2 + 100
		end
	elseif TurnOrderMode.id == ORDER_MODE.RANDOM.id or TurnOrderMode.id == ORDER_MODE.DND_FINESSE.id then
		if rolls[a].final > rolls[b].final then
			score1 = score1 + 100
		elseif rolls[a].final < rolls[b].final then
			score2 = score2 + 100
		end
	end
    return score1 > score2
end

local function LLTURNTWEAKS_CalculateTurnOrder(combat, order)
	Ext.Print(" --- COMBAT --- ")
	Ext.Print(LeaderLib.Common.Dump(getmetatable(combat)))
	Ext.Print(tostring(combat["CombatId"]))
	Ext.Print(tostring(combat.ID))

	Ext.Print(" --- TURN ORDER MODE --- ")
	Ext.Print("["..tostring(TurnOrderMode.id) .. "] " ..TurnOrderMode.name)
	
    -- Ext.Print(" --- ORDER --- ")
	-- for i,team in pairs(order) do
	-- 	Ext.Print("Team ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Initiative("..tostring(team.Character.Stats.Initiative)..") Finesse("..tostring(team.Character.Stats.Finesse)..")]")
	-- end

	if TurnOrderMode.id == ORDER_MODE.RANDOM.id or TurnOrderMode.id == ORDER_MODE.DND_FINESSE.id then
		rolls = {}

		for i,team in pairs(order) do
			if rolls[team] == nil then
				rolls[team] = LLTurnTweaks.Types.TurnOrderRollData:Create(team)
				LLTWEAKS_Ext_Lua_DumpTurnCharacterStats(team)
			end
		end
		--Ext.Print("Rolls: " .. LeaderLib.Common.Dump(rolls))
	end

	table.sort(order, compare)
	
    Ext.Print(" --- NEXT ORDER --- ")
	for i,team in pairs(order) do
		if TurnOrderMode.id == ORDER_MODE.FINESSE.id then
			Ext.Print("Team ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Finesse("..tostring(team.Character.Stats.Finesse)..")]")
		elseif TurnOrderMode.id == ORDER_MODE.INITIATIVE.id then
			Ext.Print("Team ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Initiative("..tostring(team.Character.Stats.Initiative)..")]")
		elseif TurnOrderMode.id == ORDER_MODE.RANDOM.id or TurnOrderMode.id == ORDER_MODE.DND_FINESSE.id then
			local rollResult = rolls[team]
			Ext.Print("Team ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Roll("..tostring(rollResult.roll)..") Finesse("..tostring(team.Character.Stats.Finesse)..") Modifier("..tostring(rollResult.modifier)..") Final ("..tostring(rollResult.final)..")]")
		end
	end

	combat:UpdateNextTurnOrder(order)

    return order
end

Ext.RegisterListener("CalculateTurnOrder", LLTURNTWEAKS_CalculateTurnOrder)

local function LLTURNTWEAKS_UpdateTurnOrderMode(channel, param)
	local nextOrder = nil
	local paramInt = math.tointeger(param)
	for key,order in pairs(ORDER_MODE) do
		if (paramInt ~= nil and order.id == paramInt) or order.name == param then
			nextOrder = order
			break
		end
	end
	if nextOrder ~= nil then
		LLTurnTweaks.TurnOrderMode = nextOrder
		TurnOrderMode = LLTurnTweaks.TurnOrderMode
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:LLTURNTWEAKS_UpdateTurnOrderMode] Received net message. Changed turn order mode to ("..tostring(nextOrder.name)..").")
	else
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:LLTURNTWEAKS_UpdateTurnOrderMode] [*ERROR*] Received message from client. Value ("..tostring(param)..") is not a valid turn order enum!")
	end
end
Ext.RegisterNetListener("LLTURNTWEAKS_UpdateTurnOrderMode", LLTURNTWEAKS_UpdateTurnOrderMode)

function LLTURNTWEAKS_Ext_SaveTurnOrderMode()
	Osi.LeaderLib_GlobalSettings_SaveIntegerVariable("37ed9fcb-f71d-4ccf-961a-33110ba371cc", "LLTURNTWEAKS_TurnOrderMode", TurnOrderMode.id)
end

function LLTURNTWEAKS_Ext_SetTurnOrderMode(intStr)
	local nextOrderId = math.tointeger(intStr)
	local nextOrder = nil
	if nextOrderId < 0 then nextOrderId = 0 end
	for enumName,enum in pairs(ORDER_MODE) do
		if nextOrderId == enum.id then
			nextOrder = enum
			break
		end
	end
	if nextOrder ~= nil then
		LLTurnTweaks.TurnOrderMode = nextOrder
		TurnOrderMode = LLTurnTweaks.TurnOrderMode
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:SetTurnOrderMode] Loaded global var. Set next turn order mode to ("..tostring(nextOrder.name)..")["..tostring(nextOrder.id).."].")
		Ext.BroadcastMessage("LLTURNTWEAKS_UpdateTurnOrderMode", nextOrder.name, nil)
	end
end