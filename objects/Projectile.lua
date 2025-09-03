Projectile = GameObject:extend()

function Projectile:new(area,x,y,opts)
    Projectile.super.new(self,area,x,y,opts)
    self.name = 'Projectile'

    self.x = x
    self.y = y
    self.s = opts.s or 2.5
    self.v = opts.v or 300
    self.r = opts.r
    self.depth = 5100

    self.w = opts.s or 2.5
    self.h = opts.s or 2.5
    -- self.timer:after(2, function() 
    --     self:die()
    -- end)

        love.graphics.setColor(love.math.colorFromBytes(255, 234, 255))
    love.graphics.circle('fill', self.x, self.y, self.s*2)
end

function Projectile:update(dt)
    Projectile.super.update(self,dt)

    self.x = self.x + (math.cos(self.r)*dt*self.v)
    self.y = self.y + (math.sin(self.r)*dt*self.v)

    -- print('x' .. self.x)
    -- print('y' .. self.y)

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
end

function Projectile:draw()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 0))
    love.graphics.circle('fill', self.x, self.y, self.s*2)
    -- love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Projectile:die()
    self.dead = true
end