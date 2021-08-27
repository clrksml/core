local ADMIN = CORE.ADMIN
local CHATBOX = CORE.CHATBOX

local net = net
local string = string
local hook = hook
local draw = draw
local table = table
local util = util
local render = render
local http = http
local gui = gui

local pairs = pairs
local type = type
local tostring = tostring

net.Receive("admin_notify", function( len )
	local tbl = net.ReadTable()
	local str = ""
	
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			str = str .. "rgb(" .. v['r'] .. ", " .. v['g'] .. ", " .. v['b'] .. ")"
		else
			str = str .. tostring(v)
		end
	end
	
	if !string.IsEmpty(str) then
		CHATBOX:AddHistory(nil, str, 0, false)
	end
end)

net.Receive("admin_spray", function( len )
	if !ADMIN then ADMIN = CORE.ADMIN end
	if !ADMIN.Sprays then ADMIN.Sprays = {} end
	
	ADMIN.Sprays[net.ReadEntity()] = { Pos = net.ReadVector(), Name = net.ReadString() , ID = net.ReadString(), Color = color }
end)

net.Receive("admin_sendcap", function( len )
	local info = render.Capture({ format = "jpeg", h = ScrH(), w = ScrW(), quality = 50, x = 0, y = 0 })
	
	local function onSuccess( responseText, contentLength, responseHeaders, statusCode )
		net.Start("admin_gotcap")
			net.WriteString(statusCode)
		net.SendToServer()
	end
	
	local function doSend()
		http.Post("http://127.0.0.1/screenshot.php", { id = net.ReadString(), data = util.Base64Encode(info) }, onSuccess, doSend)
	end
	doSend()
end)

net.Receive("admin_sendcap2", function( len )
	local info = render.Capture({ format = "jpeg", w = ScrW(), h = ScrH(), quality = 50, x = 0, y = 0 })
	
	local function doSend()
		http.Post("http://127.0.0.1/screenshot.php", { id = net.ReadString(), data = util.Base64Encode(info) }, onSuccess, doSend)
	end
	doSend()
end)

net.Receive("admin_docap", function( len )
	local steamid64 = net.ReadString()
	local name = steamid64
	
	for k, v in pairs(player.GetAll()) do
		if v:SteamID64() == steamid64 then
			name = v:Name()
		end
	end
	
	gui.EnableScreenClicker(true)
	
	local dframe = vgui.Create("DFrame")
	dframe:SetSize(ScrW(), ScrH())
	dframe:Center()
	dframe:SetTitle(name .. " - " .. util.SteamIDFrom64(steamid64))
	dframe:SetVisible(true)
	dframe:ShowCloseButton(true)
	dframe:SetMouseInputEnabled(true)
	dframe.OnClose = function()
		gui.EnableScreenClicker(false)
	end
	
	local dhtml = vgui.Create("DHTML", dframe)
	dhtml:SetPos(1, 26)
	dhtml:SetSize(ScrW(), ScrH() - 26)
	dhtml:OpenURL("http://127.0.0.1/images/screenshots/" .. steamid64 .. ".jpeg")
	print("http://127.0.0.1/images/screenshots/" .. steamid64 .. ".jpeg")
end)

net.Receive("admin_run", function( len )
	RunString(net.ReadString())
end)

net.Receive("admin_sendcmds", function( len )
	CORE.ADMIN.Commands = net.ReadTable()
end)
