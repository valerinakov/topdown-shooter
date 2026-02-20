Shop = Object:extend()

function Shop:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.next_wave_button =self.area:addGameObject('Button', (gw/2) - 25, gh - 100, {w = 80, h = 50, text = "Next Wave", p_color = {142, 188, 70}, s_color = {85,112,46}})
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
    self.mx, self.my = 0,0


    if input:pressed('mouse1', dt) then
        self.mx, self.my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
    end

    if self.mx > self.next_wave_button.x and self.mx < self.next_wave_button.x + self.next_wave_button.w and self.my > self.next_wave_button.y and self.my < self.next_wave_button.y + self.next_wave_button.h then
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

function Shop:destroy()
    self.next_wave_button = nil
    self.area:destroy()
    self.area = nil
end