
Entity = Sprite:extend()

local function sign(x)
	if     x > 0  then return 1
	elseif x == 0 then return 0
	else               return -1
	end
end

function Entity:new(image, x, y, characs)
	Entity.super.new(self, image, x, y, characs.w, characs.h)
	self.map = nil
	self.dx = self.x
	self.dy = self.y
	self.path = {}
	self.target = nil

	self.speed = characs.speed or 100
	self.hpmax = characs.hp or 10
	self.cooldownmax = characs.cooldown or 1
	self.strength = characs.strength or 1
	self.sounds = {hurt = hurtSound, died = diedSound}
	if characs.sounds then
		self.sounds.hurt = characs.sounds.hurt or self.sounds.hurt
		self.sounds.died = characs.sounds.died or self.sounds.died
	end

	self.hp = self.hpmax
	self.cooldown = 0
end

function Entity:getName()
	return "ENTITY"
end

function Entity:getTeam()
	return 'neutral'
end

function Entity:update(dt)
	if self.vx == 0 and self.vy == 0 then
		if self.target then
			if self.target:isAlive() then
				self:attack(self.target)
			else
				self.target = nil
			end
		end
		if next(self.path) then
			local d = table.remove(self.path, #self.path)
			if not self.map:isTileOccupied(self.map:coordinatesToTile(d)) then
				self:setDestination(d.x, d.y)
				self:setVelocity(self.speed * sign(self.dx - self.x),
				                 self.speed * sign(self.dy - self.y))
			elseif next(self.path) then
				local e = self.map:getEntityAt(self.map:coordinatesToTile(d))
				self:goTo(self.path[1])
				if e:getTeam() ~= self:getTeam() then
					self:attack(e)
				end
			else
				self.path = {}
			end
		end
	end

	sx, sy = sign(self.x - self.dx), sign(self.y - self.dy)

	Entity.super.update(self, dt)

	local dtnew
	if     self.vx and sx ~= 0 and sign(self.x - self.dx) == -sx then -- X overshoot
		dtnew = math.abs(self.dx - self.x)/self.vx
		self.x = self.dx
		self:setVelocity(0, 0)
	elseif self.vy and sy ~= 0 and sign(self.y - self.dy) == -sy then
		dtnew = math.abs(self.dy - self.y)/self.vy
		self.y = self.dy
		self:setVelocity(0, 0)
	end

	if dtnew then
		self:update(dtnew)
	end

	self.cooldown = math.max(0, self.cooldown - dt)
end

function Entity:draw()
	Entity.super.draw(self)

	hpbox = {color = {0, 0, 0}, w = 26, h = 4, x = 0, y = -20}
	hpbar = {color = {255, 0, 0}, w = 24, h = 2, x = 0, y = -20}

	cdbox = {color = {0, 0, 0}, w = 26, h = 4, x = 0, y = -23}
	cdbar = {color = {0, 0, 255}, w = 24, h = 2, x = 0, y = -23}

	love.graphics.push()
		love.graphics.translate(self.x, self.y)

		if self.hp ~= self.hpmax then
			love.graphics.setColor(hpbox.color)
			love.graphics.rectangle('fill',
					hpbox.x - hpbox.w/2, hpbox.y - hpbox.h/2,
					hpbox.w, hpbox.h)
			love.graphics.setColor(hpbar.color)
			love.graphics.rectangle('fill',
					hpbar.x - hpbar.w/2, hpbar.y - hpbar.h/2,
					hpbar.w * self.hp/self.hpmax, hpbar.h)
			love.graphics.setColor(255, 255, 255)
		end

		if self.cooldown ~= 0 then
			love.graphics.setColor(cdbox.color)
			love.graphics.rectangle('fill',
					cdbox.x - cdbox.w/2, cdbox.y - cdbox.h/2,
					cdbox.w, cdbox.h)
			love.graphics.setColor(cdbar.color)
			love.graphics.rectangle('fill',
					cdbar.x - cdbar.w/2, cdbar.y - cdbar.h/2,
					cdbar.w * self.cooldown/self.cooldownmax, cdbar.h)
			love.graphics.setColor(255, 255, 255)
		end
	love.graphics.pop()
end

function Entity:setDestination(dx, dy)
	self.dx = dx
	self.dy = dy
end

function Entity:setPath(path)
	if path and next(path) then
		self.path = path
	end
end

function Entity:goTo(x, y)
    if type(x) == 'table' then
        x, y = x.dx or x.x, x.dy or x.y
    end

    local ox, oy = self.map:coordinatesToTile(self.dx, self.dy)
    local dx, dy = self.map:coordinatesToTile(x, y)
    local path = self.map:shortestPath(ox, oy, dx, dy, true)
	if not next(path) then
		path = self.map:shortestPath(ox, oy, dx, dy, false)
	end
    for i, t in ipairs(path) do
        path[i] = {}
        path[i].x, path[i].y = self.map:tileToCoordinates(t.x, t.y)
    end
    self:setPath(path)
end

function Entity:setTarget(entity)
	self.target = entity
end

function Entity:attack(entity)
    local ox, oy = self.map:coordinatesToTile(self.dx, self.dy)
    local dx, dy = self.map:coordinatesToTile(entity.x, entity.y)
	if math.abs(ox - dx) + math.abs(oy - dy) <= 1 then
		if self.cooldown == 0 then
			entity:hurt(self, self.strength)
			self.cooldown = self.cooldownmax
		end
	else
		self:goTo(entity)
	end
end

function Entity:hurt(entity, strength)
	self.hp = math.max(0, self.hp - strength)
	if self:isAlive() then
		love.audio.newSource(self.sounds.hurt):play()
	else
		love.audio.newSource(self.sounds.died):play()
	end
	-- if not next(self.path) and not self.target then
	-- 	self.target = entity
	-- end
end

function Entity:heal(hp)
	self.hp = math.min(self.hpmax, self.hp + hp)
end

function Entity:isStationary()
	return self.x == self.dx and self.y == self.dy
end

function Entity:isAlive()
	return self.hp > 0
end

function Entity:coordinatesInside(x, y)
	x, y = y and x or x.x, y or x.y

	return x >= self.x - self.ox and y >= self.y - self.oy and
		x <= self.x - self.ox + self.w and y <= self.y - self.oy + self.h
end
