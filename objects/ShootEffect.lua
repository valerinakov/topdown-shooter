ShootEffect = GameObject:extend()

function ShootEffect:new(area,x,y,opts)
    ShootEffect.super.new(self,area,x,y,opts)
    self.x = x
    self.y = y
    self.s = 2.5
    self.depth = 51
    self.timer:after(0.05, function() 
        self.dead = true
    end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self,dt)
end

function ShootEffect:draw()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 0))
    love.graphics.circle('fill', self.x, self.y, (self.s*2)+1)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    love.graphics.circle('fill', self.x, self.y, (self.s*2)+0.3)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 0))
    love.graphics.circle('fill', self.x, self.y, self.s*2)
end

