GameObject = Object:extend()

function GameObject:new(area,x,y,opts)
    local opts = opts or {}
    if opts then for k,v in pairs(opts) do self[k] = v end end
    self.area = area
    self.x, self.y = x, y
    self.depth = 50
    self.id = UUID()
    self.dead = false
    self.timer = Timer()
    self.creation_time = os.time()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()
end

function GameObject:destroy()
    self.timer:destroy()
end
