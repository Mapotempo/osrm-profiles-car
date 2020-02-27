WayHandlers = require("lib/way_handlers")

Tags = require('lib/tags')

local Ferries_withlist = {}

local ferries_withlist_ids = {}

-- Load white list of ferries
function Ferries_withlist.load(file)
  local file = assert(io.open(debug.getinfo(1).source:sub(2):match("(.*/)") .. "../" .. file))
  if file then
    for line in file:lines() do
      if tonumber(line) then
        ferries_withlist_ids[tonumber(line)] = true
      end
    end
  end
end

function Ferries_withlist.ferries_withlist(profile,way,result,data)
  if data.route == 'ferry' then
    if ferries_withlist_ids[way:id()] then
      WayHandlers.ferries(profile,way,result,data)
    else
      return false
    end
  end
end

return Ferries_withlist
