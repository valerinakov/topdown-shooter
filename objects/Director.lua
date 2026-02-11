Director = Object:extend()

function Director:new(stage)
    self.stage = stage

    self.round = 1
    self.round_points = 5
end

function Director:update(dt)
    if self.round_points == 0 then
        self.round = 2
        gotoRoom('Shop')
    end
end