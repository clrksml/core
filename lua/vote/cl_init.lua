Maps = {}

net.Receive("vm_sendmaps", function()
	Maps = net.ReadTable()
	
	MsgN("VoteMap receive map list containing #" .. #Maps .. " from server!")
end)

net.Receive("vm_update", function()
	Maps = net.ReadTable()
end)