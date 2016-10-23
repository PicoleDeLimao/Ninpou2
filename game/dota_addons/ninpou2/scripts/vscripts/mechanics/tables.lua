--[[
	Author: PicoleDeLimao
	Date: 10.20.2016
	Define some tables wrapper functions 
]]

if not Tables then
	Tables = class({})
end

-- Filter elements of a table given a condition
-- @param t: Table to be filtered 
-- @param func: Function to test an element 
-- return A new table containing the filtered elements 
function Tables:Filter(t, func)
	local newT = { }
	for k, v in pairs(t) do
		if func(v) then 
			newT[k] = v
		end
	end
	return newT
end

-- Apply a function over all elements of a table 
-- @param t: Table on which the function will be applied 
-- @param func: Function to be applied 
function Tables:Map(t, func)
	for k, v in pairs(t) do
		func(v)
	end
end

-- Check if a given element is inside a table 
-- @param t: Table to be checked
-- @param el: Element to be checked 
-- return If the table contains the element or not 
function Tables:Contains(t, el)
	for k, v in pairs(t) do 
		if v == el then 
			return true 
		end
	end
	return false
end

-- Return the number of elements inside a table 
-- @param t: Table 
-- return Number of elements 
function Tables:Size(t)
	local size = 0 
	for k, v in pairs(t) do 
		if v ~= nil then
			size = size + 1 
		end
	end 
	return size 
end

-- Check if a table is empty 
-- @param t: Table 
-- return If given table is empty
function Tables:IsEmpty(t)
	return Tables:Size(t) == 0
end

-- Added a new element to the table 
-- @param t: Table 
-- @param el: Element 
function Tables:push(t, el)
	t[Tables:Size(t) + 1] = el
end