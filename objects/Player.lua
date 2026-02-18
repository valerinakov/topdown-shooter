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

    self.invincible = false
    self.blink = false

	-- table.insert(self.gunslingerIdleFrames, love.graphics.newQuad(0,0,self.frame_width,self.frame_height, gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))

    for i=0,6 do
        table.insert(self.gunslingerIdleFrames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height,gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))
    end

    for i=0,8 do
        table.insert(self.gunslingerMovingFrames, love.graphics.newQuad(i * self.frame_width, 32, self.frame_width, self.frame_height,gunslingerSpriteMap:getWidth(), gunslingerSpriteMap:getHeight()))
    end

    self.shootSource = love.audio.newSource('/resources/audio/pistol-shoot.wav', 'static')
    self.shootSound = Ripple.newSound(self.shootSource)

    self.moveSource = love.audio.newSource('/resources/audio/moving.wav', 'static')
    self.moveSound = Ripple.newSound(self.moveSource)
    self.movingStopped = true

    local angle = 0

    self.currentFrame = 1
    
end

function Player:update(dt)
    Player.super.update(self,dt)
    
    if self.invincible and not self.blink then 
        self.timer:after(0.05, function() 
            self.blink = true
        end)
    end

    if self.animationState == 'Moving' and self.movingStopped then
        self.movingStopped = false
        local moveSound = self.moveSound:play()
        self.timer:after(0.4, function() 
            self.movingStopped = true
        end)
    
    end

    if input:down('left') then
        self.animationState = 'Moving' 
        self.x = self.x - 60*dt    
    end

    if input:down('right') then
        self.animationState = 'Moving'
        self.x = self.x + 60*dt
    end

    if input:down('up') then
        self.animationState = 'Moving'
        self.y = self.y - 60*dt
    end

    if input:down('down') then
        self.animationState = 'Moving'
        self.y = self.y + 60*dt   
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
        local standardAngle = math.atan2(my - (self.y + (self.h/2)), mx - (self.x + (self.w/2)))
        angle = standardAngle + random(-math.pi/24,math.pi/24)
        self.area:addGameObject('ShootEffect', (self.x + (self.w/2)) + (14*math.cos(angle)) , (self.y + (self.h/2)) + (14*math.sin(angle)))
        self.projectile = self.area:addGameObject('Projectile', (self.x + (self.w/2)) + (14*math.cos(angle)) , (self.y + (self.h/2)) + (14*math.sin(angle)), {r = angle})
        cameraProjectileOffset.x = cameraProjectileOffset.x + (3* math.cos(angle))
        cameraProjectileOffset.y = cameraProjectileOffset.y + (3*math.sin(angle))
        self.area:addCollision(self.projectile)
        camera:shake(1,60,0.2)
        self.shootSound:play()
    end
end

function Player:draw()
    local mx,my = camera:getMousePosition(sx,sy,0,0,sx*gw,sy*gh)
    -- local angle = math.atan2(my - (self.y + (self.h/2)), mx - (self.x + (self.w/2)))
    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0, 100))
    love.graphics.ellipse('fill', self.x + 6,self.y + 10, self.w/2, self.h/4)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    if self.invincible and self.blink then 
        self.timer:after(0.05, function() 
            self.blink = false
        end)
    else
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
    end

    
    -- love.graphics.rectangle("fill", self.x + 18, self.y + 20 ,self.w, self.h)
end

function Player:damage(n)
    if self.invincible == false then
        self.invincible = true
        hp = hp - n

        self.timer:after(2, function() 
            self.invincible = false
        end)

        slow(0.75,0.25)
        camera:shake(6, 30, 0.2)
    end
    
    if hp <= 0 then
        self:die()
    end
end

function Player:die()
    self.dead = true
    current_room.gun.dead = true
end