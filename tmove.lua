-- tmove

local args = {...}

local zm = tonumber(args[1])
local xm = tonumber(args[2])
local ym = tonumber(args[3])

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

function movefwd(count)
	for i=1, count do
		if turtle.detect() == false then
			turtle.forward()
		else
			print("Blocked!")
			return 0
		end
	end
	return 1
end

function moveUp(count)
	for i=1, count do
		if turtle.detectUp() == false then
			turtle.up()
		else
			print("Blocked!")
			return 0
		end
	end
	return 1
end

function moveDown(count)
	for i=1, count do
		if turtle.detectDown() == false then
			turtle.down()
		else
			print("Blocked")
			return 0
		end
	end
	return 1
end

function Refuel(count)
	print("Refueling...")
	local fuelLevel = turtle.getFuelLevel()
	while fuelLevel < count do
		if turtle.refuel(1) == false then
			print("Insufficuent fuel onboard!")
		end
		fuelLevel = fuelLevel + turtle.getFuelLevel()
	end
end

function main()
	
	if zm == nil then
		usage()
		return
	end

	Refuel()
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
	
	-- move up/down
	if ym ~= nil then
		if ym > 0 then
			print("Up : ", ym)
			moveUp(ym)
		else
			print("Down : ", ym)
			moveDown(-ym)
		end
	end
end

main()