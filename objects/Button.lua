Button = GameObject:extend()

function Button:new(area,x,y,opts)
    Button.super.new(self,area,x,y,opts)
    self.x = x
    self.y = y
    self.w = 50
    self.h = 50
end

function Button:update(dt)
    Button.super.update(self,dt)
end

function Button:draw()
    love.graphics.setColor(love.math.colorFromBytes(55, 111, 10))
    love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
end