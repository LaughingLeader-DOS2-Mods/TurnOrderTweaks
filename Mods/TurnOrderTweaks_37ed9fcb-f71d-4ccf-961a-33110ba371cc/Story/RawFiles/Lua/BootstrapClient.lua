local MOD_UUID = "TurnOrderTweaks_37ed9fcb-f71d-4ccf-961a-33110ba371cc"
Ext.Require(MOD_UUID, "Shared/LLTURNTWEAKS_Main.lua")

local ORDER_DROPDOWN_ID = 342
local updateArrayIndex = 0

local function addToUpdateArray(ui, val)
	ui:SetValue("update_Array", val, updateArrayIndex)
	updateArrayIndex = updateArrayIndex + 1
end

local ORDER_MENU_ENTRIES = {
	[0] = {"DISABLED", "Disabled"},
	[1] = {"INITIATIVE", "Initiative"},
	[2] = {"FINESSE", "Finesse",},
	[3] = {"FINESSE_INITIATIVE", "Finesse + Initiative"},
	[4] = {"DND_FINESSE", "Dungeons & Dragons Dexterity (Finesse)"},
	[5] = {"RANDOM", "Random"},
}

local addedDropdown = false

local function LLTURNTWEAKS_Client_AddUIDropdown(ui)
	if ui == nil then
		ui = Ext.GetBuiltinUI("Public/Game/GUI/optionsSettings.swf")
	end
	if ui ~= nil then
		addToUpdateArray(ui, 1) -- Dropdown
		addToUpdateArray(ui, ORDER_DROPDOWN_ID)
		addToUpdateArray(ui, "Turn Order Mode")
		addToUpdateArray(ui, "Sets the turn order system to use in combat.")
		for i,entry in ipairs(ORDER_MENU_ENTRIES) do
			local label = entry[2]
			addToUpdateArray(ui, 2) -- Dropdown Entry
			addToUpdateArray(ui, ORDER_DROPDOWN_ID)
			addToUpdateArray(ui, label)
		end
		ui:Invoke("parseUpdateArray")
		addedDropdown = true
		Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:AddUIDropdown] Added new turn order dropdown to optionsSettings.swf.")
	else
		addedDropdown = false
		Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:AddUIDropdown] Failed to get Public/Game/GUI/optionsSettings.swf")
	end
end

local function OnOptionsMenuEvent(ui, call, ...)
	local params = LeaderLib.Common.FlattenTable({...})
	Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnOptionsMenuEvent] Event called. call("..tostring(call)..") params("..tostring(LeaderLib.Common.Dump(params))..")")
	--if call == "onGameMenuButtonAdded" then
	if call == "switchMenu" and params[1] == 2 then -- Gameplay menu
		if addedDropdown == false then
			LLTURNTWEAKS_Client_AddUIDropdown(ui)
			Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnOptionsMenuEvent] Added dropdown to gameplay menu.")
		end
	elseif call == "comboBoxID" then
		local dropdownID = params[1]
		local selectedIndex = params[2]
		if dropdownID == ORDER_DROPDOWN_ID then
			local selectedOrder = ORDER_MENU_ENTRIES[selectedIndex][1]
			Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnOptionsMenuEvent] Changing turn order mode to ("..tostring(selectedOrder).."). Sending to server.")
			Ext.PostMessageToServer("LLTURNTWEAKS_UpdateTurnOrderMode", selectedOrder)
		end
	elseif call == "requestCloseUI" then
		addedDropdown = false
	end
end

local function LLTURNTWEAKS_Client_ConfigureOptionsUI(...)
	local ui = Ext.GetBuiltinUI("Public/Game/GUI/optionsSettings.swf")
	if ui ~= nil then
		Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:ConfigureOptionsUI] Registered event listeners to optionsSettings.swf.")

		Ext.RegisterUICall(ui, "registeranchorId", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "setAnchor", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "PlaySound", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "requestCloseUI", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "buttonPressed", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "comboBoxID", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "switchMenu", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "onEventInit", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "openMenu", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "executeSelected", OnOptionsMenuEvent)
		Ext.RegisterUICall(ui, "setCursorPosition", OnOptionsMenuEvent)
		return true
	else
		Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:ConfigureOptionsUI] Failed to get Public/Game/GUI/optionsSettings.swf")
	end
	return false
end

Ext.RegisterNetListener("LLTURNTWEAKS_ConfigureOptionsUI", LLTURNTWEAKS_Client_ConfigureOptionsUI)

local function OnGameMenuEvent(ui, call, ...)
	local params = LeaderLib.Common.FlattenTable({...})
	Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnGameMenuEvent] Event called. call("..tostring(call)..") params("..tostring(LeaderLib.Common.Dump(params))..")")
	--if call == "onGameMenuButtonAdded" then
	if call == "buttonPressed" and params[1] == 10 then -- Options button
		if LLTURNTWEAKS_Client_ConfigureOptionsUI() == true then
			Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnGameMenuEvent] Finally hooked into optionsSettings.swf")
		else
			Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:OnGameMenuEvent] Sending (LLTURNTWEAKS_StartClientTimer) message to server.")
			Ext.PostMessageToServer("LLTURNTWEAKS_StartClientTimer", "", nil)
		end
	elseif call == "requestCloseUI" then

	end
end

local function LLTURNTWEAKS_Client_SessionLoaded()
	if LLTURNTWEAKS_Client_ConfigureOptionsUI() == false then
		local gameMenu = Ext.GetBuiltinUI("Public/Game/GUI/gameMenu.swf")
		if gameMenu ~= nil then
			Ext.Print("[LLTURNTWEAKS:BootstrapClient.lua:SessionLoaded] Failed to get Public/Game/GUI/optionsSettings.swf. Hooking into gameMenu.swf")
			Ext.RegisterUICall(gameMenu, "buttonPressed", OnGameMenuEvent)
		end
	end
end

if Ext.Version() >= 43 then
	Ext.RegisterListener("SessionLoaded", LLTURNTWEAKS_Client_SessionLoaded)
end
--Ext.RegisterListener("ModuleLoading", LLTURNTWEAKS_Client_ConfigureOptionsUI)
--Ext.RegisterListener("ModuleResume", LLTURNTWEAKS_Client_ConfigureOptionsUI)

--Ext.RegisterNetListener("LeaderLib_OnClientMessage", OnClientMessage)