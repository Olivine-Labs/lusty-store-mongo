local util = require 'lusty.util'
local col = util.inline((...)..'.connection', {lusty=lusty, config=config})

return {
  handler = function(context)
    local query, data = context.query, context.data
    local meta = getmetatable(data)
    if type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "patch")
    end
    return col:update(query, data, 0, 1, 1)
  end
}
