local addonName, bdt = ...

local config = bdConfigLib.profile['Tooltips']


-----------------------------------
-- Skinning default tooltips
-----------------------------------
function bdt:skin(tooltip)
	if (not tooltip.background) then
		bdCore:setBackdrop(tooltip)
	end
	bdCore:StripTextures(tooltip)
	tooltip:SetScale(1)
end
-- for skinning all the tooltips in the UI
local tooltips = {
	'GameTooltip',
	'ItemRefTooltip',
	'ItemRefShoppingTooltip1',
	'ItemRefShoppingTooltip2',
	'ShoppingTooltip1',
	'ShoppingTooltip2',
	'DropDownList1MenuBackdrop',
	'DropDownList2MenuBackdrop',
	'WorldMapTooltip',
	'WorldMapCompareTooltip1',
	'WorldMapCompareTooltip2',
}

for i = 1, #tooltips do
	local frame = _G[tooltips[i]]
	bdt:skin(frame)
end

local function whosTargeting(self)
	local name, unit = self:GetUnit()
	if not unit then return end
	
	local targeting = {}
	local num = 0
	
	if IsInRaid() then
		for i = 1, 40 do
			local raider = "raid"..i
			if not UnitExists(raider) then break end
			local name = GetUnitName(raider,false)
			
			if (UnitIsUnit(raider.."target", unit)) then
				num = num + 1
				targeting[name] = name
			end
		end
		
		local str = "";
		for k, v in pairs(targeting) do
			str = str..k", "
		end
		
		GameTooltip:AddLine("Targ: "..str);
	end
end



local hide = {}
hide["Horde"] = true
hide["Alliance"] = true
hide["PvE"] = true
hide["PvP"] = true

function setUnit(self)
	if (not config.enablett) then return end -- disable these, in case people only want mouseover mini-tooltips and don't want to use full bdTooltips
	if (self:IsForbidden()) then return end -- don't mess with forbidden frames, which sometimes randomly happens
		
	-- bdCore:StripTextures(self)

	local name, unit = self:GetUnit()
	if not unit then
		unit = GetMouseFocus() and GetMouseFocus():GetAttribute("unit")
	end
	if not unit then return end

	-- now lets modify the tooltip
	local numLines = self:NumLines()

	local line = 1;
	name = GetUnitName(unit)
	local guild, rank = GetGuildInfo(unit)
	local race = UnitRace(unit) or ""
	local classification = UnitClassification(unit)
	local creatureType = UnitCreatureType(unit)
	local factionGroup = select(1, UnitFactionGroup(unit))
	local reactionColor = bdt:getReactionColor(unit)
	

	local level = UnitLevel(unit)
	local levelColor = GetQuestDifficultyColor(level)
	if level == -1 then
		level = '??'
		levelColor = {r = 1,g = 0,b = 0}
	end

	local isFriend = UnitIsFriend("player", unit)
	local friendColor = {r = 1, g = 1, b = 1}
	if (factionGroup == 'Horde' or not isFriend) then
		friendColor = {
			r = 1, 
			g = 0.15,
			b = 0
		}
	else
		friendColor = {
			r = 0, 
			g = 0.55, 
			b = 1
		}
	end

	-- Tags
	local dnd = function()
		return UnitIsAFK(unit) and "|cffAAAAAA<AFK>|r " or UnitIsDND(unit) and "|cffAAAAAA<DND>|r " or ""
	end

	-- build the tooltip and its lines
	local lines = {}
	lines[1] = GameTooltipTextLeft1:GetText()
	
	if UnitIsPlayer(unit) then
		GameTooltipTextLeft1:SetFormattedText('%s%s', dnd(), UnitName(unit))
		if guild then
			GameTooltipTextLeft2:SetFormattedText('%s <%s>', rank, guild)
			GameTooltipTextLeft3:SetFormattedText('|cff%s%s|r |cff%s%s|r', RGBPercToHex(levelColor), level, RGBPercToHex(friendColor), race)
		else
			GameTooltip:AddLine("",1,1,1)
			GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r |cff%s%s|r', RGBPercToHex(levelColor), level, RGBPercToHex(friendColor), race)
		end
	else
		for i = 2, numLines do
			local line = _G['GameTooltipTextLeft'..i]
			if not line or not line:GetText() then break end
			if (level and line:GetText():find('^'..LEVEL) or (creatureType and line:GetText():find('^'..creatureType))) then
				line:SetFormattedText('|cff%s%s %s|r |cff%s%s|r', RGBPercToHex(levelColor), level, classification, RGBPercToHex(friendColor), creatureType or 'Unknown')
			end
		end
	end

	-- delete lines in the "hide" table
	for k, v in pairs(hide)do
		GameTooltip:DeleteLine(k, true)
	end

	if (UnitExists(unit..'target')) then
		local r, g, b = bdt:getReactionColor(unit..'target')
		GameTooltip:AddDoubleLine("Target", UnitName(unit..'target'), .7, .7, .7, r, g, b)
	end

	--[[if UnitIsPlayer(unit) then
		--GameTooltip:ClearLines();
		local r, g, b = GameTooltip_UnitColor(unit)
		GameTooltip:AddLine(UnitName(unit), r, g, b)
		if (guild) then GameTooltip:AddLine(guild,1,1,1) end
		GameTooltip:AddLine("|cff"..RGBToHex(levelColor)..level.."|r |cff"..RGBToHex(friendColor)..race.."|r")
		local r, g, b = GameTooltip_UnitColor(unit..'target')
		GameTooltip:AddLine(UnitName(unit..'target'), r, g, b)
	else
		for i = 2, lines do
			local line = _G['GameTooltipTextLeft'..i]
			if not line or not line:GetText() then break end
			if (level and line:GetText():find('^'..LEVEL) or (creatureType and line:GetText():find('^'..creatureType))) then
				line:SetFormattedText('|cff%s%s%s|r |cff%s%s|r', RGBToHex(levelColor), level, classification, RGBToHex(friendColor), creatureType or 'Unknown')
			end
		end
	end--]]
	
	--whosTargeting(self)
	--]]
	--[[GameTooltipTextLeft1:SetText(name)
	local name, class = UnitClass(name) or UnitClass("mouseover")
	local color = RAID_CLASS_COLORS[class]--]]
	--local targetclassFileName = select(2, UnitClass("mouseover"))
	--color = RAID_CLASS_COLORS[targetclassFileName]
	--[[if (color) then
		GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
	end--]]
	
	if level == -1 then
		level = '??'
		levelColor = {r = 1,g = 0,b = 0}
	end
	
	local linetext = _G['GameTooltipTextLeft'..line]
	
	--left[line]:SetFormattedText("%s%s|r %s%s|r %s%s|r", lhex, level, "|cffddeeaa", race, classHexColors[enClass], class)
	
	--[[if UnitIsPlayer(unit) then		
		if guild then
			GameTooltipTextLeft2:SetFormattedText('<%s>', guild)
			GameTooltipTextLeft3:SetFormattedText('|cff%s%s|r |cff%s%s|r', RGBToHex(levelColor), level, RGBToHex(friendColor), race)
		else
			GameTooltip:AddLine("",1,1,1)
			GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r |cff%s%s|r', RGBToHex(levelColor), level, RGBToHex(friendColor), race)
		end
		
		local r, g, b = GameTooltip_UnitColor(unit..'target')
		GameTooltip:AddLine(UnitName(unit..'target'), r, g, b)

	else
		for i = 2, lines do
			local line = _G['GameTooltipTextLeft'..i]
			if not line or not line:GetText() then break end
			if (level and line:GetText():find('^'..LEVEL) or (creatureType and line:GetText():find('^'..creatureType))) then
				line:SetFormattedText('|cff%s%s%s|r |cff%s%s|r', RGBToHex(levelColor), level, classification, RGBToHex(friendColor), creatureType or 'Unknown')
			end
			
		end
	end--]]
	
	-- Update hp values on the bar
	local hp = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	
	GameTooltipStatusBar.unit = unit
	GameTooltipStatusBar:SetMinMaxValues(0, max)
	GameTooltipStatusBar:SetValue(hp)
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
	GameTooltipStatusBar:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 6)

	-- Set Fonts
	for i = 1, 20 do
		local line = _G['GameTooltipTextLeft'..i]
		if not line then break end
		line:SetFont(bdCore.media.font, 14)
	end
end

-- add text to the healthbar on tooltips
GameTooltipStatusBar.text = GameTooltipStatusBar:CreateFontString(nil)
GameTooltipStatusBar.text:SetFont(bdCore.media.font, 11, "THINOUTLINE")
GameTooltipStatusBar.text:SetAllPoints()
GameTooltipStatusBar.text:SetJustifyH("CENTER")
GameTooltipStatusBar.text:SetJustifyV("MIDDLE")

-- GameTooltipStatusBar:ClearAllPoints()
-- GameTooltipStatusBar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -6)
-- GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT")
GameTooltipStatusBar:SetStatusBarTexture(bdCore.media.smooth)
bdCore:setBackdrop(GameTooltipStatusBar)

-- this sucks at updating while you are hovering
GameTooltipStatusBar:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
GameTooltipStatusBar:RegisterEvent("UNIT_HEALTH")
GameTooltipStatusBar:SetScript("OnEvent", function(self)
	if (not self.unit) then return end

	local hp, max = UnitHealth(self.unit), UnitHealthMax(self.unit)
	self:SetMinMaxValues(0, max)
	self:SetValue(hp)
	self:SetStatusBarColor( bdt:getReactionColor(self.unit))

	local perc = 0
	if (hp > 0 and max > 0) then
		perc = math.floor((hp / max) * 100)
	end
	if (not max) then
		perc = ''
	end
	self.text:SetText(perc)
end)

---------------------------------------------------------------------
-- hook main styling functions
---------------------------------------------------------------------
GameTooltip:HookScript('OnTooltipSetUnit', setUnit)
function GameTooltip_UnitColor(unitToken) return bdt:getReactionColor(unitToken) end


--GameTooltip:SetScript('OnUpdate', setFirstLine)

--[[
GameTooltip:HookScript('OnTooltipSetUnit', function(self)
	-- if they are dead
	if strmatch(left[1]:GetText(), CORPSE_TOOLTIP) then
		return left[1]:SetTextColor(0.5, 0.5, 0.5)
	end
	
	-- fuckery to get the right unit
	local name, unit = self:GetUnit()
	if not unit then
		local mouseFocus = GetMouseFocus()
		unit = mouseFocus and mouseFocus:GetAttribute("unit")
	end
	if not unit and UnitExists("mouseover") then
		unit = "mouseover"
	end
	if not unit then
		return self:Hide()
	end
	if unit ~= "mouseover" and UnitIsUnit(unit, "mouseover") then
		unit = "mouseover"
	end
	self.currentUnit = unit
	
	local canAttack = UnitCanAttack(unit, "player") or UnitCanAttack("player", unit)
	local level = UnitIsBattlePet(unit) and UnitBattlePetLevel(unit) or UnitLevel(unit)
	--local lhex = canAttack and GetDifficultyLevelColor(level ~= -1 and level or 500) or "|cffffcc00"
	level = level > 0 and level or "??"
	--local reaction = GetUnitReactionIndex(unit)
	local isPlayer = UnitIsPlayer(unit)
	
	if UnitIsPlayer(unit) then
		local class = select(2,UnitClass(unit))
		if (class) then
			local color = RAID_CLASS_COLORS[class]
			GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
		end
		GameTooltipTextLeft1:SetText(name)
		
		-- Guild
	else
	
	end
	
	
	--print(color)
end)--]]


--[[
function defaultPosition(self, parent)
	self:SetOwner(parent, "ANCHOR_CURSOR")
	self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -111111, -111111) -- hack to update GameStatusBar instantly.
	self:ClearAllPoints()
end--]]
--hooksecurefunc('GameTooltip_SetDefaultAnchor', defaultPosition)

-- _G["GameTooltip"]:HookScript("OnUpdate", function(self) 
	-- self:ClearAllPoints()
	-- local x, y = GetCursorPosition();
	-- self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x / UIParent:GetEffectiveScale())+80+(self:GetWidth()/2), (y / UIParent:GetEffectiveScale()))
-- end)

---------------------------------------------
--	Modify default position
---------------------------------------------
local tooltipanchor = CreateFrame("frame","bdTooltip",UIParent)
tooltipanchor:SetSize(150, 100)
tooltipanchor:SetPoint("TOPRIGHT", UIParent, "RIGHT", -20, -100)
bdCore:makeMovable(tooltipanchor)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	self:SetOwner(parent, "ANCHOR_NONE")
	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT", tooltipanchor)

	bdt:skin(self)
end)

---------------------------------------------
-- Tooltip Icons / Tooltip ItemIDs
---------------------------------------------
local function addIcons(self, event, message, ...)
	local function Icon(link)
		local texture = GetItemIcon(link)
		return "\124T" .. texture .. ":" .. 12 .. "\124t" .. link
	end
	message = message:gsub("(\124c%x+\124Hitem:.-\124h\124r)", Icon)
	return false, message, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TRADESKILLS", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", addIcons)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", addIcons)

local function onSetHyperlink(self, link)
	bdt:skin(self)
	local type, id = string.match(link,"^(%a+):(%d+)")
	if not type or not id then return end
	if type == "item" then
		if not config.enableitemids then return end
		GameTooltip:AddDoubleLine("ItemID:", id)
	elseif type == "currency" then
		GameTooltip:AddDoubleLine("CurrencyID:", id)
	elseif type == "spell" then
		if not config.enablespellids then return end
		GameTooltip:AddDoubleLine("SpellID:", id)
	end

end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

local function setSpellID(self)
	bdt:skin(self)
	if (not config.enablespellids) then return end
	local id = select(3, self:GetSpell())
	if (id) then
		GameTooltip:AddDoubleLine("SpellID:", id)
	end
end

local function setItemID(self)
	bdt:skin(self)
	if (not config.enableitemids) then return end
	local link = select(2, self:GetItem())
	if link then
		local itemString = string.match(link, "item[%-?%d:]+")
		if (not itemString) then return end
		local id = select(2, strsplit(":", itemString))
		if id then
			GameTooltip:AddDoubleLine("itemID:", id)
		end
	end
end

GameTooltip:HookScript("OnTooltipSetSpell", setSpellID)
GameTooltip:HookScript("OnTooltipSetItem", setItemID)
ItemRefTooltip:HookScript("OnTooltipSetItem", setItemID)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", setItemID)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", setItemID)
ShoppingTooltip1:HookScript("OnTooltipSetItem", setItemID)
ShoppingTooltip2:HookScript("OnTooltipSetItem", setItemID)

hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
	local id = tonumber(string.match(GetCurrencyListLink(index),"currency:(%d+)"))
	if (not id) then return end
	GameTooltip:AddDoubleLine("CurrencyID:", id)
end)

hooksecurefunc(GameTooltip, "SetCurrencyByID", function(self, id)
	if (not id) then return end
	GameTooltip:AddDoubleLine("CurrencyID:", id)
end)

hooksecurefunc(GameTooltip, "SetCurrencyTokenByID", function(self, id)
	if (not id) then return end
	GameTooltip:AddDoubleLine("CurrencyID:", id)
end)

----------------------------------------------
-- Neat Colors to things
----------------------------------------------
COOLDOWN_REMAINING = "|CFF999999Cooldown remaining|r"
ENERGY_COST = "%s |CFFFFFF00Energy|r"
ITEM_COOLDOWN_TIME = "|CFF999999Cooldown remaining|r %s";
ITEM_COOLDOWN_TIME_DAYS = "|CFF999999Cooldown remaining|r %d |4day:days;"
ITEM_COOLDOWN_TIME_HOURS = "|CFF999999Cooldown remaining|r %d |4hour:hours;"
ITEM_COOLDOWN_TIME_MIN = "|CFF999999Cooldown remaining|r %d min."
ITEM_COOLDOWN_TIME_SEC = "|CFF999999Cooldown remaining|r %d sec."
ITEM_MOD_MANA = "%1$c%2$d |CFF3399FFMana|r"
SPELL_RECAST_TIME_MIN = "|CFF999999%.3g min cooldown|r"
SPELL_RECAST_TIME_SEC = "|CFF999999%.3g sec cooldown|r"
MELEE_RANGE = "|CFF00FF00Melee Range|r"
SPELL_RANGE = "%s |CFF00FF00yd range|r"
SPELL_ON_NEXT_SWING = "|CFFFF66CCNext melee|r"
ITEM_SOULBOUND = "|CFFFF6633Soulbound|r"
ITEM_ACCOUNTBOUND = "|CFFCC66FFAccount Bound|r";
ITEM_BIND_ON_EQUIP = "|CFFCC66FFBinds when|r |CFFFF66CCequipped|r"
ITEM_BIND_ON_PICKUP = "|CFFCC66FFBinds when|r |CFFFF66CCpicked up|r"
ITEM_BIND_ON_USE = "|CFFCC66FFBinds when|r |CFFFF66CCused|r"
ITEM_BIND_QUEST = "|CFFCC66FFQuest Item|r"
ITEM_BIND_TO_ACCOUNT = "|CFFCC66FFBinds to account|r"
DURABILITY_TEMPLATE = "|CFF00CCFFDurability|r %d / %d"
ITEM_UNIQUE = "|CFFFFFF66Unique|r"
ITEM_UNIQUE_EQUIPPABLE = "|CFFFFFF66Unique-Equipped|r"
HEALTH_COST = "%s |CFF00FF00Health|r"
HEALTH_COST_PER_TIME = "%s |CFF00FF00Health|r, plus %s per sec"
MANA_COST = "%s |CFF3399FFMana|r"
MANA_COST_PER_TIME = "%s |CFF3399FFMana|r, plus %s per sec"
RUNE_COST_BLOOD = "%s |CFFFF0000Blood|r"
RUNE_COST_FROST = "%s |CFF3399FFFrost|r"
RUNE_COST_UNHOLY = "%s |CFF00FF00Unholy|r"
RUNIC_POWER = "|CFF66F0FFRunic Power|r"
RUNIC_POWER_COST = "%s |CFF66F0FFRunic Power|r"
RUNIC_POWER_COST_PER_TIME = "%s |CFF66F0FFRunic Power|r, plus %s per sec."
REQUIRES_RUNIC_POWER = "Requires |CFF66F0FFRunic Power|r"
SPELL_USE_ALL_ENERGY = "Consumed 100% |CFFFFFF00Energy|r."
SPELL_USE_ALL_FOCUS = "Consumed 100% |CFFFFCC33Fokus|r."
SPELL_USE_ALL_HEALTH = "Consumed 100% |CFF00FF00Health|r."
SPELL_USE_ALL_MANA = "Consumed 100% |CFF3399FFMana|r."
SPELL_USE_ALL_RAGE = "Consumed 100% |CFFCC3333Rage|r."
SPELL_CAST_TIME_INSTANT = "|CFFCC66FFInstant cast|r"
SPELL_CAST_TIME_INSTANT_NO_MANA = "|CFFCC66FFInstant|r"