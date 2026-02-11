Button = Object:extend()

function Button:new()
    self.x = 50
    self.y = 50
    self.w = 50
    self.h = 50
end

function Button:update(dt)
end

function Button:draw()
    love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
end