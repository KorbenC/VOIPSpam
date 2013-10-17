-------------------------------------------------
-- Variables and Such
-------------------------------------------------
local VOIPSpam = CreateFrame("FRAME");
local Elvui_Font = "Interface\\AddOns\\VOIPSpam\\PT_Sans_Narrow.ttf"
local blank = "Interface\\AddOns\\VOIPSpam\\blank"
local borderr, borderg, borderb = .2, .2, .2
local backdropr, backdropg, backdropb, backdropa = .075, .075, .075, 1
local guildName = GetGuildInfo("player")
local yOffSet = (GetScreenHeight() / 3)
local GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers
local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers

-------------------------------------------------
-- Pixel Perfect - Credit to TukUI (Tukz)
-------------------------------------------------
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/GetCVar("uiScale")
local Scale = function(x)
	return mult * math.floor( x / mult + .5 )
end

VSScale = function(x) return Scale(x) end
VSmult = mult


local VOIPSpam = CreateFrame("FRAME")
VOIPSpam:RegisterEvent("ADDON_LOADED")
VOIPSpam:RegisterEvent("VARIABLES_LOADED")
VOIPSpam:RegisterEvent("PARTY_CONVERTED_TO_RAID")
VOIPSpam:RegisterEvent("PARTY_MEMBERS_CHANGED")
VOIPSpam:RegisterEvent("RAID_ROSTER_UPDATE")

-------------------------------------------------
-- A Little Initialization 
-------------------------------------------------
function VOIPSpam:OnEvent(event)
	if VOIPInformation == nil then
		VOIPInformation = {
		"yourserver.com", --Host
		9999, --Port
		"None", --Password
		"Vent"} --vent/teamspeak/mumble/skype etc 
		print("|cffC495DDVOIP SPAM:|r You currently have no settings for VOIP Spam.")
		print("|cffC495DDVOIP SPAM:|r To set this, type: /voip set")
	else
		if VOIPInformation[4]:lower() == "ventrilo" or VOIPInformation[4]:lower() == "vent" then
			VOIPmsg = "We use "..VOIPInformation[4].." for voice chat."
			VOIPloc = "It can be downloaded from: http://www.ventrilo.com/download.php"
		elseif ( VOIPInformation[4]:lower() == "team speak" or VOIPInformation[4]:lower() == "ts" )then
			VOIPmsg = "We use "..VOIPInformation[4].." for voice chat."
			VOIPloc = "It can be downloaded from: http://www.teamspeak.com/?page=downloads"		
		elseif VOIPInformation[4]:lower() == "mumble" then
			VOIPmsg = "We use "..VOIPInformation[4].." for voice chat."
			VOIPloc = "It can be downloaded from: http://mumble.sourceforge.net/"		
		else
			VOIPmsg = "We use "..VOIPInformation[4].." for voice chat."
			VOIPloc = "Get the download link from the raid leader. <3"		
		end	
	end
		
	if GetNumRaidMembers() > 0 then
		VOIPmsgtype = "RAID"	
	elseif GetNumPartyMembers() > 0 then
		VOIPmsgtype = "PARTY"
	else
		return
	end

end

VOIPSpam:SetScript("OnEvent", VOIPSpam.OnEvent);

--Change Border color functions
local function OnEnter(self)
	self:SetBackdropBorderColor(0,.5,1)
end

local function OnLeave(self)
	self:SetBackdropBorderColor(0,0,0)
end

-------------------------------------------------
-- Functions - Credit to TukUI (Tukz)
-------------------------------------------------
--Panel function
local function Panel(f, w, h, a1, p, a2, x, y)	
	local sh = VSScale(h)
	local sw = VSScale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, VSScale(x), VSScale(y))
	f:SetBackdrop({
	  bgFile = blank, 
	  edgeFile = blank, 
	  tile = false, tileSize = 0, edgeSize = VSmult, 
	  insets = { left = -VSmult, right = -VSmult, top = -VSmult, bottom = -VSmult}
	})
	
	f:EnableMouse(true)
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

--Textbox function
local function ebox(f, w, h, a1, p, a2, x, y)
	local sh = VSScale(h)
	local sw = VSScale(w)
	f:SetFrameLevel((f:GetParent()):GetFrameLevel() + 1)
	f:SetAutoFocus(false)
	f:SetMultiLine(false)
	f:SetWidth(sw)
	f:SetHeight(sh)
	if p == nil then
		f:SetPoint(a1, f:GetParent(), a2, VSScale(x), VSScale(y))
	else
		f:SetPoint(a1, p, a2, VSScale(x), VSScale(y))
	end
	f:SetMaxLetters(255)
	f:SetTextInsets(3,0,0,0)
	f:SetBackdrop({
	  bgFile = blank, 
	  edgeFile = blank, 
	  tile = false, tileSize = 0, edgeSize = VSmult, 
	  insets = { left = -VSmult, right = -VSmult, top = -VSmult, bottom = -VSmult}
	})
	f:SetFont(Elvui_Font, 12)
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb,1)
	f:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
end

-------------------------------------------------
-- Spam Your VOIP Settings
-------------------------------------------------
local function VOIPSpamMessage()
	SendChatMessage(VOIPmsg, VOIPmsgtype)
	SendChatMessage(VOIPloc, VOIPmsgtype)
	SendChatMessage("HOST:  ".. VOIPInformation[1], VOIPmsgtype)
	SendChatMessage("PORT:  ".. VOIPInformation[2], VOIPmsgtype)
	SendChatMessage("PASS:  ".. VOIPInformation[3], VOIPmsgtype)
end


-------------------------------------------------
-- Set VOIP Info Frame
-------------------------------------------------
local function VOIPReload()
	--Main panel
	local VOIPReload = CreateFrame("Frame", "VOIPSet", UIParent)
	Panel(VOIPReload, 400, 60, "TOP", UIParent, "CENTER", 0, yOffSet)
	VOIPReload_Text = VOIPReload:CreateFontString()
	VOIPReload_Text:SetFont(Elvui_Font, 16)
	VOIPReload_Text:SetPoint("Center", VOIPReload, "CENTER")
	VOIPReload_Text:SetText("In order to save your settings, you must reload your UI.")

	--Reload button
	local VOIPReloadReload	= CreateFrame("Button", "VOIPReloadReload", VOIPReload)
	Panel(VOIPReloadReload, 50, 20, "RIGHT", VOIPReload, "BOTTOMRIGHT", 0, 10)
	VOIPReloadReload:SetFrameLevel(VOIPReload:GetFrameLevel() + 1)
	VOIPReloadReload:EnableMouse(true)
	VOIPReloadReload:SetScript("OnEnter", OnEnter)
	VOIPReloadReload:SetScript("OnLeave", OnLeave)
	VOIPReloadReload_Text  = VOIPReloadReload:CreateFontString()
	VOIPReloadReload_Text:SetFont(Elvui_Font, 12)
	VOIPReloadReload_Text:SetPoint("Center", VOIPReloadReload, "CENTER")
	VOIPReloadReload_Text:SetText("Reload")			
	VOIPReloadReload:SetScript("OnClick", function(self, button, down)
		ReloadUI()
	end)
	
	--Close button
	local VOIPReloadClose	= CreateFrame("Frame", "VOIPReloadClose", VOIPReload)
	Panel(VOIPReloadClose, 50, 20, "LEFT", VOIPReload, "BOTTOMLEFT", 0, 10)
	VOIPReloadClose:SetFrameLevel(VOIPReload:GetFrameLevel() + 1)
	VOIPReloadClose:EnableMouse(true)
	VOIPReloadClose:SetScript("OnEnter", OnEnter)
	VOIPReloadClose:SetScript("OnLeave", OnLeave)
	VOIPReloadClose_Text  = VOIPReloadClose:CreateFontString()
	VOIPReloadClose_Text:SetFont(Elvui_Font, 12)
	VOIPReloadClose_Text:SetPoint("Center", VOIPReloadClose, "CENTER")
	VOIPReloadClose_Text:SetText("Close")			
	VOIPReloadClose:SetScript("OnMouseDown", function(self, button, down)
		VOIPReload:Hide()
	end)
end

function VOIPSet()
	--Main panel
	local VOIPSet = CreateFrame("Frame", "VOIPSet", UIParent)
	Panel(VOIPSet, 200, 220, "CENTER", UIParent, "CENTER", 0, yOffSet)
	VOIPSet:SetFrameLevel(VOIPSet:GetFrameLevel() + 1)
	VOIPSet_Text = VOIPSet:CreateFontString()
	VOIPSet_Text:SetFont(Elvui_Font, 12)
	VOIPSet_Text:SetPoint("TOP", VOIPSet, "TOP")
	VOIPSet_Text:SetText("VOIP Spam Settings")
	VOIPSet:SetMovable(true)
	VOIPSet:RegisterForDrag("LeftButton")
	VOIPSet:SetScript("OnDragStart", function(self) self:SetUserPlaced(true) self:StartMoving() end)
	VOIPSet:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	--local VOIPSetTitle = CreateFrame("Frame", "VOIPSetTitle", VOIPSet)
	--Panel(VOIPSetTitle, 130, 20, "CENTER", VOIPSet, "TOP", 0, -10)
	--VOIPSetTitle:SetFrameLevel(VOIPSet:GetFrameLevel() + 1)
	--VOIPSetTitle_Text = VOIPSetTitle:CreateFontString()
	--VOIPSetTitle_Text:SetFont(Elvui_Font, 12)
	--VOIPSetTitle_Text:SetPoint("Center", VOIPSetTitle, "CENTER")
	--VOIPSetTitle_Text:SetText("VOIP Spam Settings")
	
	--Close button
	local VOIPClose	= CreateFrame("Frame", "VOIPClose", VOIPSet)
	Panel(VOIPClose, 15, 15, "RIGHT", VOIPSet, "TOPRIGHT", -1, -15)
	VOIPClose:SetFrameLevel(VOIPSet:GetFrameLevel() + 1)
	VOIPClose:EnableMouse(true)
	VOIPClose:SetScript("OnEnter", OnEnter)
	VOIPClose:SetScript("OnLeave", OnLeave)
	VOIPClose_Text  = VOIPClose:CreateFontString()
	VOIPClose_Text:SetFont(Elvui_Font, 12)
	VOIPClose_Text:SetPoint("Center", VOIPClose, "CENTER")
	VOIPClose_Text:SetText("X")			
	VOIPClose:SetScript("OnMouseDown", function(self, button, down)
		VOIPSet:Hide()
	end)
	
	--Program textbox
	local newProg = CreateFrame("EditBox", "newProg", VOIPSet)
	ebox(newProg, 200, 20, "TOP", nil, "TOP", 0, -38)
	newProg:SetText(VOIPInformation[4])
	newProg_Text = newProg:CreateFontString()
	newProg_Text:SetFont(Elvui_Font, 12)
	newProg_Text:SetPoint("BOTTOMLEFT", newProg, "TOPLEFT")
	newProg_Text:SetText("VOIP Program: ")
	
	--Host textbox
	local newHost = CreateFrame("EditBox", "newHost", VOIPSet)
	ebox(newHost, 200, 20, "TOP", newProg,  "BOTTOM", 0, -25)
	newHost:SetText(VOIPInformation[1])
	newHost_Text = newHost:CreateFontString()
	newHost_Text:SetFont(Elvui_Font, 12)
	newHost_Text:SetPoint("BOTTOMLEFT", newHost, "TOPLEFT")
	newHost_Text:SetText("Host: ")
	
	--Port textbox
	local newPort = CreateFrame("EditBox", "newPort", VOIPSet)
	ebox(newPort, 200, 20, "TOP", newHost, "BOTTOM", 0, -25)
	newPort:SetText(VOIPInformation[2])
	newPort_Text = newPort:CreateFontString()
	newPort_Text:SetFont(Elvui_Font, 12)
	newPort_Text:SetPoint("BOTTOMLEFT", newPort, "TOPLEFT")
	newPort_Text:SetText("Port: ")
	
	--Password textbox
	local newPass 	= CreateFrame("EditBox", "newPass", VOIPSet)
	ebox(newPass, 200, 20, "TOP", newPort, "BOTTOM", 0, -25)
	newPass:SetText(VOIPInformation[3])
	newPass_Text = newPass:CreateFontString()
	newPass_Text:SetFont(Elvui_Font, 12)
	newPass_Text:SetPoint("BOTTOMLEFT", newPass, "TOPLEFT")
	newPass_Text:SetText("Password: ")
	
	--Save button
	local saveInfo	= CreateFrame("Frame", "saveInfo", VOIPSet)
	Panel(saveInfo, 100, 20, "RIGHT", VOIPSet, "BOTTOMRIGHT", -1, 10)
	saveInfo:SetFrameLevel(VOIPSet:GetFrameLevel() + 1)
	saveInfo:EnableMouse(true)
	saveInfo:SetScript("OnEnter", OnEnter)
	saveInfo:SetScript("OnLeave", OnLeave)
	saveInfo_Text  = saveInfo:CreateFontString()
	saveInfo_Text:SetFont(Elvui_Font, 12)
	saveInfo_Text:SetPoint("Center", saveInfo, "CENTER")
	saveInfo_Text:SetText("Save")			
	saveInfo:SetScript("OnMouseDown", function(self, button, down)
		VOIPInformation[1] = newHost:GetText()
		VOIPInformation[2] = newPort:GetText()
		VOIPInformation[3] = newPass:GetText()
		VOIPInformation[4] = newProg:GetText()
		print(VOIPInformation[4].." INFORMATION SAVED")
		print(" --HOST: " .. VOIPInformation[1])
		print(" --PORT: " .. VOIPInformation[2])
		print(" --PASS: " .. VOIPInformation[3])
		VOIPSet:Hide()
		VOIPReload()
	end)
	
	--Spam button
	local spamInfo	= CreateFrame("Frame", "spamInfo", VOIPSet)
	Panel(spamInfo, 100, 20, "LEFT", VOIPSet, "BOTTOMLEFT", 1, 10)
	spamInfo:SetFrameLevel(VOIPSet:GetFrameLevel() + 1)
	spamInfo:EnableMouse(true)
	spamInfo:SetScript("OnEnter", OnEnter)
	spamInfo:SetScript("OnLeave", OnLeave)
	spamInfo_Text  = spamInfo:CreateFontString()
	spamInfo_Text:SetFont(Elvui_Font, 12)
	spamInfo_Text:SetPoint("Center", spamInfo, "CENTER")
	spamInfo_Text:SetText("Spam")			
	spamInfo:SetScript("OnMouseDown", function(self, button, down)
		if VOIPInformation[4] ~= newProg:GetText() then
			if ( newProg:GetText():lower() == "ventrilo" or newProg:GetText():lower() == "vent" ) then
				VOIPmsg = "We use Ventrilo for voice chat."
				VOIPloc = "It can be downloaded from: http://www.ventrilo.com/download.php"
			elseif ( newProg:GetText():lower() == "team speak" or newProg:GetText():lower() == "ts" )then
				VOIPmsg = "We use Team Speak for voice chat."
				VOIPloc = "It can be downloaded from: http://www.teamspeak.com/?page=downloads"		
			elseif (newProg:GetText()):lower() == "mumble" then
				VOIPmsg = "We use Mumble for voice chat."
				VOIPloc = "It can be downloaded from: http://mumble.sourceforge.net/"		
			else
				VOIPmsg = "We use "..newProg:GetText().." for voice chat."
				VOIPloc = "Get the download link from the raid leader. <3"	
			end	
			SendChatMessage(VOIPmsg, VOIPmsgtype)
			SendChatMessage(VOIPloc, VOIPmsgtype)
			SendChatMessage("HOST:  ".. newHost:GetText(), VOIPmsgtype)
			SendChatMessage("PORT:  ".. newPort:GetText(), VOIPmsgtype)
			SendChatMessage("PASS:  ".. newPass:GetText(), VOIPmsgtype)
		else
			VOIPSpamMessage()
		end
		
		VOIPInformation[1] = newHost:GetText()
		VOIPInformation[2] = newPort:GetText()
		VOIPInformation[3] = newPass:GetText()
		VOIPInformation[4] = newProg:GetText()
		VOIPSet:Hide()
	end)
	
	if ( newProg:GetText() == "ts" or newProg:GetText() == "team speak" or newProg:GetText() == "teamspeak" ) then
		newProg:SetText("Team Speak")
	elseif ( newProg:GetText() == "ventrilo" or newProg:GetText() == "vent" ) then
		newProg:SetText("Ventrilo")
	elseif newProg:GetText() == "mumble" then
		newProg:SetText("Mumble")
	end
end

-------------------------------------------------
-- Slash Commands <3
-------------------------------------------------
SLASH_VOIPSPAMSLASH1 = "/voip"
SlashCmdList["VOIPSPAMSLASH"] = function(msg)
	if(msg=="set") then
		VOIPSet()
	elseif(msg=="spam") then
		VOIPSpamMessage()
	else
		print("VOIP Spam Usage:")
		print("     /voip set -- Allows you to change your VOIP Spam settings")
		print("     /voip spam -- Spams your VOIP settings to your party/raid")
	end
end