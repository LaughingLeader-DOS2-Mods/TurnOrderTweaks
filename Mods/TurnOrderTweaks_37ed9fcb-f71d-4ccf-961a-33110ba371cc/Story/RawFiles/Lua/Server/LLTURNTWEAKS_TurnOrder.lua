local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Shared/LLTURNTWEAKS_Main.lua")

--local LLTurnTweaks.ORDER_MODE = LLTurnTweaks.ORDER_MODE
--local LLTurnTweaks.TurnOrderMode = LLTurnTweaks.TurnOrderMode

local CombatRolls = {}

local function compare(a,b)
    local score1 = 0
	local score2 = 0
	if LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.FINESSE.id then
		if a.Character.Stats.Finesse > b.Character.Stats.Finesse then
			score1 = score1 + 100
		elseif a.Character.Stats.Finesse < b.Character.Stats.Finesse then
			score2 = score2 + 100
		end
	elseif LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.INITIATIVE.id then
		if a.Character.Stats.Initiative > b.Character.Stats.Initiative then
			score1 = score1 + 100
		elseif a.Character.Stats.Initiative < b.Character.Stats.Initiative then
			score2 = score2 + 100
		end
	elseif LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.FINESSE_INITIATIVE.id then
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
	elseif LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.RANDOM.id or LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.DND_FINESSE.id then
		if CombatRolls[a].final > CombatRolls[b].final then
			score1 = score1 + 100
		elseif CombatRolls[a].final < CombatRolls[b].final then
			score2 = score2 + 100
		end
	end
    return score1 > score2
end

local function LLTURNTWEAKS_CalculateTurnOrder(combat, order)
	Ext.Print(" --- COMBAT --- ")
	Ext.Print(LeaderLib.Common.Dump(getmetatable(combat)))
	Ext.Print("CombatID" .. tostring(combat.CombatId))

	Ext.Print(" --- TURN ORDER MODE --- ")
	Ext.Print("["..tostring(LLTurnTweaks.TurnOrderMode.id) .. "] " ..LLTurnTweaks.TurnOrderMode.name)
	
    -- Ext.Print(" --- ORDER --- ")
	-- for i,team in pairs(order) do
	-- 	Ext.Print("Team ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Initiative("..tostring(team.Character.Stats.Initiative)..") Finesse("..tostring(team.Character.Stats.Finesse)..")]")
	-- end

	if LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.RANDOM.id or LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.DND_FINESSE.id then
		CombatRolls = {}
		for i,team in pairs(order) do
			if CombatRolls[team] == nil then
				CombatRolls[team] = LLTurnTweaks.Types.TurnOrderRollData:Create(team)
				LLTWEAKS_Ext_Lua_DumpTurnCharacterStats(team)
			end
		end
		--Ext.Print("Rolls: " .. LeaderLib.Common.Dump(CombatRolls))
	end

	table.sort(order, compare)
	
    Ext.Print(" --- NEXT ORDER --- ")
	for i,team in pairs(order) do
		if LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.FINESSE.id then
			Ext.Print("Team Combat("..tostring(team.CombatId)..") ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Finesse("..tostring(team.Character.Stats.Finesse)..")]")
		elseif LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.INITIATIVE.id then
			Ext.Print("Team Combat("..tostring(team.CombatId)..") ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Initiative("..tostring(team.Character.Stats.Initiative)..")]")
		elseif LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.RANDOM.id or LLTurnTweaks.TurnOrderMode.id == LLTurnTweaks.ORDER_MODE.DND_FINESSE.id then
			local rollResult = CombatRolls[team]
			Ext.Print("Team Combat("..tostring(team.CombatId)..") ID("..tostring(team.TeamId)..") Team Initiative("..tostring(team.Initiative)..") StillInCombat("..tostring(team.StillInCombat)..") Character[Roll("..tostring(rollResult.roll)..") Finesse("..tostring(team.Character.Stats.Finesse)..") Modifier("..tostring(rollResult.modifier)..") Final ("..tostring(rollResult.final)..")]")
		end
	end

	combat:UpdateNextTurnOrder(order)

    return order
end

Ext.RegisterListener("CalculateTurnOrder", LLTURNTWEAKS_CalculateTurnOrder)

local function LLTURNTWEAKS_UpdateTurnOrderMode(channel, param)
	local nextOrder = nil
	local paramInt = math.tointeger(param)
	for key,order in pairs(LLTurnTweaks.ORDER_MODE) do
		if (paramInt ~= nil and order.id == paramInt) or order.name == param then
			nextOrder = order
			break
		end
	end
	if nextOrder ~= nil then
		LLTurnTweaks.TurnOrderMode = LLTurnTweaks.TurnOrderMode
		LLTURNTWEAKS_Ext_SetDialogOrderVariable()
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:LLTURNTWEAKS_UpdateTurnOrderMode] Received net message. Changed turn order mode to ("..tostring(nextOrder.name)..").")
	else
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:LLTURNTWEAKS_UpdateTurnOrderMode] [*ERROR*] Received message from client. Value ("..tostring(param)..") is not a valid turn order enum!")
	end
end
Ext.RegisterNetListener("LLTURNTWEAKS_UpdateTurnOrderMode", LLTURNTWEAKS_UpdateTurnOrderMode)

function LLTURNTWEAKS_Ext_SetDialogOrderVariable()
	local currentMode = LLTurnTweaks.TurnOrderMode
	--Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:SetDialogOrderVariable] Updating dialog var with mode ("..LeaderLib.Common.Dump(currentMode)..")")
	Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:SetDialogOrderVariable] Updating dialog var with mode ("..currentMode.name..")")

	DialogSetVariableTranslatedString("LLTURNTWEAKS_SettingsMenu", "LLTURNTWEAKS_CurrentOrderModeDisplayName_8fcb5a53-8c9c-4239-a427-6ce8d4e1f606", currentMode.DisplayName.Handle, currentMode.DisplayName.Content)
	DialogSetVariableTranslatedString("LLTURNTWEAKS_SettingsMenu", "LLTURNTWEAKS_CurrentOrderModeDescription_46c06644-40ff-4041-a7c6-2efd4f85f31e", currentMode.Description.Handle, currentMode.Description.Content)
end

function LLTURNTWEAKS_Ext_SaveTurnOrderMode()
	Osi.LeaderLib_GlobalSettings_SaveIntegerVariable("37ed9fcb-f71d-4ccf-961a-33110ba371cc", "LLTURNTWEAKS_TurnOrderMode", LLTurnTweaks.TurnOrderMode.id)
end

function LLTURNTWEAKS_Ext_SetTurnOrderMode(intStr)
	local nextOrderId = math.tointeger(intStr)
	local nextOrder = nil
	if nextOrderId < 0 then nextOrderId = 0 end
	for enumName,enum in pairs(LLTurnTweaks.ORDER_MODE) do
		if nextOrderId == enum.id then
			nextOrder = enum
			break
		end
	end
	if nextOrder ~= nil then
		LLTurnTweaks.TurnOrderMode = nextOrder
		LLTURNTWEAKS_Ext_SetDialogOrderVariable()
		Ext.Print("[LLTURNTWEAKS_TurnOrder.lua:SetTurnOrderMode] Set next turn order mode to ("..tostring(nextOrder.name)..")["..tostring(nextOrder.id).."].")
		Osi.LLTURNTWEAKS_SetTurnOrderMode(nextOrder.id)
		--Ext.BroadcastMessage("LLTURNTWEAKS_UpdateTurnOrderMode", nextOrder.name, nil)
	end
end

function LLTURNTWEAKS_Ext_CycleNextMode()
	local nextIndex = LLTurnTweaks.TurnOrderMode.id + 1
	local max = #LLTurnTweaks.ORDER_MODE_ORDER
	if nextIndex > max then
		nextIndex = 1
	end
	--Ext.Print("Next order index: " .. tostring(nextIndex) .. " / " .. tostring(max) .. " | " .. tostring(LLTurnTweaks.TurnOrderMode.id))
	local nextOrder = LLTurnTweaks.ORDER_MODE_ORDER[nextIndex]
	if nextOrder == nil then
		--Ext.Print("Failed to find enum at index: " .. tostring(nextIndex))
		nextOrder = LLTurnTweaks.ORDER_MODE_ORDER[1]
	end
	LLTurnTweaks.TurnOrderMode = nextOrder
	LLTURNTWEAKS_Ext_SetDialogOrderVariable()
end

function LLTURNTWEAKS_Ext_CyclePreviousMode()
	local nextIndex = LLTurnTweaks.TurnOrderMode.id - 1
	if nextIndex < 1 then
		nextIndex = #LLTurnTweaks.ORDER_MODE_ORDER
	end
	local nextOrder = LLTurnTweaks.ORDER_MODE_ORDER[nextIndex]
	if nextOrder == nil then
		--Ext.Print("Failed to find enum at index: " .. tostring(nextIndex))
		nextOrder = LLTurnTweaks.ORDER_MODE_ORDER[#LLTurnTweaks.ORDER_MODE_ORDER]
	end
	--Ext.Print("Next order index: " .. tostring(nextIndex) .. " / " .. tostring(max))
	LLTurnTweaks.TurnOrderMode = nextOrder
	LLTURNTWEAKS_Ext_SetDialogOrderVariable()
end