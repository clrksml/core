local string = string
local math = math
local table = table
local game = game
local net = net
local util = util

local string_numbers = {}

for i=0, 255 do
	string_numbers[tostring(i)] = i
end

function string.Salt( key )
	key = tonumber(key) or 8
	
	local salt = ""
	local characters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
	
	for i=1,key do
		salt = salt .. table.Random(characters)
	end
	
	return tostring(salt)
end

function string.IsNumber( str )
	if string_numbers[str] then
		return string_numbers[str]
	else
		return false
	end
end

function string.IsEmpty( str )
	str = string.Replace(str, " ", "")
	
	if str:len() > 0 then
		return false
	end
	
	return true
end

function string.SplitAt(str, num, num2)
	if !str or !num then return str end
	local str2 = ""
	
	if !num2 then
		num2 = 1
	end
	
	if num > str:len() then
		num = str:len()
	end
	
	
	for i=num2, num do
		str2 = str2 .. tostring(string.GetChar(str, i))
	end
	
	if str2 != "" then
		str = str2
	end
	
	return str
end

function string.HasURL( str )
	if type(str) != "string" then return false end
	
	return tobool(str:find("https?://[%w-_%.%?%.:/%+=&]+"))
end

function string.ParseURL( str )
	if type(str) != "string" then return false end
	
	local url, spos, epos = "", str:find("https?://[%w-_%.%?%.:/%+=&]+")
	
	for i=1, str:len() do
		if math.WithIn(spos, epos, i, true) then
			url = url .. string.GetChar(str, i)
			
			if url:len() > (epos - spos) then
				str = url
			end
		end
	end
	
	return str
end

function string.ExplodePattern(str, pat)
	local ret, ind, lpos = {}, 1, 1
	
	for spos, epos in string.gmatch(str, pat) do
		ret[ind] = string.sub(str, lpos, spos-1)
		ind = ind + 1
		lpos = epos
	end
	 
	ret[ind] = string.sub(str, lpos)
	
	return ret
end

function string.ExplodeAt(txt, len)
	local tbl, str = {}, ""
	
	for i=1, txt:len() do
		if i % len == 0 then
			tbl[#tbl + 1] = str
			str = ""
		else
			str = str .. string.GetChar(txt, i)
		end
	end
	
	return tbl
end

function string.Capitalize( str )
	return string.upper(str:sub(1, 1)) .. string.lower(str:sub(2))
end

function math.WithIn(min, max, num, yes)
	if yes then
		return num >= min and num <= max
	end
	
	return num > min and num < max
end

function game:IsTTT()
	return engine.ActiveGamemode():lower() == "terrortown"
end

function game:IsJB()
	return engine.ActiveGamemode():lower() == "jailbreak"
end

function game:IsFW()
	return engine.ActiveGamemode():lower() == "fortwars"
end

function util.Base64Decode( str )
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	
	str = str:gsub('[^'..b..'=]', '')
	
	return (str:gsub('.', function(x)
		if (x == '=') then
			return ''
		end
		
		local r,f='',(b:find(x)-1)
		
		for i=6,1,-1 do
			r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0')
		end
		
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then
			return ''
		end
		
		local c=0
		
		for i=1,8 do
			c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0)
		end
		
		return string.char(c)
	end))
end

function resource.AddFolder( dir )
	local files, folders = file.Find(dir .. "/*", "GAME")
	
	for k, v in pairs(folders) do
		resource.AddFolder(dir .. "/" .. v)
	end
	
	for k, v in pairs(files) do
		resource.AddSingleFile(dir .. "/" .. v)
	end
end
