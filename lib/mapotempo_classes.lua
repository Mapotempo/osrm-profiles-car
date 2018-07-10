pprint=require('lib/pprint')
Urban_density = require('lib/urban_density')

local Mapotempo_classes = {}

local highway_bits = Sequence {
  trunk           = {true, true, true},
  trunk_link      = {true, true, true}, -- same
  primary         = {true, true, false},
  primary_link    = {true, true, false}, -- same
  secondary       = {true, false, true},
  secondary_link  = {true, false, true}, -- same
  tertiary        = {true, false, false},
  tertiary_link   = {true, false, false}, -- same

  unclassified    = {false, true, true},
  residential     = {false, true, true}, -- same
  living_street   = {false, true, false},
  service         = {false, true, false}, -- same
  track           = {false, true, false}, -- same
  -- unassigned        = {false, false, true},
  -- unassignable      = {false, false, false},
}

local landuse_bits = {
    {false, false}, -- 1, interurban
    {false, true}, -- 2, water_body
    {true, false}, -- 3, urban
    {true, true}, -- 4, urban_dense
}

-- add class information
function Mapotempo_classes.classes(profile,way,result,data)
    local forward_toll, backward_toll = Tags.get_forward_backward_by_key(way, data, "toll")

    if forward_toll == "yes" then
        result.forward_classes["toll"] = true
    end
    if backward_toll == "yes" then
        result.backward_classes["toll"] = true
    end

--    if result.forward_restricted then
--        result.forward_classes["restricted"] = true
--    end
--    if result.backward_restricted then
--        result.backward_classes["restricted"] = true
--    end

    if data.highway == "motorway" or data.highway == "motorway_link" then
        result.forward_classes["motorway"] = true
        result.backward_classes["motorway"] = true
    end

    if data.highway == "track" then
        result.forward_classes["track"] = true
        result.backward_classes["track"] = true
    end

    local w_bits = highway_bits[data.highway]
    if w_bits then
        result.forward_classes["w1"], result.forward_classes["w2"], result.forward_classes["w3"] = unpack(w_bits)
        result.backward_classes["w1"], result.backward_classes["w2"], result.backward_classes["w3"] = unpack(w_bits)
    end

    -- FIXME duplicate call to speed_coef ----------------------------------------------------------------------------
    local coef = Urban_density.speed_coef(way)
    local max_index = 1
    for k in pairs(coef) do
        if coef[k] > coef[max_index] then
            max_index = k
        end
    end

    result.forward_classes["l1"], result.forward_classes["l2"] = unpack(landuse_bits[max_index])
    result.backward_classes["l1"], result.backward_classes["l2"] = unpack(landuse_bits[max_index])
end

return Mapotempo_classes
