local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local query, data = context.query, context.data
    local meta = getmetatable(data)
    if meta and type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "patch")
    end
    data.lastModified = os.time()
    return col:update(query, data, 0, 1, 1)
  end
}
