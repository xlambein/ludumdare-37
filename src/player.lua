
Player = Entity:extend()

playerImg = love.graphics.newImage("assets/player.png")

function Player:new(x, y)
	local characs = {
		speed = 128,
		hp = 20,
		cooldown = 0.25,
		strength = 3
	}
	Player.super.new(self, playerImg, x, y, characs)
end

function Player:getName()
	return "PLAYER"
end

function Player:getTeam()
	return 'heroes'
end
