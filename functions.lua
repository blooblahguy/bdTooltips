local addon, bdt = ...

------------------------------------
-- Colors
------------------------------------

--[[
local colors = {}
colors.tapped = {.6,.6,.6}
colors.offline = {.6,.6,.6}

-- store class colors
colors.class = {}
for eclass, color in next, RAID_CLASS_COLORS do
	if not colors.class[eclass] then
		colors.class[eclass] = {color.r, color.g, color.b}
	end
end

-- store reaction colors
colors.reaction = {}
for eclass, color in next, FACTION_BAR_COLORS do
	if not colors.reaction[eclass] then
		colors.reaction[eclass] = {color.r, color.g, color.b}
	end
end--]]

------------------------------------
-- Helper funcs
------------------------------------
function RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end

function RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

--[[
local function unitColor(unit)
	if (not UnitExists(unit)) then
		return unpack(colors.tapped)
	end
	if UnitIsPlayer(unit) then
		return unpack(colors.class[select(2, UnitClass(unit))])
	elseif UnitIsTapDenied(unit) then
		return unpack(colors.tapped)
	else
		return unpack(colors.reaction[UnitReaction(unit, 'player')])
	end
end--]]

-- returns a 1-6 of how this unit reacts to you
function bdt:getUnitReactionIndex(unit)
	if UnitIsDeadOrGhost(unit) then
		return 7
	elseif UnitIsPlayer(unit) or UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			return UnitCanAttack("player", unit) and 2 or 3
		elseif UnitCanAttack("player", unit) then
			return 4
		elseif UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player") then
			return 5
		else
			return 6
		end
	elseif UnitIsTapDenied(unit) then
		return 1
	else
		local reaction = UnitReaction(unit, "player") or 3
		return (reaction > 5 and 5) or (reaction < 2 and 2) or reaction
	end
end

-- passes back a perc color for unit, based on reaction, offline, player
function bdt:getColor(unit, alwaysColor)
	local reaction = UnitReaction("mouseover", "player") or 5

	-- sometimes we want to show grey for tapped/dead/offline, sometimes we want the colors
	if (not alwaysColor) then
		if (not UnitExists(unit) or UnitIsDead(unit) or UnitIsTapDenied(unit)) then
			return 136/255, 136/255, 136/255
		end
	end

	-- player
	if (UnitIsPlayer("mouseover")) then
		local _, class = UnitClass("mouseover")
		local color = RAID_CLASS_COLORS[class]
		return color.r, color.g, color.b
	-- npc
	elseif (UnitCanAttack("player", "mouseover")) then
		-- hostile
		if (reaction < 4) then
			return 1, 68/255, 68/255
		-- nuetral
		elseif (reaction == 4) then
			return 1, 1, 68/255
		end
	else
		-- friendly
		if (reaction < 4) then
			return 48/255, 113/255, 191/255
		else
		-- no reaction, just white
			return 1, 1, 1
		end
	end
end