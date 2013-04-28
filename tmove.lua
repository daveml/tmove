-- tmove

local args = {...}

local zm = tonumber(args[1])
local xm = tonumber(args[2])
local ym = tonumber(args[3])
local d = tonumber(args[4])
--local tpos = {}

--===================================================
--=  Niklas Frykholm 
-- basically if user tries to create global variable
-- the system will not let them!!
-- call GLOBAL_lock(_G)
--
--===================================================
function GLOBAL_lock(t)
  local mt = getmetatable(t) or {}
  mt.__newindex = lock_new_index
  setmetatable(t, mt)
end

local __LOCK_TABLE = {}
GLOBAL_lock(__LOCK_TABLE)

function usage()

	print("--tmove v1.0")
	print("Helps you move your")
	print(" turtle around! :)")
	print("")
	print("Usage: tmove fwd/back[,left/rt][,up/dwn]")
	print(" 'back', 'left', 'down' are negative")
	print("example: tmove(5)")
	print("         tmove(2,-1,4)")

end

function tposInit()
	tpos = {}
	tpos.z=0
	tpos.y=0
	tpos.x=0
	tpos.dir=1
	return tpos
end

function tposIncZX_get(tpos)
	if tpos.dir == 1 then
		return 1,0
	elseif tpos.dir == 2 then
		return 0,1
	elseif tpos.dir == 3 then
		return -1, 0
	else -- 3
		return 0, -1
	end
end

function tposDecZX_get(tpos)
	if tpos.dir == 1 then
		return -1,0
	elseif tpos.dir == 2 then
		return 0,-1
	elseif tpos.dir == 3 then
		return 1, 0
	else -- 3
		return 0, 1
	end
end

function tposIncZX(tpos)
	z,x = tposIncZX_get(tpos)
	tpos.z = tpos.z + z
	tpos.x = tpos.x + x
end

function tposDecZX(tpos)
	z,x = tposIncZX_get(tpos)
	tpos.z = tpos.z - z
	tpos.x = tpos.x - x
end


function _tposMoveFwd(tpos)
	if turtle.forward() then
		tposIncZX(tpos)
		return true
	else
		return false
	end
end

function _tposMoveBack(tpos)
	if turtle.back() then
		tposDecZX(tpos)
	else
		return false
	end
end

function tposRotateDirLeft(tpos)
	if tpos.dir == 1 then
		tpos.dir = 4
	else
		tpos.dir = tpos.dir - 1
	end
end

function tposRotateDirRight(tpos)
	if tpos.dir == 4 then
		tpos.dir = 1
	else
		tpos.dir = tpos.dir + 1
	end
end

function tposTurnLeft(tpos)
	if turtle.turnLeft() then
		tposRotateDirLeft(tpos)
		return true
	else
		return false
	end
end

function tposTurnAround(tpos)
	tposTurnLeft(tpos)
	tposTurnLeft(tpos)
	return true
end

function tposTurnRight(tpos)
	if turtle.turnRight() then
		tposRotateDirRight(tpos)
		return true
	else
		return false
	end
end

function _tposMoveUp(tpos)
	if turtle.up() then
		tpos.y = tpos.y + 1
		return true
	else
		return false
	end
end

function _tposMoveDown(tpos)
	if turtle.down() then
		tpos.y = tpos.y - 1
		return true
	else
		return false
	end
end

function tposMoveFwd(tpos,count)
	for i=1, count do
		if turtle.detect() == false then
			_tposMoveFwd(tpos)
		else
			print("Blocked!")
			return false
		end
	end
	return true
end

function tposMoveBack(tpos,count)
	for i=1, count do
		if turtle.detect() == false then
			_tposMoveBack(tpos)
		else
			print("Blocked!")
			return false
		end
	end
	return true
end

function tposMoveUp(tpos,count)
	for i=1, count do
		if turtle.detectUp() == false then
			_tposMoveUp(tpos)
		else
			print("Blocked!")
			return false
		end
	end
	return true
end

function tposMoveDown(count)
	for i=1, count do
		if turtle.detectDown() == false then
			_tposMoveDown(tpos)
		else
			print("Blocked")
			return false
		end
	end
	return true
end

function tposDirGT(a,b)
	if a == 1 then
		if b == 4 then
			return true
		end
	else
		return a > b
	end
end

function tposDirLT(a,b)
	if a == 4 then
		if b == 1 then
			return true
		end
	else
		return a < b
	end
end

function tposDirSubtract(a,b)
	local rval = a - b
	if rval < 0 then
		rval = rval + 4
	end
	return rval
end

function tposSetDir(tpos, dir)
	local newdir = tposDirSubtract(dir, tpos.dir)
	for count = 1, newdir do
		tposTurnRight(tpos,newdir)
	end
end



function Refuel(count)
	print("Refueling...")
	local fuelLevel = turtle.getFuelLevel()
	while fuelLevel < count do
		if turtle.refuel(1) == false then
			print("Insufficuent fuel onboard!")
			return false
		end
		fuelLevel = fuelLevel + turtle.getFuelLevel()
	end
	print("Fuel - OK!")
	return true
end

function tposMoveSlideLeft(tpos, count)
	tposTurnLeft(tpos)
	tposMoveFwd(tpos,count)
	tposTurnRight(tpos)
	return true
end

function tposMoveSlideRight(tpos, count)
	tposTurnRight(tpos)
	tposMoveFwd(tpos,count)
	tposTurnLeft(tpos)
	return true
end

function tposMoveZ(tpos, count)
	if count > 0 then
		return tposMoveFwd(tpos, count)
	else
		return tposMoveBack(tpos, -count)
	end
end

function tposMoveX(tpos, count)
	if count > 0 then
		return tposMoveSlideRight(tpos, count)
	else
		return tposMoveSlideLeft(tpos, -count)
	end
end
	
function tposMoveY(tpos, count)
	if count > 0 then
		return tposMoveUp(tpos, count)
	else
		return tposMoveDown(tpos, -count)
	end
end

function tposMoveAbs(tpos,z,x,y)
	tposMoveZ(tpos, z - tpos.z)
	tposMoveX(tpos, x - tpos.x)
	tposMoveY(tpos, y - tpos.y)
end

function tposMoveRel(tpos,z,x,y)
	tposMoveZ(tpos, z)
	tposMoveX(tpos, x)
	tposMoveY(tpos, y)
end



function main()
	GLOBAL_lock(__LOCK_TABLE)
	
	if tpos == nil then
		tpos = tposInit()
	end
	
	if zm == nil then
		usage()
		return
	end
	
	if ym == nil then
		ym = 0
	end
	if xm == nil then
		xm = 0
	end
		
	if Refuel(zm+ym+xm) == false then
		return
	end
	
	print("Turtle moving")
	
	 tposMoveAbs(tpos,zm,ym,xm)
	 
--[	 
	-- move forward/back
	if zm ~= 0 then
		if zm > 0 then
			print("Forward : ",zm)
			tposMoveFwd(tpos,zm)
		else
			print("Back : ",zm)
			tposMoveBack(tpos,-zm)
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		

	-- move left/right
	if xm ~= nil and xm ~= 0 then
		if xm > 0 then
			print("Right : ", xm)
			tposTurnRight(tpos)
			tposMoveFwd(tpos,xm)
			tposTurnLeft(tpos)
		else
			print("Left : ", xm)
			tposTurnLeft(tpos)
			tposMoveFwd(tpos,-xm)
			tposTurnRight(tpos)
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		
	
	-- move up/down
	if ym ~= nil and ym ~= 0 then
		if ym > 0 then
			print("Up : ", ym)
			tposMoveUp(tpos,ym)
		else
			print("Down : ", ym)
			tposMoveDown(tpos,-ym)
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		

	tposSetDir(tpos,4);
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		

	tposTurnAround(tpos)
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		
	
	tposSetDir(tpos,3);
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y, " ", tpos.dir)		
--]

end

main()