--Ext.Require("LeaderLib_7e737d2f-31d2-4751-963f-be6ccc59cd0c", "Shared/LeaderLib_Common.lua")

---@class TranslatedString
local TranslatedString = {
	Handle = "",
	Key = "",
	Content = "",
}
TranslatedString.__index = TranslatedString

function TranslatedString:Create(key,handle,content)
    local this =
    {
		Handle = handle,
		Key = key,
		Content = content
	}
	setmetatable(this, self)
    return this
end
LLTurnTweaks.Types["TranslatedString"] = TranslatedString

---@class TurnOrderModeEntry
local TurnOrderModeEntry = {
	name = "",
	---@type integer
	id = -1,
	---@type TranslatedString
	DisplayName = {},
	---@type TranslatedString
	Description = {},
}

TurnOrderModeEntry.__index = TurnOrderModeEntry

---@param id integer
---@param name string
---@param displayName TranslatedString
---@param description TranslatedString
function TurnOrderModeEntry:Create(id,name,displayName,description)
    local this =
    {
		id = id,
		name = name,
		DisplayName = displayName,
		Description = description
	}
	setmetatable(this, self)
    return this
end
LLTurnTweaks.Types["TurnOrderModeEntry"] = TurnOrderModeEntry

---@class TurnOrderData
local TurnOrderData = {
	combatid = 0,
	rolldata = {}
}

TurnOrderData.__index = TurnOrderData

function TurnOrderData:Create(combatid)
    local this =
    {
		combatid = combatid
	}
	setmetatable(this, self)
    return this
end
LLTurnTweaks.Types["TurnOrderData"] = TurnOrderData

---@class TurnOrderRollData
local TurnOrderRollData = {
	roll = 0,
	modifier = 0,
	final = 0,
	team = nil
}

TurnOrderRollData.__index = TurnOrderRollData

--- RANDOM mode: Rolls between 0-999.
--- DND_FINESSE mode: Rolls from 1-20, applying finesse modifiers if enabled.
function TurnOrderRollData:Roll()
	if LLTurnTweaks.Vars.TurnOrderMode.id == LLTurnTweaks.Types.ORDER_MODE.DND_FINESSE.id then
		self.roll = LeaderLib.Common.GetRandom(20, 1)
		self.modifier = math.floor((self.team.Character.Stats.Finesse - (Ext.ExtraData.AttributeBaseValue - 0.1)) / 2)
		self.final = math.max(self.roll + self.modifier, 1)
	else
		self.roll = LeaderLib.Common.GetRandom(999)
		self.final = self.roll
	end
end

function TurnOrderRollData:Create(team)
    local this =
    {
		roll = 0,
		modifier = 0,
		final = 0,
		team = team
	}
	setmetatable(this, self)
	this.Roll(this)
    return this
end
LLTurnTweaks.Types["TurnOrderRollData"] = TurnOrderRollData