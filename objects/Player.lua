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
        self.animationState = 'MovingLeft' 
        self.x = self.x - 1    
    end

    if input:down('right') then
        self.animationState = 'MovingRight'
        self.x = self.x + 1
    end

    if input:down('up') then
        self.y = self.y - 1
    end

    if input:down('down') then
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
        self.projectile = self.area:addGameObject('Projectile', (self.x + (self.w/2)) + (25* math.cos(angle)), (self.y + (self.h/2)) + (25*math.sin(angle)), {r = angle})
        self.area:addCollision(self.projectile)
        -- print('angle ', angle)
        -- print('mx', mx)
        -- print('my', my)
        print('x', self.x)
        print('y', self.y)
    end
end

function Player:draw()
    if self.animationState == 'Idle' then
        love.graphics.draw(gunslingerSpriteMap, self.gunslingerIdleFrames[math.floor(self.currentFrame)], self.x - 18, self.y - 20)
    end

    if self.animationState == 'MovingRight' then
        love.graphics.draw(gunslingerSpriteMap, self.gunslingerMovingFrames[math.floor(self.currentFrame)], self.x - 18, self.y - 20)
    end

    if self.animationState == 'MovingLeft' then
        love.graphics.draw(gunslingerSpriteMap, self.gunslingerMovingFrames[math.floor(self.currentFrame)], self.x -18, self.y - 20, 0, -1, 1, 48)
    end

    -- love.graphics.rectangle("fill", self.x + 18, self.y + 20 ,self.w, self.h)
end