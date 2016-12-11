local heap = require "binary_heap"

local function shuffle(t)
	for i = 1, #t do
		local k = math.random(#t)
		t[i], t[k] = t[k], t[i]
	end
	return t
end

function manhattan(l, r)
	return math.abs(l.x - r.x) + math.abs(l.y - r.y)
end

function comparator(l, r)
	return l.dist+l.lb < r.dist+r.lb
end

function astar(map, ox, oy, dx, dy, includeEntities)
	nextTo = nextTo or false
	local open = heap:new(comparator)
	local visited = {}
	open:insert({x = ox, y = oy, parent=nil, dist = 0, lb = 0})

	local v
	local found = false
	while not found and not open:empty() do
		v = open:pop()
		if v.x == dx and v.y == dy then
			found = true
			break
		end
		if not visited[v.x*map:getRows() + v.y] then
			local neighbors = shuffle(map:neighbors(v))

			for _, neighbor in pairs(neighbors) do
				-- If we only want to be next to the target
				if nextTo and neighbor.x == dx and neighbor.y == dy then
					found = true
					break
				end
				if map:isWalkable(neighbor) and
						(not includeEntities or not map:isTileOccupied(neighbor)) then
					neighbor.dist = v.dist + 1
					neighbor.lb = manhattan({x = dx, y = dy}, neighbor)
					neighbor.parent = v
					open:insert(neighbor)
				elseif neighbor.x == dx and neighbor.y == dy then
					found = true
					break
				end
			end
			visited[v.x*map:getRows() + v.y] = true
		end
	end

	if not found then
		return {}
	end

	local path = {}
	while v.parent ~= nil do
		table.insert(path, {x = v.x, y = v.y})
		v = v.parent
	end

	return path
end

return astar
