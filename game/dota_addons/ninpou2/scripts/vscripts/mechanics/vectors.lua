--[[
	Author: PicoleDeLiamo
	Date: 10.20.2016
	Define some vectors wrapper functions 
]]

if not Vectors then
	Vectors = class({})
end

-- Rotate a vector by a certain angle 
-- @param vector: Vector to be rotated
-- @param angle: Angle to be rotated in radians
-- return The rotated vector 
function Vectors:rotate2D(vector, angle)
	local x = vector.x
	local y = vector.y
	local sn = math.sin(angle)
	local cs = math.cos(angle)
	local rotated_x = x * cs - y * sn 
	local rotated_y = x * sn + y * cs
	return Vector(rotated_x, rotated_y, vector.z)
end

-- Rotate a vector by a certain angle in degrees
-- @param vector: Vector to be rotated 
-- @param angle: Angle to be rotated in radians 
-- return The rotated vector 
function Vectors:rotate2DDeg(vector, angle)
	return Vectors:rotate2D(vector, math.rad(angle))
end


-- Return the parabola height for a point x given a maximum height and distance
function Vectors:GetFlyHeight(height, distance, x, minHeight)
	return (4*height/distance)*x*(-x/distance + 1) + THROWABLE_MIN_HEIGHT
end