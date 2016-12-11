-- From: http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/

camera = {}
camera.x = 0
camera.y = 0
camera.ox = 0
camera.oy = 0
camera.scaleX = 1
camera.scaleY = 1

local function clamp(x, min, max)
  return min > max and (min+max)/2 or
  		(x < min and min or (x > max and max or x))
end

function camera:set()
	love.graphics.push()
	love.graphics.scale(self.scaleX, self.scaleY)
	love.graphics.translate(self.ox, self.oy)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	self:setPosition(self.x + (dx or 0), self.y + (dy or 0))
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function camera:setOrigin(ox, oy)
	self.ox = ox or self.ox
	self.oy = oy or self.oy
end

function camera:setPosition(x, y)
	if self.bounds then
		x = x or self.x
		y = y or self.y
		self.x = clamp(x,
				self.bounds.x0+self.ox,
				self.bounds.x1-width+self.ox)
		self.y = clamp(y,
				self.bounds.y0+self.oy,
				self.bounds.y1-height+self.oy)
	else
		self.x = x or self.x
		self.y = y or self.y
	end
end

function camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end

function camera:setBounds(x0, y0, x1, y1)
	self.bounds = {x0 = x0, y0 = y0, x1 = x1, y1 = y1}
end

function camera:relToAbs(x, y)
	x, y = x / self.scaleX, y / self.scaleY
	x, y = x - self.ox, y - self.oy
	x, y = x + self.x, y + self.y
	return x, y
end

return camera
