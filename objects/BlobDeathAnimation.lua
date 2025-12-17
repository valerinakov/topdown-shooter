BlobDeathAnimation = GameObject:extend()

function BlobDeathAnimation:new(area,x,y,opts)
    BlobDeathAnimation.super.new(self,area,x,y,opts)

    self.x = x
    self.y = y

    self.deathFrames = {}

    self.frame_width = 34
    self.frame_height = 15

    for i = 0,6 do 
        table.insert(self.deathFrames,love.graphics.newQuad(i*self.frame_width, 90, self.frame_width,self.frame_height, blobSpriteMap:getWidth(), blobSpriteMap:getHeight()))
    end

    self.currentFrame = 1
end

function BlobDeathAnimation:update(dt)
    BlobDeathAnimation.super.update(self,dt)

    self.currentFrame = self.currentFrame + (10*dt)

    if self.currentFrame >= 7 then
        self.currentFrame = 1
        self:die()
    end
end

function BlobDeathAnimation:draw()
    love.graphics.draw(blobSpriteMap, self.deathFrames[math.floor(self.currentFrame)], self.x, self.y,0,1,1,11,3)
end

function BlobDeathAnimation:die()
    self.dead = true
end