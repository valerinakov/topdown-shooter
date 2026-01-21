Wall = GameObject:extend()

function Wall:new(area,x,y,opts)
    Wall.super.new(self,area,x,y,opts)
    self.name = 'Wall'
    self.depth = 1
    self.x,self.y = x, y
    self.w,self.h = 32,32

    -- quad = love.graphics.newQuad(
    --     32, 16, 16, 16,
    --     walls:getDimensions()
    -- )
end

function Wall:update(dt)
    Wall.super.update(self,dt)

end

function Wall:draw()
    -- love.graphics.draw(wall, self.x, self.y)
    -- love.graphics.draw(walls, quad, self.x, self.y)
    -- love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end