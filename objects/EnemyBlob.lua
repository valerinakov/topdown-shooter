EnemyBlob = GameObject:extend();

function EnemyBlob:new(area,x,y,opts)
    EnemyBlob.super.new(self,area,x,y,opts)

    self.name = "EnemyBlob"
    self.x,self.y = x,y
    self.w,self.h = 10,10

    self.hp = 20

    self.animationState = "Moving"

    self.blobMovingFrames = {}
    self.blobHurtFrames = {}

    self.frame_width = 34
    self.frame_height = 15

    for i=0,6 do
        table.insert(self.blobMovingFrames, love.graphics.newQuad(i*self.frame_width, 15, self.frame_width, self.frame_height, blobSpriteMap:getWidth(), blobSpriteMap:getHeight()))
    end

    for i=0,2 do
        table.insert(self.blobHurtFrames, love.graphics.newQuad(i*self.frame_width, 75, self.frame_width, self.frame_height, blobSpriteMap:getWidth(), blobSpriteMap:getHeight()))
    end

    self.hurtSource = love.audio.newSource('/resources/audio/enemyhurt.wav', 'static')
    self.hurtSound = Ripple.newSound(self.hurtSource, {volume = .5})

    self.currentFrame = 1
    self.maxFrames = 7
    self.angle = 0
    self.r = 0
end

function EnemyBlob:update(dt)
    EnemyBlob.super.update(self,dt)
    self.angle = math.atan2(current_room.player.y - self.y ,current_room.player.x - self.x)
    if(self.animationState == "Moving") then
        self.maxFrames = 7
    elseif(self.animationState == "Hurt") then
        self.maxFrames = 3
    end

    self.y = self.y + (math.sin(self.angle)/2)
    self.x = self.x + (math.cos(self.angle)/2)

    self.currentFrame = self.currentFrame + (10 * dt)


    
    if self.currentFrame >= self.maxFrames and self.animationState == "Hurt" then
        self.currentFrame = 1
        self.animationState = "Moving"
    end
    
    if self.currentFrame >= self.maxFrames  and self.animationState == "Moving" then
        self.currentFrame = 1
    end

end

function EnemyBlob:draw()

    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0, 100))
    love.graphics.ellipse('fill', self.x + 5,self.y + 9, self.w/2, self.h/4)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))

    -- love.graphics.setColor(love.math.colorFromBytes(255, 255, 0))
    -- love.graphics.rectangle('fill', self.x,self.y,self.w,self.w)
    if self.animationState == 'Moving' then
        love.graphics.draw(blobSpriteMap, self.blobMovingFrames[math.floor(self.currentFrame)], self.x, self.y,0,1,1,11,3)
    end

    if self.animationState == 'Hurt' then
        love.graphics.draw(blobSpriteMap, self.blobHurtFrames[math.floor(self.currentFrame)], self.x, self.y,0,1,1,11,3)
    end
end

function EnemyBlob:damage(damage)
    self.animationState = "Hurt"
    self.currentFrame = 2
    self.hp = self.hp - damage

    local moveSound = self.hurtSound:play()

    self.x = self.x - (math.cos(self.angle)*3)
    self.y = self.y - (math.sin(self.angle)*3)

    if(self.hp <= 0) then
        wave_points = wave_points - 1
        self:die()
    end
end

function EnemyBlob:die()
    self.animationState = "Dead"
    self.area:addGameObject('BlobDeathAnimation', self.x,self.y)
    self.dead = true
end
