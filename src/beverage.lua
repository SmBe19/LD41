--
-- Beverages
--

local beverage = {}

function beverage.new(name_, vol_, alc_)
    local b = {
        name = name_,
        alc = alc_,
        vol = vol_,
    }

    function b:newPromille(old)
        return (6000 * old + self.vol * self.alc) / (6000 + self.vol)
    end

    function b:update(dt)
    end

    function b:draw()
    end

    return b
end

return beverage
