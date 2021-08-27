local STORE = CORE.STORE

local net = net
local sound = sound
local timer = timer
local tonumber = tonumber
local tobool = tobool

net.Receive("store_equip", function()
	local ply, cat, id, bool = net.ReadEntity(), tonumber(net.ReadFloat()), tonumber(net.ReadFloat()), tobool(net.ReadFloat())
	
	if cat == 1 then
		if bool then
			ply:RemoveHat(id)
		else
			ply:RemoveHat(id)
			ply:DrawHat(id)
		end
	elseif cat == 2 then
		if bool then
			ply:RemoveMask(id)
		else
			ply:RemoveMask(id)
			ply:DrawMask(id)
		end
	elseif cat == 4 then
		ply:DrawTrail(id)
	end
end)

net.Receive("store_items", function()
	LocalPlayer().Items = net.ReadTable()
end)

net.Receive("store_new", function()
	local msg = {"Welcome to the Havoc Gamers store.", "By left clicking the icons on the far left you can buy and browse store items.", "By right clicking the icons on the far left you can equip and browse your items.", "This concludes the havoc gamers store tutorial." }
	
	sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. msg[1], "mono", function( sound )
		if IsValid(sound) then
			sound:SetVolume(1)
			sound:SetPos(LocalPlayer():GetPos())
			sound:Play()
		end
	end)
	
	timer.Simple(3, function()
		sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. msg[2], "mono", function( sound )
			if IsValid(sound) then
				sound:SetVolume(1)
				sound:SetPos(LocalPlayer():GetPos())
				sound:Play()
			end
		end)
	end)
	
	timer.Simple(8, function()
		sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. msg[3], "mono", function( sound )
			if IsValid(sound) then
				sound:SetVolume(1)
				sound:SetPos(LocalPlayer():GetPos())
				sound:Play()
			end
		end)
	end)
	
	timer.Simple(13, function()
		sound.PlayURL("http://translate.google.com/translate_tts?tl=en&q=" .. msg[4], "mono", function( sound )
			if IsValid(sound) then
				sound:SetVolume(1)
				sound:SetPos(LocalPlayer():GetPos())
				sound:Play()
			end
		end)
	end)
end)
