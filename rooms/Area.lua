Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    local count = self.world:countItems()
    -- print('amount ' .. count)

    -- print('game object' .. #self.game_objects)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then 
            if self.world:hasItem(game_object) then
                self.world:remove(game_object)
            end
            game_object:destroy()
            table.remove(self.game_objects, i) end
        end
end

function Area:draw()
    table.sort(self.game_objects, function(a,b) 
        if a.depth == b.depth then return a.creation_time < b.creation_time
        else return a.depth < b.depth end
    end)
    for _, game_object in ipairs(self.game_objects) do game_object:draw() end

end

function Area:addPhysicsWorld()
    self.world = Bump.newWorld(64)
end

function Area:addCollision(object)
    self.world:add(object, object.x, object.y, object.w or 10, object.h or 10)
end

function Area:move(object,filter)
    
    local actualX, actualY, cols, len = self.world:move(object, object.x,object.y, filter) 

    -- for i=1,len do -- If more than one simultaneous collision, they are sorted out by proximity
    --     local col = cols[i]
    --     print(("Collision with %s."):format(col.other.name))

    --     if object.name == 'Projectile' and col.other.name == "Wall" then
    --         object:die()
    --     end

    -- end

    if actualX ~= object.x then
        object.x = actualX
    end

    if actualY ~= object.y then
        object.y = actualY
    end

    return actualX, actualY, cols, len
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        if self.world:hasItem(game_object) then
            self.world:remove(game_object)
        end
        game_object:destroy()
        table.remove(self.game_objects, i)
    end
    self.game_objects = {}

    if self.world then
        self.world = nil
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    game_object.class = game_object_type
    -- print(game_object.class)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:queryCircleArea(x,y,radius,objects)
    local objectsInCircle = {}
    for _,v in ipairs(objects) do 
        for _,gv in ipairs(self.game_objects) do
            if gv.class == v then
                local r = math.sqrt((gv.x - x) * (gv.x - x) + (gv.y - y) * (gv.y -y))
                if radius >= r then
                    table.insert(objectsInCircle, gv)
                end
            end
        end
    end
    return objectsInCircle
end

function Area:getClosestGameObject(x,y,radius,objects)
    local objectsInCircle = self.queryCircleArea(x,y,radius,objects)
    local closestIndex = 0
    local closestDistance = radius*5
    for i,v in ipairs(objectsInCircle) do
        local r = math.sqrt((v.x - x) * (v.x - x) + (v.y - y) * (v.y -y))
        if r < closestDistance then
            closestDistance = r
            closestIndex = i
        end
    end
    return objectsInCircle[i]
end

function Area:getGameObjects(func)
    local specific_game_objects = {}
    for _,v in pairs(self.game_objects) do
        if func(v) then
            table.insert(specific_game_objects,v)
        end
    end
    return specific_game_objects
end

function Area:getAllGameObjectsThat(filter)
    local out = {}
    for _, game_object in pairs(self.game_objects) do
        if filter(game_object) then
            table.insert(out, game_object)
        end
    end
    return out
end