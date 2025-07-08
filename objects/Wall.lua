Wall = GameObject:extend()

function Wall:new(area,x,y,opts)
    Wall.super.new(self,area,x,y,opts)
    self.name = 'Wall'

    self.x,self.y = x, y
    self.w,self.h = 50,150
end

function Wall:update(dt)
    Wall.super.update(self,dt)

end

function Wall:draw()
    love.graphics.setColor(love.math.colorFromBytes(50, 2, 255))
    love.graphics.rectangle("fill", self.x,self.y, self.w,self.h)
end