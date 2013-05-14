local util = require 'lusty.util'
local col = util.inline((...)..'.connection', {lusty=lusty, config=config})

return {
  handler = function(context)
    local data = context.query
    local meta = getmetatable(data)
    if type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "post")
    end
    return col:insert({data}, 0, 1)
  end
}
