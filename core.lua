local addonName, bdt = ...


------------------------------------
-- Config
------------------------------------
local defaults = {}
local configCallback = function() end

defaults[#defaults+1] = {enablett = {
	type = "checkbox",
	value = true,
	label = "Main Tooltips"
}}
defaults[#defaults+1] = {mott = {
	type = "checkbox",
	value = true,
	label = "Mini name hover tooltips",
	callback = configCallback
}}

bdCore:addModule("Tooltips", defaults)
local config = bdCore.config.profile['Tooltips']

local configCallback = function()
	if config.mott then
		bdt.motooltip:Show()
	end
end

local bordersize = bdCore.config.persistent.General.bordersize

local tooltip = CreateFrame('frame',nil)
tooltip:SetFrameStrata("TOOLTIP")
tooltip.text = tooltip:CreateFontString(nil, "OVERLAY")
tooltip.text:SetFont(bdCore.media.font, 11, "THINOUTLINE")

-----------------------------------
-- Skinning default tooltips
-----------------------------------
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
	bdCore:StripTextures(frame)
	bdCore:setBackdrop(frame)
	frame:SetScale(1)
end

--[[
local function setFirstLine(self)
	local name, unit = self:GetUnit()
	if not unit then return end
	
	local targetstr = "";
	local namestr = "";
	if (UnitExists(unit.."target")) then
		local target = GetUnitName(unit.."target")
		local cname, cclass = UnitClass(unit.."target")
		local targetcolor = RAID_CLASS_COLORS[cclass]
		local hex = RGBPercToHex(targetcolor.r, targetcolor.g, targetcolor.b)
		targetstr = "@|cff"..hex..target.."|r"
	end
	
	local name = GetUnitName(unit, true)
	local cname, cclass = UnitClass(unit)
	local color = RAID_CLASS_COLORS[cclass]
	local hex = RGBPercToHex(color.r, color.g, color.b)
	namestr = "|cff"..hex..name.."|r"
	
	GameTooltipTextLeft1:SetTextColor(1,1,1)
	GameTooltipTextLeft1:SetFormattedText('%s %s', namestr,targetstr)
end--]]

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
	if (self:IsForbidden()) then return end -- don't mess with forbidden frames, which sometimes randomly happens

	local name, unit = self:GetUnit()
	if not unit then
		unit = GetMouseFocus() and GetMouseFocus():GetAttribute("unit")
	end
	if not unit then return end

	-- now lets modify the tooltip
	local lines = self:NumLines()

	local line = 1;
	name = GetUnitName(unit)
	local guild, rank = GetGuildInfo(unit)
	local race = UnitRace(unit) or ""
	local level = UnitLevel(unit)
	local classification = UnitClassification(unit)
	local creatureType = UnitCreatureType(unit)
	local factionGroup = select(1, UnitFactionGroup(unit))
	local isFriend = UnitIsFriend("player", unit)
	local levelColor = GetQuestDifficultyColor(level)
	local reactionColor = getColor(unit)
	--local friendColor = {r = 1, g = 1, b = 1}
	
	--[[
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
	end--]]
	
	if UnitIsPlayer(unit) then

	else

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
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("TOPLEFT", self, "TOPLEFT")
	GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -6)
	GameTooltipStatusBar.unit = unit
	GameTooltipStatusBar:SetMinMaxValues(0, max)
	GameTooltipStatusBar:SetValue(hp)
	GameTooltipStatusBar:SetStatusBarColor( unpack(bct:getColor(unit, true)) )
	-- this sucks at updating while you are hovering
	GameTooltipStatusBar:RegisterEvent("UNIT_HEALTH")
	GameTooltipStatusBar:SetStatusBarTexture(bdCore.media.flat)
	GameTooltipStatusBar:SetScript("OnEvent", function(self)
		local hp = UnitHealth(self.unit)
		local max = UnitHealthMax(self.unit)
		self:SetMinMaxValues(0, max)
		self:SetValue(hp)
	end)

	-- Set Fonts
	for i = 1, 20 do
		local line = _G['GameTooltipTextLeft'..i]
		if not line then break end
		line:SetFont(bdCore.media.font, 14)
	end
end

GameTooltip:HookScript('OnTooltipSetUnit', setUnit)
function GameTooltip_UnitColor(unitToken) return unitColor(unitToken) end
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
tooltipanchor:SetSize(250, 200)
tooltipanchor:SetPoint("TOPRIGHT", UIParent, "RIGHT", -20, -100)
bdCore:makeMovable(tooltipanchor)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	self:SetOwner(parent, "ANCHOR_NONE")
	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT", tooltipanchor)
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

local types = {
	item        = "ItemID:",
	currency    = "CurrencyID:"
}

local function addLine(tooltip, id, type)
	local found = false

	for i = 1,15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local text
		if frame then text = frame:GetText() end
		if text and text == type then found = true break end
	end

	if not found then
		tooltip:AddDoubleLine(type, "|cffffffff" .. id)
		tooltip:Show()
	end
end

local function onSetHyperlink(self, link)
	local type, id = string.match(link,"^(%a+):(%d+)")
	if not type or not id then return end
	if type == "item" then
		addLine(self, id, types.item)
	elseif type == "currency" then
		addLine(self, id, types.currency)
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

local function attachItemTooltip(self)
	local link = select(2, self:GetItem())
	if link then
		local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
		if id == "0" and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() then
			if (GetMouseFocus():GetName()) == "TradeSkillSkillIcon" then
				id = GetTradeSkillItemLink(TradeSkillFrame.selectedSkill):match("item:(%d+):") or nil
			else
				for i = 1, 8 do
					if (GetMouseFocus():GetName()) == "TradeSkillReagent"..i then
						id = GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, i):match("item:(%d+):") or nil
						break
					end
				end
			end
		end
		if id then
			addLine(self, id, types.item)
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)

hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
	local id = tonumber(string.match(GetCurrencyListLink(index),"currency:(%d+)"))
	if id then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyByID", function(self, id)
	if id then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyTokenByID", function(self, id)
	if id then addLine(self, id, types.currency) end
end)

------------------------
-- set this at the tooltip anchor frame

--[[


-- Show unit name at mouse
tooltip:SetScript("OnUpdate", function(self)
	if GetMouseFocus() and GetMouseFocus():IsForbidden() then self:Hide() return end
	if GetMouseFocus() and GetMouseFocus():GetName()~="WorldFrame" then self:Hide() return end
	if not UnitExists("mouseover") then self:Hide() return end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	self.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y+15)
end)
tooltip:SetScript("OnEvent", function(self)
	if GetMouseFocus():GetName()~="WorldFrame" then return end
	
	local name = UnitName("mouseover")
	local AFK = UnitIsAFK("mouseover")
	local DND = UnitIsDND("mouseover")
	local prefix = ""
	
	if AFK then prefix = "<AFK> " end
	if DND then prefix = "<DND> " end
	
	self.text:SetTextColor(getcolor())
	self.text:SetText(prefix..name)

	self:Show()
end)
tooltip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
--]]