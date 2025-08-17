ShootEffect = GameObject:extend()

function ShootEffect:new(area,x,y,opts)
    ShootEffect.super.new(self,area,x,y,opts)
    self.x = x
    self.y = y
    self.s = 2.5
    self.depth = 2
    self.timer:after(0.1, function() 
        self.dead = true
    end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self,dt)
end

function ShootEffect:draw()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 0))
    love.graphics.circle('fill', self.x, self.y, self.s*2)
end

