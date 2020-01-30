local ORDER_MODE = LeaderLib.Common.Enum(
{
	"DISABLED",
	"INITIATIVE",
	"FINESSE",
	"FINESSE_INITIATIVE",
	"DND_FINESSE",
	"RANDOM",
})

local TurnOrderMode = ORDER_MODE.DND_FINESSE

local AttributeBaseValue = 10
local AttributeSoftCap = 40

LLTurnTweaks = {
	Vars = {
		TurnOrderMode = TurnOrderMode,
		AttributeBaseValue = AttributeBaseValue,
		AttributeSoftCap = AttributeSoftCap
	},
	Types = {
		ORDER_MODE = ORDER_MODE
	}
}

Ext.Require("37ed9fcb-f71d-4ccf-961a-33110ba371cc", "LLTURNTWEAKS_Classes.lua")
Ext.Require("37ed9fcb-f71d-4ccf-961a-33110ba371cc", "LLTURNTWEAKS_Debug.lua")

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

function LLTURNTWEAKS_Ext_ClearCombatData(combat)

end

local function CalculateTurnOrder(combat, order)
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

function LLTURNTWEAKS_Ext_AddRandomFinesse(character)
	local fin = LeaderLib.Common.GetRandom(20, -3)
	CharacterAddAttribute(character, "Finesse", fin)
end

local GameSessionLoad = function ()
	Ext.Print("[TurnOrderTweaks:Bootstrap.lua] Session is loading.")
	AttributeBaseValue = tonumber(Ext.ExtraData.AttributeBaseValue)
	AttributeSoftCap = tonumber(Ext.ExtraData.AttributeSoftCap)
	Ext.Print("[LLTURNTWEAKS:GameSessionLoad] ExtraData keys - AttributeBaseValue("..tostring(AttributeBaseValue)..") AttributeSoftCap("..tostring(AttributeSoftCap)..")")
end

local ModuleLoading = function ()
	Ext.Print("[TurnOrderTweaks:Bootstrap.lua] Module is loading.")
end

--v36 and higher
if Ext.RegisterListener ~= nil then
    Ext.RegisterListener("SessionLoading", GameSessionLoad)
	--Ext.RegisterListener("ModuleLoading", ModuleLoading)
	Ext.RegisterListener("CalculateTurnOrder", CalculateTurnOrder)
end

