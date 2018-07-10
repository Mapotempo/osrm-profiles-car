pprint=require('lib/pprint')

local Mapotempo_classes = {}

local highway_bits = Sequence {
  trunk           = {false, false, false},
  trunk_link      = {false, false, false}, -- same
  primary         = {false, false, true},
  primary_link    = {false, false, true}, -- same
  secondary       = {false, true, false},
  secondary_link  = {false, true, false}, -- same
  tertiary        = {false, true, true},
  tertiary_link   = {false, true, true}, -- same

  unclassified    = {true, false, false},
  residential     = {true, false, false}, -- same
  living_street   = {true, false, true},
  service         = {true, false, true}, -- same
  track           = {true, false, true}, -- same
  -- unassigned        = {true, true, false},
  -- unassigned        = {true, true, true},
}

-- add class information
function Mapotempo_classes.classes(profile,way,result,data)
    local forward_toll, backward_toll = Tags.get_forward_backward_by_key(way, data, "toll")
    local forward_route, backward_route = Tags.get_forward_backward_by_key(way, data, "route")

    if forward_toll == "yes" then
        result.forward_classes["toll"] = true
    end
    if backward_toll == "yes" then
        result.backward_classes["toll"] = true
    end

    if result.forward_restricted then
        result.forward_classes["restricted"] = true
    end
    if result.backward_restricted then
        result.backward_classes["restricted"] = true
    end

    if data.highway == "motorway" or data.highway == "motorway_link" then
        result.forward_classes["motorway"] = true
        result.backward_classes["motorway"] = true
    end

    local w_bits = highway_bits[data.highway]
    if w_bits then
        result.forward_classes["w1"], result.forward_classes["w2"], result.forward_classes["w3"] = unpack(w_bits)
        result.backward_classes["w1"], result.backward_classes["w2"], result.backward_classes["w3"] = unpack(w_bits)
    end
end

return Mapotempo_classes