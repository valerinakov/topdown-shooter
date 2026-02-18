Director = Object:extend()

function Director:new(stage)
    self.stage = stage

    self.timer = Timer()

    self.wave_to_points = {}
    self.wave_to_points[1] = 1

    self.spawn_time = 5

    for i = 2, 1024, 4 do
        self.wave_to_points[i] = self.wave_to_points[i-1] + 8
        self.wave_to_points[i+1] = self.wave_to_points[i]
        self.wave_to_points[i+2] = math.floor(self.wave_to_points[i+1]/1.5)
        self.wave_to_points[i+3] = math.floor(self.wave_to_points[i+2]*2)
    end

    self.enemy_to_points = {
        ['EnemyBlob'] = 1
    }

    self.enemy_spawn_chances = {
        [1] = chanceList({'EnemyBlob', 1}),

    }

    for i = 2, 1024 do
        self.enemy_spawn_chances[i] = chanceList(
            {'EnemyBlob', 1}
        )
    end

    wave_points = self.wave_to_points[wave]

    self:setEnemySpawnsForThisRound()
end

function Director:update(dt)
    self.timer:update(dt)
    if wave_points == 0 then
        wave = wave + 1
        -- self.timer:after(3, function () 
        gotoRoom('Shop')
        -- end)

    end
end

function Director:setEnemySpawnsForThisRound()
    local points = self.wave_to_points[wave]
    
    local enemy_list = {}
    while points > 0 do
        local enemy = self.enemy_spawn_chances[wave]:next()
        points = points - self.enemy_to_points[enemy]
        table.insert(enemy_list,enemy)
    end

    local enemy_spawn_times = {}
    for i = 1, #enemy_list do
        enemy_spawn_times[i] = random(0,self.spawn_time)
    end

    table.sort(enemy_spawn_times, function(a,b) return a < b end)

    for i = 1, #enemy_spawn_times do
        self.timer:after(enemy_spawn_times[i], function() 
        self.enemyX = 0
        self.enemyY = 0
        self.ang = random(0,6.28)
        
        if math.sin(self.ang) > 0 then
            if self.stage.player.y > 80 then
                self.enemyY = (self.stage.player.y) - math.sin(self.ang)*(30)
            else
                self.enemyY = (self.stage.player.y) - math.sin(-1*self.ang)*(30)
            end
        else
            if gh - self.stage.player.y > 80 then
                self.enemyY = (self.stage.player.y) - math.sin(self.ang)*(50)
            else
                self.enemyY = (self.stage.player.y) - math.sin(-1*self.ang)*(50)
            end
        end

        if math.cos(self.ang) > 0 then
            if gw - self.stage.player.x > 80 then
                self.enemyX = (self.stage.player.x) + math.cos(self.ang) *(50)
            else
                self.enemyX = (self.stage.player.x) + math.cos(3.14 - self.ang) * (50)
            end
        else
            if self.stage.player.x > 80 then
                self.enemyX = (self.stage.player.x) + math.cos(self.ang) *(50)
            else
                self.enemyX = (self.stage.player.x) + math.cos(3.14 - self.ang) * (50)
            end
        end

        self.enemyToBeSpawned = self.stage.area:addGameObject('EnemyBlob', self.enemyX, self.enemyY)
        self.stage.area:addCollision(self.enemyToBeSpawned)
    end)

    end
end