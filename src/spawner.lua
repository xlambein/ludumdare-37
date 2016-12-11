
Spawner = Entity:extend()

local function randDuration(min, max)
	min, max = max and min or min[1], max or min[2]
	return min + math.random()*(max-min)
end

function Spawner:new(x, y, entity, period)
	local characs = {
		speed = 0,
		hp = inf
	}
	Spawner.super.new(self, nil, x, y, characs)
	self.entity = entity
	self.period = period
	self.timer = randDuration(self.period)
end

function Spawner:getName()
	return "SPAWNER"
end

local function pickNeighbor(map, entity)
	local neighbors = {}
	for _, neighbor in pairs(map:neighbors(map:coordinatesToTile(entity))) do
		if map:isWalkable(neighbor) and not map:isTileOccupied(neighbor) then
			table.insert(neighbors, neighbor)
		end
	end
	return neighbors[math.random(#neighbors)]
end

function Spawner:update(dt)
	Spawner.super.update(self, dt)

	self.timer = self.timer - dt
	if self.timer < 0 then
		if self:spawn() then
			self.timer = randDuration(self.period)
		else
			self.timer = self.period[1]
		end
	end
end

function Spawner:spawn()
	local neighbor = pickNeighbor(self.map, self)
	if neighbor then
		local x, y = self.map:tileToCoordinates(neighbor)
		local entity
		if self.entity.args then
			entity = _G[self.entity.type](x, y, unpack(self.entity.args))
		else
			entity = _G[self.entity.type](x, y)
		end
		self.map:addEntity(entity)
		self.level:addEntity(entity)
		return true
	else
		return false
	end
end

function Spawner:draw()
end
