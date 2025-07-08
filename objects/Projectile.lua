Projectile = GameObject:extend()

function Projectile:new(area,x,y,opts)
    Projectile.super.new(self,area,x,y,opts)
    self.name = 'Projectile'

    self.x = x
    self.y = y
    self.s = opts.s or 2.5
    self.v = opts.v or 200
    self.r = opts.r
end

function Projectile:update(dt)
    Projectile.super.update(self,dt)

    self.x = self.x + (math.cos(self.r)*dt*self.v)
    self.y = self.y + (math.sin(self.r)*dt*self.v)

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
end

function Projectile:draw()
    love.graphics.setColor(love.math.colorFromBytes(0, 234, 255))
    love.graphics.circle('fill', self.x, self.y, self.s)
end

function Projectile:die()
    self.dead = true
end