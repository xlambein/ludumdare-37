
Crate = Entity:extend()

crateImg = love.graphics.newImage("assets/tileset01.png")
crateFrames = {
	love.graphics.newQuad(0 , 32, 32, 32, crateImg:getDimensions()),
	love.graphics.newQuad(32, 32, 32, 32, crateImg:getDimensions()),
	love.graphics.newQuad(64, 32, 32, 32, crateImg:getDimensions())
}

function Crate:new(x, y)
	local characs = {
		speed = 0,
		hp = 3,
		sounds = {
			hurt = crateSound,
			died = crateSound
		},
		w = 32,
		h = 32
	}
	Crate.super.new(self, crateImg, x, y, characs)
	self.frames = crateFrames
	self.frame = 1
end

function Crate:getName()
	return "CRATE"
end

function Crate:update(dt)
	-- Crate.super.update(self, dt)
	self.frame = math.min(#self.frames, 1 + math.floor(#self.frames*(self.hpmax - self.hp)/self.hpmax))
end

function Crate:draw()
	Entity.super.draw(self)
end
