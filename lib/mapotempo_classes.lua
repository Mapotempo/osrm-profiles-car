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

-- add class information
function Mapotempo_classes.classes(profile,way,result,data)
    if not profile.classes then
        return
    end

    local allowed_classes = Set {}
    for k, v in pairs(profile.classes) do
        allowed_classes[v] = true
    end

    if allowed_classes["track"] and data.highway == "track" then
        result.forward_classes["track"] = true
        result.backward_classes["track"] = true
    end

    if allowed_classes["w1"] and allowed_classes["w2"] and allowed_classes["w3"] then
        local w_bits = highway_bits[data.highway]
        if w_bits then
            result.forward_classes["w1"], result.forward_classes["w2"], result.forward_classes["w3"] = unpack(w_bits)
            result.backward_classes["w1"], result.backward_classes["w2"], result.backward_classes["w3"] = unpack(w_bits)
        end
    end
end

return Mapotempo_classes
