EnemyBlob = GameObject:extend();

function EnemyBlob:new(area,x,y,opts)
    Player.super.new(self,area,x,y,opts)

    self.name = "EnemyBlob"
    self.x,self.y = x,y
    self.w,self.h = 12,12

    self.animationState = "Moving"

    self.blobMovingFrames = {}

    self.frame_width = 32
    self.frame_height = 15

    for i=0,6 do
        table.insert(self.blobMovingFrames, love.graphics.newQuad(i*self.frame.width, 15, self.frame_width, self.frame_height, blobSpriteMap:getWidth(), blobSpriteMap:getHeight()))
    end
end

function EnemyBlob:update(dt)
    Player.super.update(self,dt)
end

function EnemyBlob:draw()
    if self.animationState == 'Moving' then
        love.graphics.draw(blobSpriteMap, self.gunslingerMovingFrames[math.floor(self.currentFrame)], self.x, self.y)
    end
end