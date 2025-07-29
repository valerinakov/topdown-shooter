Gun = GameObject:extend()

function Gun:new(area,x,y,opts)
    Gun.super.new(self,area,x,y,opts)

    self.mx, self.my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
    self.angle = math.atan2(self.my - (self.y + (self.h/2)), self.mx - (self.x + (self.w/2)))
end

function Gun:update(dt)
    Gun.super.update(self,dt)

    self.x = current_room.player.x
    self.y = current_room.player.y

    self.mx, self.my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
    self.angle = math.atan2(self.my - (self.y + (self.h/2)), self.mx - (self.x + (self.w/2)))

    if self.my > self.y then
        self.depth = 53
    else
        self.depth = 47
    end

end

function Gun:draw()

    if self.mx < self.x then
        love.graphics.draw(gun, self.x + self.w/2 , self.y + self.h/2 , self.angle + 0.08, 1,-1)
    end
    
    if self.mx >= self.x then 
        love.graphics.draw(gun, self.x + self.w/2 , self.y + self.h/2 , self.angle - 0.08, 1, 1)
    end
end