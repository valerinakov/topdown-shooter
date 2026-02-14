Director = Object:extend()

function Director:new(stage)
    self.stage = stage

    self.timer = Timer()
    self.wave = 1
    self.wave_max_points = 5
    self.wave_points = 1

    self.wave_to_points = {}
    self.wave_to_points[1] = 16

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

    self.timer:after(10, function() 
        gotoRoom('Shop')
    end)
end

function Director:update(dt)
    self.timer:update(dt)
    if self.wave_points == 0 then
        self.wave = 2
        gotoRoom('Shop')
        self:setEnemySpawnsForThisRound()
    end
end

function Director:setEnemySpawnsForThisRound()
    local points = self.wave_to_points[self.wave]
    
    local enemy_list = {}
    while points > 0 do
        local enemy = self.enemy_spawn_chances[self.wave]:next()
        points = points - self.enemy_to_points[enemy]
        table.insert(enemy_list,enemy)
    end
end