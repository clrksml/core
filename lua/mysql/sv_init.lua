require("mysqloo")

if !mysql then
	mysql = {}
	mysql.queries = {}
end

local string = string
local timer = timer
local file = file
local hook = hook
local IsValid = IsValid
local tostring = tostring

function mysql:Connect()
	if !mysqloo then MsgN("[CORE SQL] -> Failed to load mysqloo module.\n\tPlease recheck your version to make sure it's installed correctly.\n\tAlso check to see if you have the right version.") return end
	
	_mysql = mysqloo.connect("localhost", "root", "", "core", 3306)
	_mysql.onConnected = function()
		mysql.connected = true
		
		MsgN("[CORE SQL] Successfully to connect to database.")
		
		if mysql.queries and #mysql.queries > 0 then
			for k, v in pairs(mysql.queries) do
				mysql:DoQuery(v[1], v[2], v[3])
				mysql.queries[k] = nil
			end
		end
	end
	_mysql.onConnectionFailed = function(db, err)
		mysql.connected = false
		MsgN("[CORE SQL] Failed to connect to database -> " .. err)
	end
	_mysql:connect()
end
mysql:Connect()

function mysql:AddQuery(query, func, err)
	mysql.queries[#mysql.queries + 1] = { query, func or nil, err or nil }
	
	MsgN("[CORE SQL] Added a query.")
end

function mysql:DoQuery(query, func, err)
	if !mysqloo then MsgN("[CORE SQL] -> Failed to load mysqloo module.\n\tPlease recheck your version to make sure it's installed correctly.\n\tAlso check to see if you have the right version.") return end
	if !mysql:IsConnected() then _mysql.connected = false mysql:Connect() mysql:AddQuery(query, func, err) return end
	
	local _query = query
	
	if string.GetChar(_query, _query:len()) != ";" then _query = _query .. ";" end
	
	local query1 = _mysql:query(_query)
	query1.onAborted = function( q )
		if q == "MySQL server has gone away" then mysql.connected = false mysql:Connect() mysql:AddQuery(_query, func, err) return end
		
		MsgN("[CORE SQL] Query Aborted:", q)
		
		file.Append("core/mysql/query_aborted.txt", q .. "\n")
	end
	query1.onError = function( q, e, s )
		if e == "MySQL server has gone away" then mysql.connected = false mysql:Connect() mysql:AddQuery(_query, func, err) return end
		
		MsgN("[CORE SQL] Query Failure:", q)
		MsgN("[CORE SQL] Query Failure:", e)
		
		file.Append("core/mysql/query_failure.txt", q .. "\t" .. e .. "\n")
		
		if err then
			err(q, e)
		end
	end
	query1.onSuccess = function(q)
		if func then
			func(q:getData())
		end
	end
	
	query1:start()
end

function mysql:Escape( str )
	return _mysql:escape(tostring(str))
end

function mysql:IsConnected()
	if !mysql.connected and _mysql:status() != 0 then
		return false
	end
	
	return true
end

hook.Add("Tick", "MYSQL_Tick", function()
	if !mysql:IsConnected() then return end
	if #mysql.queries < 1 then return end
	
	for k, v in pairs(mysql.queries) do
		mysql:DoQuery(v[1], v[2], v[3])
		
		mysql.queries[k] = nil
	end
end)
