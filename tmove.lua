-- tmove

local args = {...}

local zm = tonumber(args[1])
local xm = tonumber(args[2])
local ym = tonumber(args[3])
local tpos = {}

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
	tpos.z=0
	tpos.y=0
	tpos.x=0
	tpos.dir=1
	return tpos
end

function tposIncZX_get(dir)
	if dir == 1 then
		return 1,0
	elseif dir == 2 then
		return 0,1
	elseif dir == 3 then
		return -1, 0
	else -- 3
		return 0, -1
	end
end

function tposDecZX_get(dir)
	if dir == 1 then
		return -1,0
	elseif dir == 2 then
		return 0,-1
	elseif dir == 3 then
		return 1, 0
	else -- 3
		return 0, 1
	end
end

function tposIncZX()
	z,x = tposIncZX_get(tpos.dir)
	tpos.z = tpos.z + z
	tpos.x = tpos.x + x
end

function tposDecZX()
	z,x = tposIncZX_get(tpos.dir)
	tpos.z = tpos.z - z
	tpos.x = tpos.x - x
end


function tposMoveFwd()
	if turtle.forward() then
		tposIncZX(tpos)
		return true
	else
		return false
	end
end

function tposMoveBack()
	if turtle.back() then
		tposDecZX()
	else
		return false
	end
end

function tposRotateDirLeft()
	if tpos.dir == 1 then
		tpos.dir = 4
	else
		tpos.dir = tpos.dir - 1
	end
end

function tposRotateDirRight()
	if tpos.dir == 4 then
		tpos.dir = 1
	else
		tpos.dir = tpos.dir + 1
	end
end

function tposTurnLeft()
	if turtle.left() then
		tposRotateDirLeft()
		return true
	else
		return false
	end
end

function tposTurnRight()
	if turtle.right() then
		tposRotateDirRight()
		return true
	else
		return false
	end
end

function tposMoveUp()
	if turtle.up() then
		tpos.y = tpos.y + 1
		return true
	else
		return false
	end
end

function tposMoveDown()
	if turtle.down() then
		tpos.y = tpos.y - 1
		return true
	else
		return false
	end
end

function movefwd(count)
	for i=1, count do
		if turtle.detect() == false then
			tposMoveFwd()
		else
			print("Blocked!")
			return false
		end
	end
	return true
end

function moveUp(count)
	for i=1, count do
		if turtle.detectUp() == false then
			tposMoveUp()
		else
			print("Blocked!")
			return false
		end
	end
	return true
end

function moveDown(count)
	for i=1, count do
		if turtle.detectDown() == false then
			tposMoveDown()
		else
			print("Blocked")
			return false
		end
	end
	return true
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




function main()
	
	tposInit()
	
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
	 
	-- move forward/back
	if zm ~= 0 then
		if zm > 0 then
			print("Forward : ",zm)
			movefwd(zm)
		else
			print("Back : ",zm)
			turtle.turnLeft()
			turtle.turnLeft()
			movefwd(-zm)
			turtle.turnRight()
			turtle.turnRight()
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y)		
	-- move left/right
	if xm ~= nil and xm ~= 0 then
		if xm > 0 then
			print("Right : ", xm)
			turtle.turnRight()
			movefwd(xm)
			turtle.turnLeft()
		else
			print("Left : ", xm)
			turtle.turnLeft()
			movefwd(-xm)
			turtle.turnRight()
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y)		
	
	-- move up/down
	if ym ~= nil and ym ~= 0 then
		if ym > 0 then
			print("Up : ", ym)
			moveUp(ym)
		else
			print("Down : ", ym)
			moveDown(-ym)
		end
	end
	print("TPOS:", tpos.z, " ", tpos.x, " ", tpos.y)		

end

main()