-- tmove
local tposLib = assert(loadfile('/rom/apis/tpos'))
tposLib()

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
		
	if Refuel(1, zm+ym+xm) == false then
		return
	end
	
	print("Turtle moving")
	
	jQ = jobQueue.new()

	job = {Q_tposMoveRel, {tpos, zm, xm, ym}}

	jobQueue.pushright(jQ, job)
	
	joqQueue.run(jQ)

end


main()