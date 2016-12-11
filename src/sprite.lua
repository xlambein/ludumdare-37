
Sprite = Object:extend()

function Sprite:new(image, x, y, w, h, ox, oy)
	self.image = image
	if self.image then
		self.image:setFilter('linear', 'nearest')
	end
	self.x = x or 0
	self.y = y or 0
	self.vx = 0
	self.vy = 0
	self.w = w or (self.image and image:getWidth() or 0)
	self.h = h or (self.image and image:getHeight() or 0)
	self.ox = ox or self.w/2
	self.oy = oy or self.h/2
end

function Sprite:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function Sprite:draw()
	if self.image then
		if self.frames then
			love.graphics.draw(self.image, self.frames[self.frame], self.x, self.y, 0, 1, 1, self.ox, self.oy)
		else
			love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.ox, self.oy)
		end
	end
end

function Sprite:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Sprite:setVelocity(vx, vy)
	self.vx = vx or self.vx
	self.vy = vy or self.vy
end

function Sprite:setOrigin(ox, oy)
	self.ox = ox or self.ox
	self.oy = oy or self.oy
end
