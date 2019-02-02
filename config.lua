local addon, bdt = ...

------------------------------------
-- Config
------------------------------------
local defaults = {}
local configCallback = function() end

-- Display
	defaults[#defaults+1] = {text = {
		type = "text",
		value = "Tooltips Options",
	}}
	defaults[#defaults+1] = {enablett = {
		type = "checkbox",
		value = true,
		label = "Main Tooltips"
	}}
	defaults[#defaults+1] = {showrealm = {
		type = "checkbox",
		value = true,
		label = "Show Realm"
	}}
	defaults[#defaults+1] = {enableitemids = {
		type = "checkbox",
		value = true,
		label = "Show ItemIDs"
	}}
	defaults[#defaults+1] = {enablespellids = {
		type = "checkbox",
		value = true,
		label = "Show SpellIDs"
	}}

	defaults[#defaults+1] = {text = {
		type = "text",
		value = "Lite Tooltips Options",
	}}
	defaults[#defaults+1] = {mott = {
		type = "checkbox",
		value = true,
		label = "Enable lite-tooltips on unit mouseover",
		callback = configCallback
	}}

-- Colors
	defaults[#defaults+1] = {tab = {
		type = "tab",
		value = "Colors",
	}}


local config = bdConfigLib:RegisterModule({
	name = "Tooltips"
}, defaults, "BD_persistent")

local configCallback = function()
	if config.mott then
		bdt.motooltip:Show()
	end
end