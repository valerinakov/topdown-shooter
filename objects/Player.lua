Player = GameObject:extend()

function Player:new(area,x,y,opts)
    Player.super.new(self,area,x,y,opts)
    self.name = 'Player'
    self.x,self.y = x, y
    self.w,self.h = 12,12
    self.animationState = 'Idle'

    self.gunslingerIdleFrames = {}
    self.gunslingerMovingFrames = {}

    self.frame_width = 48
    self.frame_height = 32

	-- table.insert(self.gunslingerIdleFrames, love.graphics.newQuad(0,0,self.frame_width,self.frame_height, gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))

    for i=0,6 do
        table.insert(self.gunslingerIdleFrames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height,gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))
    end

    for i=0,8 do
        table.insert(self.gunslingerMovingFrames, love.graphics.newQuad(i * self.frame_width, 32, self.frame_width, self.frame_height,gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))
    end


    self.currentFrame = 1
end

function Player:update(dt)
    Player.super.update(self,dt)

    if input:down('left') then
        self.animationState = 'Moving' 
        self.x = self.x - 1    
    end

    if input:down('right') then
        self.animationState = 'Moving'
        self.x = self.x + 1
    end

    if input:down('up') then
        self.animationState = 'Moving'
        self.y = self.y - 1
    end

    if input:down('down') then
        self.animationState = 'Moving'
        self.y = self.y + 1    
    end

    if  not input:down('left') and not input:down('right') and not input:down('up') and not input:down('down') then
        self.animationState = 'Idle'
    end

    self.currentFrame = self.currentFrame + (10 * dt)
    if self.currentFrame >= 7 then
        self.currentFrame = 1
    end

    if input:pressed('mouse1', dt) then
        local mx,my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
        local angle = math.atan2(my - (self.y + (self.h/2)), mx - (self.x + (self.w/2)))
        self.projectile = self.area:addGameObject('Projectile', (self.x + (self.w/2)) , (self.y + (self.h/2)), {r = angle})
        cameraProjectileOffset.x = cameraProjectileOffset.x + (3* math.cos(angle))
        cameraProjectileOffset.y = cameraProjectileOffset.y + (3*math.sin(angle))
        print('y offset' , cameraProjectileOffset.y)
        self.area:addCollision(self.projectile)
        camera:shake(1,60,0.2)
    end
end

function Player:draw()
    local mx,my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
    local angle = math.atan2(my - (self.y + (self.h/2)), mx - (self.x + (self.w/2)))
    
    if mx < self.x then
        if self.animationState == 'Idle' then
            love.graphics.draw(gunslingerSpriteMap, self.gunslingerIdleFrames[math.floor(self.currentFrame)], self.x - 18, self.y - 20,0,-1,1,48)
        end
        if self.animationState == 'Moving' then
            love.graphics.draw(gunslingerSpriteMap, self.gunslingerMovingFrames[math.floor(self.currentFrame)], self.x -18, self.y - 20, 0, -1, 1, 48)
        end
    end
    
    if mx >= self.x then 
        if self.animationState == 'Idle' then
            love.graphics.draw(gunslingerSpriteMap, self.gunslingerIdleFrames[math.floor(self.currentFrame)], self.x - 18, self.y - 20)
        end

        if self.animationState == 'Moving' then
            love.graphics.draw(gunslingerSpriteMap, self.gunslingerMovingFrames[math.floor(self.currentFrame)], self.x - 18, self.y - 20)
        end
    end
    
    -- love.graphics.rectangle("fill", self.x + 18, self.y + 20 ,self.w, self.h)
end