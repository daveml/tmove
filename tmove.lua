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

print(args)
print(args[1])

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