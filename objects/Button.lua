Button = GameObject:extend()

function Button:new(area,x,y,opts)
    Button.super.new(self,area,x,y,opts)
    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.text = opts.text
    self.font = fonts.m5x7_16
end

function Button:update(dt)
    Button.super.update(self,dt)
end

function Button:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(love.math.colorFromBytes(142, 188, 70))
    love.graphics.rectangle('fill',self.x,self.y,self.w,self.h, 10,10)
    love.graphics.setColor(love.math.colorFromBytes(104, 144, 48))
    love.graphics.print(self.text,self.x + ((self.w - self.font:getWidth(self.text))/2), self.y + ((self.h - self.font:getHeight(self.text))/2))
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
end