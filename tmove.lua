-- tmove

local args = {...}

local zm = tonumber(args[1])
local xm = tonumber(args[2])
local ym = tonumber(args[3])

function usage()

	print("--tmove v1.0")
	print(" Helps you move your turtle around! :)")
	print("")
	print("\tUsage: tmove(forward/back,left/right,up/down")
	print(" 'back', 'left', 'down' dorections are negative")
	print("")
	print("example: tmove(5)")
	print("         tmove(2,-1,4)")

end

function movefwd(count)
	for i=1, count do
		if turtle.forward(count) == false then
			break
		end
	end
end

function moveUp(count)
	for i=1, count do
		if turtle.up(count) == false then
			break
		end
	end
end

function moveDown(count)
	for i=1, count do
		if turtle.down(count) == false then
			break
		end
	end
end

function movezx(count)
	if count > 0 then
		movefwd(count)
	else
		turtle.turnLeft(2)
		movefwd(count)
	end
end

function movey(count)
	if count > 0 then
		turtle.up()
		turtle.forward(count)
	else
		turtle.down()
		turtle.forward(count)
	end
end

function main()
	if zm == nil then
		usage()
		exit(0)
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
			turtle.moveUp(ym)
		else
			print("Down : ", ym)
			turtle.moveUp(-ym)
		end
	end
end

main()