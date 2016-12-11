
Screen = Object:extend()

function Screen:new(stack)
	self.stack = stack
	self.entities = {}
end

function Screen:update(dt)
    for i=#self.entities,1,-1 do
        self.entities[i]:update(dt)

        if not self.entities[i]:isAlive() then
            table.remove(self.entities, i)
        end
    end
end

function Screen:draw()
    for i=#self.entities,1,-1 do
        self.entities[i]:draw()
    end
end

function Screen:addEntity(entity)
	table.insert(self.entities, entity)
	entity.level = self
end

function Screen:mousepressed(x, y, button)
end

function Screen:keypressed(scancode)
end
