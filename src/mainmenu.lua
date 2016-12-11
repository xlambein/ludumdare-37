
MainMenu = Screen:extend()

function MainMenu:new(stack)
	MainMenu.super.new(self, stack)

	local titleFont = love.graphics.newFont("assets/runescape_uf.ttf", 64)
	local titleText = "Left-click anywhere to start a new game"
	self.title = love.graphics.newText(titleFont)
    self.title:addf({{255, 255, 255, 255}, titleText}, width*3/4, 'center')

	local helpFont = love.graphics.newFont("assets/runescape_uf.ttf", 32)
	local helptext =
	"How to play:\n"..
	"- Left-click to move or attack\n"..
	"- E to heal\n"..
	"- Don't die"
	self.help = love.graphics.newText(helpFont)
    self.help:addf({{50, 50, 255, 255}, helptext}, width*3/4, 'left')
end

function MainMenu:draw()
	MainMenu.super.draw(self)

    love.graphics.draw(self.title,
            (width  - self.title:getWidth())/2,
            height/2 - self.title:getHeight() - 25)

    love.graphics.draw(self.help,
            (width  - self.help:getWidth())/2,
            height/2 + 25)
end

function MainMenu:mousepressed(x, y, button)
	if button == 1 then
		self.stack:push(Level0)
	end
end
