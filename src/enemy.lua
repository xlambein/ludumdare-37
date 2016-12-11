
Enemy = Entity:extend()

skeletonImg = love.graphics.newImage("assets/skeleton.png")

function Enemy:new(x, y)
	local characs = {
		speed = 64,
		hp = 5,
		cooldown = 2,
		strength = 1
	}
	Enemy.super.new(self, skeletonImg, x, y, characs)
	self.timer = 0
end

function Enemy:getName()
	return "ENEMY"
end

function Enemy:getTeam()
	return 'villains'
end

function Enemy:update(dt)
    if self.target == nil then
		if self.timer <= 0 then
	        dx, dy = self.map:coordinatesToTile(self.x, self.y)
	        dx, dy = dx + math.random(-2, 2), dy + math.random(-2, 2)
	        if self.map:isTileInMap(dx, dy) then
	            self:goTo(self.map:tileToCoordinates(dx, dy))
	        end
			self.timer = math.random()*3
		else
			self.timer = self.timer - dt
		end
    end

	Enemy.super.update(self, dt)
end
