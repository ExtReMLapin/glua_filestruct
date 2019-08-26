if CLIENT then return end

DATA_BIT = "DATA_BIT"
DATA_BOOL = DATA_BIT

DATA_BYTE = "DATA_BYTE"
DATA_8BITS = DATA_BYTE
DATA_1BYTE = DATA_BYTE

DATA_DOUBLE = "DATA_DOUBLE"
DATA_64BITSDOUBLE = DATA_DOUBLE
DATA_8BYTESDOUBLE = DATA_DOUBLE

DATA_FLOAT = "DATA_FLOAT"
DATA_32BITSFLOAT = DATA_FLOAT
DATA_4BYTESFLOAT = DATA_FLOAT
DATA_LINE = "DATA_LINE"

DATA_LONG = "DATA_LONG"
DATA_32BITS = DATA_LONG
DATA_4BYTES = DATA_LONG

DATA_SHORT = "DATA_SHORT"
DATA_16BITS = DATA_SHORT
DATA_2BYTES = DATA_SHORT

DATA_ULONG = "DATA_ULONG"
DATA_U31BITS = DATA_ULONG
DATA_U4BYTES = DATA_ULONG

DATA_USHORT = "DATA_USHORT"
DATA_U16BITS = DATA_USHORT
DATA_U2BYTES = DATA_USHORT

DATA_STRING = "DATA_STRING"
DATA_NEXTZERO = DATA_STRING

local actions = {
	DATA_BIT = function(file) return file:ReadByte() end,
	DATA_BYTE = function(file) return file:ReadByte() end,
	DATA_DOUBLE = function(file) return file:ReadDouble() end,
	DATA_FLOAT = function(file) return file:ReadFloat() end,
	DATA_LONG = function(file) return file:ReadLong() end,
	DATA_SHORT = function(file) return file:ReadShort() end,
	DATA_ULONG = function(file) return file:ReadULong() end,
	DATA_USHORT = function(file) return file:ReadUShort() end,
	DATA_STRING = function(file)
		local byteTable = {}

		while (true) do
			local byte = file:ReadByte()
			if byte == 0 then return table.concat(byteTable) end
			local char = string.char(byte)
			table.insert(byteTable, char)
		end
	end
}

local specialActions = {
	DATA_LENSTRING = function(file, count) return file:Read(count) end,
	DATA_SKIP = function(file, count)
		file:Skip(count)
	end
}

local function handleAction(action, file)
	local _action = actions[action]

	if _action then
		return _action(file)
	else
		for k, v in pairs(specialActions) do
			if string.StartWith(action, k) then
				_action = k
				break
			end
		end

		if (_action) then
			local numStr = string.Right(action, action:len() - _action:len())
			local num = tostring(numStr)

			return specialActions[_action](file, num)
		end
	end

	Error(string.format("Action : %s isn't implemented", action))
end


function parseFile(path, struct)
	local outTbl = {}
	assert(file.Exists(path, "GAME"), string.format("File [%s] doesn't exist", path))
	assert(istable(struct), "struct isn't a table")
	local gma = file.Open(path, "rb", "GAME")
	if not gma then return nil end

	for k, v in pairs(struct) do
		local key, value = next(v)
		outTbl[key] = handleAction(value, gma)
	end

	return outTbl
end


local fileStruct = { -- i had to do this ugly shit to conserv the order
	{HEADER = "DATA_LENSTRING4"},
	{Version = DATA_BYTE},
	{SteamID_Unused = "DATA_SKIP8"},
	{TimeStamp = DATA_64BITSDOUBLE},
	{Junk = "DATA_SKIP1"},
	{Title = DATA_STRING},
	{Description = DATA_STRING},
	{Author_string = DATA_STRING},
	{Addon_version = DATA_4BYTES},
}


local tbl = parseFile("data/test.gma", fileStruct)
PrintTable(tbl)
