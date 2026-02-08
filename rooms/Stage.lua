Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.timer = Timer()
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas(gw,gh)

    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.gun = self.area:addGameObject('Gun', self.player.x, self.player.y, {h = self.player.h, w = self.player.w})
    -- self.blob = self.area:addGameObject('EnemyBlob', gw/2, 50)

    self.area:addCollision(self.player)
    -- self.area:addCollision(self.blob)

    self.image_width = scifiTileset:getWidth()
    self.image_height = scifiTileset:getHeight()

    self.width = 32
    self.height = 32

    self.quads = {}

    self.timer:every(2, function() 
       self.test = self.area:addGameObject('EnemyBlob', random(0,(gw/2) +25), 50)
       self.area:addCollision(self.test)
    end)

    for i = 0,23 do
        for j = 0,7 do
            table.insert(self.quads, love.graphics.newQuad(0 + j * (self.width), 0 + i * (self.height), self.width, self.height, self.image_width, self.image_height))
        end
    end


    self.tilemap = {
        {9, 83, 83, 83, 84, 85, 86, 87, 88, 84, 83, 83, 83, 83, 13},
        {17, 113, 114, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 21},
        {17, 113, 113, 113, 113, 113, 113, 113, 113, 114, 113, 113, 113, 113, 21},
        {17, 113, 113, 114, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 21},
        {17, 113, 113, 113, 113, 113, 113, 113, 113, 114, 113, 113, 113, 113, 21},
        {17, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 21},
        {17, 121, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 21},
        {17, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 21},
        {25, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 43, 29}
    }

    for i,row in ipairs(self.tilemap) do
            for j,tile in ipairs(row) do
                if tile ~= 0 then
                    if tile == 1 or tile == 80 or tile == 82 or tile == 83 or tile == 84 or tile == 85 or tile == 86 or tile == 87 or tile == 88 or tile == 9  or tile == 13 or tile == 21 or tile == 17 or tile == 43 or tile == 59 then
                        self.walls = self.area:addGameObject('Wall', (j-1) * self.width, (i-1) * self.height)
                        self.area:addCollision(self.walls)
                    end
                end 
            end
        end

end

local playerFilter = function(item, other)
  if other.name == 'Projectile' then 
    return 'cross'
  elseif other.name == 'Wall' then
    return 'slide'
elseif other.name == 'EnemyBlob' then
    return 'slide'
end
  -- else return nil
end

local projectileFilter = function(item, other)
  if other.name == 'Wall' then 
    return 'touch'
  elseif other.name == 'Player' then
    return 'cross'
  elseif other.name == 'EnemyBlob' then
    return 'touch'
  end
  -- else return nil
end

local blobFilter = function(item, other)
  if other.name == 'Player' then 
    return 'slide'
  elseif other.name == 'Wall' then
    return 'slide'
  elseif other.name == "EnemyBlob" then
    return 'slide'
  
end
  -- else return nil
end

function Stage:update(dt)
    self.area:update(dt)
    self.timer:update(dt)

    if cameraProjectileOffset.x ~= 0 or cameraProjectileOffset.y ~= 0 then
        self.timer:tween('projoffet', 0.05, cameraProjectileOffset, {x = 0, y = 0}, 'in-out-linear')
    end
    



    -- self.area:move(self.blob, blobFilter)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, (gw/2), gh/2)
    -- camera:lookAt(self.player.x,self.player.y)
    camera:lookAt(self.player.x + camera.x_shake_offset + cameraProjectileOffset.x, self.player.y + camera.y_shake_offset + cameraProjectileOffset.y)


    local items, len = self.area.world:getItems()

    for i, item in ipairs(items) do
        -- print(item.name)
        if item.name == "Player" then
            self.area:move(self.player, playerFilter)
        elseif item.name == 'Projectile' then
            local actualX, actualY, cols, len = self.area:move(item,projectileFilter)

            for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
                local col = cols[i]
                -- print(("Collision with %s."):format(col.other.name))

                if col.other.name == "EnemyBlob" then
                    col.other:damage(item.damage)
                    item:die()
                end

                if col.other.name == "Wall" then
                    item:die()
                end

            end
        elseif item.name == "EnemyBlob" then
            local actualX, actualY, cols, len = self.area:move(item,blobFilter)
        
            for i=1, len do
                local col = cols[i]

                if col.other.name == "Player" then
                    col.other:damage(10)
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
                    love.graphics.draw(scifiTileset, self.quads[tile], (j-1) * self.width, (i-1) * self.height)
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