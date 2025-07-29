Wall = GameObject:extend()

function Wall:new(area,x,y,opts)
    Wall.super.new(self,area,x,y,opts)
    self.name = 'Wall'

    self.x,self.y = x, y
    self.w,self.h = 16,16
end

function Wall:update(dt)
    Wall.super.update(self,dt)

end

function Wall:draw()
    love.graphics.draw(wall, self.x, self.y)
    -- love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end