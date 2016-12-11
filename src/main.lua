
screenstack = {}

function screenstack:push(level, args)
    table.insert(self, level(self, args))
end

function screenstack:pop()
    table.remove(self, #self)
end

function screenstack:top()
    return self[#self]
end


function love.load()
    Object = require "classic"

    require "screen"
    require "mainmenu"
    require "level0"
    require "map"
    require "sprite"
    require "entity"
    require "spawner"
    require "enemy"
    require "player"
    require "crate"

    hurtSound = love.sound.newSoundData("assets/hurt.wav")
    diedSound = love.sound.newSoundData("assets/died.wav")
    crateSound = love.sound.newSoundData("assets/crate.wav")

    scaling = 2.0
    width, height = 640, 640
    love.window.setMode(width*scaling, height*scaling)

    screenstack:push(MainMenu)
end

function love.update(dt)
    if screenstack:top() then
        screenstack:top():update(dt)
    else
        love.event.quit()
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scaling)
    if screenstack:top() then
        screenstack:top():draw()
    end
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if screenstack:top() then
        screenstack:top():mousepressed(x/scaling, y/scaling, button)
    end
end

function love.keypressed(key, scancode)
    if screenstack:top() then
        screenstack:top():keypressed(scancode)
    end
end
