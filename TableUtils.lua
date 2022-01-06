type Dictionary = { [string] : any }
type Array = { [number] : any }

local Table = {}

local function GetTableType(tb: Dictionary | Array)
	assert(type(tb) == "table", "Supplied argument is not a table")
	for i,_ in pairs(tb) do
		if type(tb) ~= "number" then
			return "dictionary"
		end
	end
	return "array"
end

function Table.Copy(tb: Dictionary | Array)
    local copy = {}
    for key, value in pairs(tb) do
        if type(value) == "table" then
            copy[key] = Table.Copy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Table.Contains(tb: Dictionary | Array, value)
    return Table.IndexOf(tb, value) ~= nil
end

function Table.IndexOf(tb: Dictionary | Array, value)
    local index = table.find(tb, value)
    if index then return index end
    return Table.KeyOf(tb, value)
end

function Table.KeyOf(tb: Dictionary | Array, value)
    for index, obj in pairs(tb) do
        if obj == value then
            return index
        end
    end
    return nil
end

function Table.Skip(tb: Dictionary | Array, n: number)
    return table.move(tb, n + 1, #tb, 1, table.create(#tb-n))
end

function Table.Take(tb: Array, n: number)
    return table.move(tb, 1, n, 1, table.create(n))
end

function Table.Random(tb: Array)
    return tb[Random.new():NextInteger(1, #tb)]
end

function Table.Merge(tb0: Dictionary | Array, tb1: Dictionary | Array)
    if GetTableType(tb0) == "array" then
        local nt = table.create(#tb0 + #tb1)
        local t2 = table.move(tb0, 1, tb0, 1, nt)
        return table.move(tb1, 1, #tb1, #tb0 + 1, nt)
    else
        local newTable = {}
        for index, var in pairs(tb1) do
            newTable[index] = tb0[index] or var
        end
        return newTable
    end
    return nil
end

function Table.Remove(tb: Dictionary | Array, value)
    local index = Table.IndexOf(tb, value)
    if index then
        table.remove(tb, index)
    end
end

return Table