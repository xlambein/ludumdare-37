Map = Object:extend()
astar = require "astar"

local function findInTable(array, value)
	for i = 1, #array do
		if array[i] == value then
			return i
		end
	end
	return nil
end

function Map:new(level, tileset, map)
	self.tilesize = 32
	self.tileset = tileset
	self.map = map.map
	self.player = map.player
	self.entities = {}
	local texture = love.graphics.newImage('assets/' .. self.tileset.texture)
	texture:setFilter('linear', 'nearest')
	self.batch = love.graphics.newSpriteBatch(texture)

	for i = 1, #self.map do
		for j = 1, #self.map[i] do
			local tile = self.tileset.tiles[self.map[i][j]]
			local quad = love.graphics.newQuad(
					tile.x*self.tilesize, tile.y*self.tilesize,
					self.tilesize, self.tilesize,
					self.batch:getTexture():getDimensions())

			self.batch:add(quad, self.tilesize*(i-1), self.tilesize*(j-1))
		end
	end

	for _, e in pairs(map.entities) do
		local entity
		if e.args then
			x, y = self:tileToCoordinates(e)
			entity = _G[e.type](x, y, unpack(e.args))
		else
			entity = _G[e.type](self:tileToCoordinates(e))
		end
		self:addEntity(entity)
		level:addEntity(entity)
	end
end

function Map:update(dt)
    for i=#self.entities,1,-1 do
        if not self.entities[i]:isAlive() then
            table.remove(self.entities, i)
        end
    end
end

function Map:draw()
	love.graphics.draw(self.batch)
end

function Map:truncateCoordinates(x, y)
	return self:tileToCoordinates(self:coordinatesToTile(x, y))
end

function Map:coordinatesToTile(x, y)
	x, y = y and x or x.x, y or x.y
	return math.floor(x/self.tilesize), math.floor(y/self.tilesize)
end

function Map:tileToCoordinates(x, y)
	x, y = y and x or x.x, y or x.y
	return (x + 0.5)*self.tilesize, (y + 0.5)*self.tilesize
end

function Map:shortestPath(ox, oy, dx, dy, includeEntities)
	return astar(self, ox, oy, dx, dy, includeEntities)
end

function Map:getWidth()
	return #self.map * self.tilesize
end

function Map:getHeight()
	return #self.map[1] * self.tilesize
end

function Map:getCols()
	return #self.map
end

function Map:getRows()
	return #self.map > 0 and #self.map[1] or 0
end

function Map:isTileInMap(x, y)
	x, y = y and x or x.x, y or x.y
	return x >= 0 and y >= 0 and x < #self.map and y < #self.map[1]
end

function Map:isTileOccupied(x, y)
	return self:getEntityAt(x, y) ~= nil
end

function Map:getEntityAt(x, y)
	x, y = y and x or x.x, y or x.y
	for _, entity in pairs(self.entities) do
		ex, ey = self:coordinatesToTile(entity.dx, entity.dy)
		if x == ex and y == ey then
			return entity
		end
	end
	return nil
end

function Map:neighbors(x, y)
	x, y = y and x or x.x, y or x.y
	local neighbors = {}
	if x > 0              then table.insert(neighbors, {x = x-1, y = y  }) end
	if y > 0              then table.insert(neighbors, {x = x,   y = y-1}) end
	if x < #self.map-1    then table.insert(neighbors, {x = x+1, y = y  }) end
	if y < #self.map[1]-1 then table.insert(neighbors, {x = x,   y = y+1}) end
	return neighbors
end


function Map:isWalkable(x, y, solidityThreshold)
	if type(x) == 'table' then
		x, y, solidityThreshold = x.x, x.y, y
	end
	solidityThreshold = solidityThreshold or 0
	return self:isTileInMap(x, y) and
	       self.tileset.tiles[self.map[x+1][y+1]].solid <= solidityThreshold
end

function Map:addEntity(entity)
	entity.map = self
	table.insert(self.entities, entity)
	return #self.entities
end
