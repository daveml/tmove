-- tmove

local args = {...}

local zm = args[1]
local xm = args[2]
local ym = args[3]

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

function movezx(count)
	if count > 0 then
		turtle.forward(count)
	else
		turtle.turnLeft(2)
		turtle.forward(count)
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
	end
	
	movezx(zm)
	if xm ~= nil then
		movezx(xm)
	end
	if ym ~= nil then
		movey(count)
	end

end

main()