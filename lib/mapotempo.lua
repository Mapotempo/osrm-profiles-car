local Mapotempo = {}

-- bits called "w" as below
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
function Mapotempo.classes(profile,way,result,data)
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

-- get speed penalities
function Mapotempo.penalties(profile,way,result,data)
  if not profile.classes then
    return
  end

  local width = math.huge
  local lanes = math.huge
  local width_string = way:get_value_by_key("width")
  if width_string and tonumber(width_string:match("%d*")) then
    width = tonumber(width_string:match("%d*"))
  end

  local lanes_string = way:get_value_by_key("lanes")
  if lanes_string and tonumber(lanes_string:match("%d*")) then
    lanes = tonumber(lanes_string:match("%d*"))
  end

  local is_bidirectional = result.forward_mode ~= mode.inaccessible and
                           result.backward_mode ~= mode.inaccessible

  -- decrease speed only some way types (unclassified, residential, living_street)
  if width <= 3 or (lanes <= 1 and is_bidirectional) then
    if (result.forward_classes["w1"] == false and result.forward_classes["w2"] == true and result.forward_classes["w3"] == true) then
      result.forward_speed = result.forward_speed / 2
    end
    if (result.backward_classes["w1"] == false and result.backward_classes["w2"] == true and result.backward_classes["w3"] == true) then
      result.backward_speed = result.backward_speed / 2
    end
  end
end

return Mapotempo