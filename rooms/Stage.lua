Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.timer = Timer()
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas(gw,gh)

    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.gun = self.area:addGameObject('Gun', self.player.x, self.player.y, {h = self.player.h, w = self.player.w})

    self.area:addCollision(self.player)

    self.image_width = tileset:getWidth()
    self.image_height = tileset:getHeight()

    self.width = 16
    self.height = 16

    self.quads = {}

    for i = 0,6 do
        for j = 0,10 do
            table.insert(self.quads, love.graphics.newQuad(1 + j * (self.width), 1 + i * (self.height), self.width, self.height, self.image_width, self.image_height))
        end
    end

    -- self.tilemap = {
    --     {12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25},
    --     {34, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 36}

    -- }

    self.tilemap = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

    }

    for i,row in ipairs(self.tilemap) do
            for j,tile in ipairs(row) do
                if tile ~= 0 then
                    if tile == 1 then
                        self.walls = self.area:addGameObject('Wall', (j-1) * self.width, (i-1) * self.height)
                        self.area:addCollision(self.walls)
                    end
                    if tile == 2 then
                        -- love.graphics.draw(floor, (j-1) * self.width, (i-1) * self.height)
                    end
                    -- love.graphics.draw(tileset, self.quads[tile], (j-1) * self.width, (i-1) * self.height)
                end 
            end
        end

end

local playerFilter = function(item, other)
  if other.name == 'Projectile' then 
    return 'cross'
      elseif other.name == 'Wall' then
    print('here')
    return 'slide'
end
  -- else return nil
end

local projectileFilter = function(item, other)
  if other.name == 'Wall' then 
    return 'touch'
  elseif other.name == 'Player' then
    return 'cross'
end
  -- else return nil
end

function Stage:update(dt)
    self.area:update(dt)
    self.timer:update(dt)

    print('player x' .. self.player.x)

    if cameraProjectileOffset.x ~= 0 or cameraProjectileOffset.y ~= 0 then
        self.timer:tween('projoffet', 0.05, cameraProjectileOffset, {x = 0, y = 0}, 'in-out-linear')
    end

    self.area:move(self.player, playerFilter)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, (gw/2), gh/2)
    -- camera:lookAt(self.player.x,self.player.y)
    camera:lookAt(self.player.x + camera.x_shake_offset + cameraProjectileOffset.x, self.player.y + camera.y_shake_offset + cameraProjectileOffset.y)


    local items, len = self.area.world:getItems()

    for i, item in ipairs(items) do
        if item.name == 'Projectile' then
            local actualX, actualY, cols, len = self.area:move(item,projectileFilter)

            for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
                local col = cols[i]
                print(("Collision with %s."):format(col.other.name))

                if col.other.name == "Wall" then
                    item:die()
                end

            end
        end
    end
end



function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0,0,gw,gh)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
        for i,row in ipairs(self.tilemap) do
            for j,tile in ipairs(row) do
                if tile ~= 0 then
                    -- if tile == 1 then
                    --     self.walls = self.area:addGameObject('Wall', (j-1) * self.width, (i-1) * self.height)
                    --     self.area:addCollision(self.walls)
                    -- end
                    if tile == 2 then
                        love.graphics.draw(floor,(j-1) * self.width, (i-1) * self.height)
                    end
                    -- love.graphics.draw(tileset, self.quads[tile], (j-1) * self.width, (i-1) * self.height)
                end 
            end
        end
        if self.area then self.area:draw() end
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.player = nil
    self.area = nil
end