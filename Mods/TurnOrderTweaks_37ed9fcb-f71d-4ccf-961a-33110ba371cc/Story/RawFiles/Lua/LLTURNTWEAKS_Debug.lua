local stat_properties_all = {}
--stat_properties_all[#stat_properties_all+1] = "SummonLifelinkModifier"
stat_properties_all[#stat_properties_all+1] = "Strength"
stat_properties_all[#stat_properties_all+1] = "Memory"
stat_properties_all[#stat_properties_all+1] = "Intelligence"
stat_properties_all[#stat_properties_all+1] = "Movement"
stat_properties_all[#stat_properties_all+1] = "MovementSpeedBoost"
stat_properties_all[#stat_properties_all+1] = "Finesse"
stat_properties_all[#stat_properties_all+1] = "Wits"
stat_properties_all[#stat_properties_all+1] = "Constitution"
stat_properties_all[#stat_properties_all+1] = "FireResistance"
stat_properties_all[#stat_properties_all+1] = "EarthResistance"
stat_properties_all[#stat_properties_all+1] = "WaterResistance"
stat_properties_all[#stat_properties_all+1] = "AirResistance"
stat_properties_all[#stat_properties_all+1] = "PoisonResistance"
stat_properties_all[#stat_properties_all+1] = "ShadowResistance"
stat_properties_all[#stat_properties_all+1] = "Willpower"
stat_properties_all[#stat_properties_all+1] = "Bodybuilding"
stat_properties_all[#stat_properties_all+1] = "PiercingResistance"
stat_properties_all[#stat_properties_all+1] = "PhysicalResistance"
stat_properties_all[#stat_properties_all+1] = "CorrosiveResistance"
stat_properties_all[#stat_properties_all+1] = "MagicResistance"
stat_properties_all[#stat_properties_all+1] = "CustomResistance"
stat_properties_all[#stat_properties_all+1] = "Sight"
stat_properties_all[#stat_properties_all+1] = "Hearing"
stat_properties_all[#stat_properties_all+1] = "FOV"
stat_properties_all[#stat_properties_all+1] = "APMaximum"
stat_properties_all[#stat_properties_all+1] = "APStart"
stat_properties_all[#stat_properties_all+1] = "APRecovery"
stat_properties_all[#stat_properties_all+1] = "CriticalChance"
stat_properties_all[#stat_properties_all+1] = "Initiative"
stat_properties_all[#stat_properties_all+1] = "Vitality"
stat_properties_all[#stat_properties_all+1] = "VitalityBoost"
stat_properties_all[#stat_properties_all+1] = "MagicPoints"
stat_properties_all[#stat_properties_all+1] = "Level"
stat_properties_all[#stat_properties_all+1] = "Gain"
stat_properties_all[#stat_properties_all+1] = "Armor"
stat_properties_all[#stat_properties_all+1] = "MagicArmor"
stat_properties_all[#stat_properties_all+1] = "ArmorBoost"
stat_properties_all[#stat_properties_all+1] = "MagicArmorBoost"
stat_properties_all[#stat_properties_all+1] = "ArmorBoostGrowthPerLevel"
stat_properties_all[#stat_properties_all+1] = "MagicArmorBoostGrowthPerLevel"
stat_properties_all[#stat_properties_all+1] = "DamageBoost"
stat_properties_all[#stat_properties_all+1] = "DamageBoostGrowthPerLevel"
stat_properties_all[#stat_properties_all+1] = "Accuracy"
stat_properties_all[#stat_properties_all+1] = "Dodge"
stat_properties_all[#stat_properties_all+1] = "MaxResistance"
stat_properties_all[#stat_properties_all+1] = "LifeSteal"
stat_properties_all[#stat_properties_all+1] = "Weight"
stat_properties_all[#stat_properties_all+1] = "ChanceToHitBoost"
stat_properties_all[#stat_properties_all+1] = "RangeBoost"
stat_properties_all[#stat_properties_all+1] = "APCostBoost"
stat_properties_all[#stat_properties_all+1] = "SPCostBoost"
stat_properties_all[#stat_properties_all+1] = "MaxSummons"
stat_properties_all[#stat_properties_all+1] = "Abilities[40]"
stat_properties_all[#stat_properties_all+1] = "BonusWeaponDamageMultiplier"
stat_properties_all[#stat_properties_all+1] = "Talents"
stat_properties_all[#stat_properties_all+1] = "RemovedTalents"
stat_properties_all[#stat_properties_all+1] = "Traits[18]"
stat_properties_all[#stat_properties_all+1] = "BoostConditionsMask"
stat_properties_all[#stat_properties_all+1] = "TranslationKey"
stat_properties_all[#stat_properties_all+1] = "BonusWeapon"
stat_properties_all[#stat_properties_all+1] = "Reflection"
stat_properties_all[#stat_properties_all+1] = "StepsType"
stat_properties_all[#stat_properties_all+1] = "AttributeFlagsObjectId"

--- Properties from https://github.com/Norbyte/ositools/blob/dd97bb1b289d9bdd4fa08316845e4f1672b2d882/OsiInterface/GameDefinitions/CharacterGetters.inl#L25
local stat_properties = {}
stat_properties[#stat_properties+1] = "MaxMp"
stat_properties[#stat_properties+1] = "APStart"
stat_properties[#stat_properties+1] = "APRecovery"
stat_properties[#stat_properties+1] = "APMaximum"
stat_properties[#stat_properties+1] = "Strength"
stat_properties[#stat_properties+1] = "Finesse"
stat_properties[#stat_properties+1] = "Intelligence"
stat_properties[#stat_properties+1] = "Vitality"
stat_properties[#stat_properties+1] = "Memory"
stat_properties[#stat_properties+1] = "Wits"
stat_properties[#stat_properties+1] = "Accuracy"
stat_properties[#stat_properties+1] = "Dodge"
stat_properties[#stat_properties+1] = "CriticalChance"
stat_properties[#stat_properties+1] = "FireResistance"
stat_properties[#stat_properties+1] = "EarthResistance"
stat_properties[#stat_properties+1] = "WaterResistance"
stat_properties[#stat_properties+1] = "AirResistance"
stat_properties[#stat_properties+1] = "PoisonResistance"
stat_properties[#stat_properties+1] = "ShadowResistance"
stat_properties[#stat_properties+1] = "CustomResistance"
stat_properties[#stat_properties+1] = "LifeSteal"
stat_properties[#stat_properties+1] = "Sight"
stat_properties[#stat_properties+1] = "Hearing"
stat_properties[#stat_properties+1] = "Movement"
stat_properties[#stat_properties+1] = "Initiative"
stat_properties[#stat_properties+1] = "Unknown"
stat_properties[#stat_properties+1] = "ChanceToHitBoost"

function LLTWEAKS_Ext_Lua_DumpTurnCharacterStats(team)
	--local stats_list = stat_properties_all
	local stats_list = stat_properties

	Ext.Print(" --- Stats --- ")
	for k,v in pairs(stats_list) do
		Ext.Print(v .. ": " .. LeaderLib.Common.Dump(team.Character.Stats[v]))
	end
	if team.Character.PlayerCustomData ~= nil then
		Ext.Print("PlayerCustomData: " .. LeaderLib.Common.Dump(team.Character.PlayerCustomData))
		Ext.Print("Name: " .. LeaderLib.Common.Dump(team.Character.PlayerCustomData.Name))
	end
end