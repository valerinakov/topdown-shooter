Shop = Object:extend()

function Shop:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area:addGameObject('Button', 50, 50)
    self.main_canvas = love.graphics.newCanvas(gw,gh)

    self.mx = 0
    self.my = 0

end

function Shop:update(dt)
    -- camera.smoother = Camera.smooth.none()
    camera:lookAt(gw/2,gh/2)
    -- camera:lockPosition(dt, (gw/2), gh/2)

    self.area:update(dt)
    print(sx*gw)
    print(sy*gh)
    self.mx, self.my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)


    if(self.mx > 50 and self.mx < 100 and self.my > 50 and self.my < 100) then
        gotoRoom("Stage")
    end
end

function Shop:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,gw,gh)
    if self.area then self.area:draw() end

    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end