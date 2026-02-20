Button = GameObject:extend()

function Button:new(area,x,y,opts)
    Button.super.new(self,area,x,y,opts)
    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.text = opts.text
    self.font = fonts.m5x7_16

    self.p_color = opts.p_color
    self.s_color = opts.s_color
    self.color = opts.p_color
    self.test = true;
end

function Button:update(dt)
    Button.super.update(self,dt)

    self.mx, self.my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)

    if (self.mx > self.x and self.mx < self.x + self.w) and (self.my > self.y and self.my < self.y + self.h) then
        if self.test then
            self.test = false
                self.timer:tween(0.5, self.color, self.s_color, 'in-out-quad', function() 
                    self.test = true
                end)
        end
    else
        if self.test then
            self.test = false
            self.timer:tween(0.5, self.color, self.p_color, 'in-out-quad', function() 
                self.test = true
            end)

        end
        -- self.color = self.p_color
    end

end

function Button:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(love.math.colorFromBytes(self.color))
    love.graphics.rectangle('fill',self.x,self.y,self.w,self.h, 10,10)
    love.graphics.setColor(love.math.colorFromBytes(104, 144, 48))
    love.graphics.print(self.text,self.x + ((self.w - self.font:getWidth(self.text))/2), self.y + ((self.h - self.font:getHeight(self.text))/2))
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
end

