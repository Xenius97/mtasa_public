--======================= X E N I U S =======================--
--====================== 2017. 02. 26. ======================--
local works = {}
local workTimers = {}
local tableItems = {}
function startNewWork(tbl, callback, time, loadCount)
	local count = #tbl
	if not works[time] then
		works[time] = {}
	end

	loadCount = tonumber(loadCount) or 1
	table.insert(works[time], {tbl, callback, 0, count, loadCount, getTickCount()})
	
	if not isTimer(workTimers[time]) then
		workTimers[time] = setTimer(resumeWork, time, 0, time)
	end
	
	outputDebugString("[WORKER] Thread started: "..time.."ms, loadCount: "..loadCount..", items: "..count)
end

function clearWork(time)
	if isTimer(workTimers[time]) then
		killTimer(workTimers[time])
	end
	
	if works[time] then
		works[time] = nil
	end
end

function calculateTime(ms)
	local s = (ms/1000)
	return string.format("%.2d:%.2d:%.2d", s/(60*60), s/60%60, s%60)
end

function resumeWork(time)
	local workData = works[time]
	if workData and #workData >= 1 then
		for key, tbl in ipairs(workData) do
			local theTable = tbl[1]
			local callback = tbl[2]
			local processed = tbl[3]
			local loadCount = tbl[5]
			
			for i=1, loadCount do
				local first = theTable[i]
				if first then
					tbl[3] = tbl[3] + 1
					if tbl[3] >= tbl[4] then
						clear = true
					else
						clear = false
					end
					table.remove(theTable, i)
					local co = coroutine.create(callback)
					coroutine.resume(co, first, tbl[3], tbl[4])
				end
			end
			
			if clear then
				workData[key] = nil
				outputDebugString("[WORKER] Thread finished in "..calculateTime(getTickCount()-tbl[6])..", ID: "..key)
			end
		end
	else
		clearWork(time)
	end
end
