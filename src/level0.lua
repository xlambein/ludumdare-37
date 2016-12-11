
Level0 = Screen:extend()

function Level0:new(stack)
	Level0.super.new(self, stack)

    self.camera = require "camera"
    self.camera:setOrigin(width/2, height/2)

    self.map = Map(self, require "assets/tileset01", require "assets/map02")

    self.camera:setBounds(
			-self.map.tilesize/2, -self.map.tilesize/2,
			self.map:getWidth()+self.map.tilesize/2, self.map:getHeight()+self.map.tilesize/2)

    self.player = Player(self.map:tileToCoordinates(self.map.player))
	self:addEntity(self.player)
    self.map:addEntity(self.player)

    self.titleFont = love.graphics.newFont("assets/runescape_uf.ttf", 128)
    self.titleFont:setFilter('linear', 'nearest')
end

function Level0:update(dt)
	Level0.super.update(self, dt)
    for _, entity in pairs(self.entities) do
        if entity:getTeam() == 'villains' then
			entity:setTarget(self.player)
		end
    end

	self.map:update(dt)

    self.camera:setPosition(self.player.x, self.player.y)
end

function Level0:draw()
    self.camera:set()

    self.map:draw()
	Level0.super.draw(self)

    self.camera:unset()

    if not self.player:isAlive() then
        local text = love.graphics.newText(self.titleFont)
        text:add({{128, 0, 0, 192}, " YOU DIED."})
        love.graphics.draw(text,
                (width  - text:getWidth())/2,
                (height - text:getHeight())/2)
    end
end

function Level0:mousepressed(x, y, button)
	if not self.player:isAlive() then
		self.stack:pop()
	end

    x, y = self.camera:relToAbs(x, y)
    self.player:setTarget(nil)
    if button == 1 then
        e = self:getEntityAt(x, y)
        if e and (e:getName() == 'ENEMY' or e:getName() == 'CRATE') then
            self.player:setTarget(e)
        else
	        self.player:goTo(x, y)
		end
    elseif button == 2 then
		if self.map:isWalkable(self.map:coordinatesToTile(x, y)) and
			self:getEntityAt(x, y) == nil then
			entity = Crate(self.map:truncateCoordinates(x, y))
			self.map:addEntity(entity)
			self:addEntity(entity)
		end
	end
end

function Level0:keypressed(scancode)
	if scancode == 'e' then
		if self.player:isAlive() then
			self.player:heal(10)
		end
	end
end

function Level0:getEntityAt(x, y)
	x, y = y and x or x.x, y or x.y
	for _, entity in pairs(self.entities) do
		if entity:coordinatesInside(x, y) then
			return entity
		end
	end
	return nil
end
