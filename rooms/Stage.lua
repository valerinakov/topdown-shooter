Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas(gw,gh)

    self.player = self.area:addGameObject('Player', gw/2, gh/2)

    self.wall = self.area:addGameObject('Wall', 500,250)

    self.area:addCollision(self.wall)

    self.area:addCollision(self.player)
end

local projectileFilter = function(item, other)
  if     other.name == 'Wall'   then return 'cross'

  end
  -- else return nil
end

function Stage:update(dt)
    self.area:update(dt)
    self.area:move(self.player)
    -- camera.smoother = Camera.smooth.damped(5)
    -- camera:lockPosition(dt, (gw/2), gh/2)
    camera:lookAt(self.player.x,self.player.y)
    local items, len = self.area.world:getItems()

    for i, item in ipairs(items) do
        if item.name == 'Projectile' then
            self.area:move(item,projectileFilter)
            print('x' .. item.x)
            print('y' .. item.y)
        end
    end
end



function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,gw,gh)
        if self.area then self.area:draw() end
    camera:detach()
    love.graphics.setCanvas()

        love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.player = nil
    self.area = nil
end