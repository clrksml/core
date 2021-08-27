
local Player = FindMetaTable("Player")

function Player:ChatPrint( txt )
	if SERVER then
		CORE.ADMIN:Notify(self, txt)
		return
	else
		CORE.CHATBOX:AddHistory(nil, txt, 0, false)
		return
	end
end