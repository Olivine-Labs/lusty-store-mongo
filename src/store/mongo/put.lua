local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local meta = getmetatable(context.data)
    if type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "put")
    end
    col:delete(context.query)
    return col:insert({context.data}, 0, 1)
  end
}
