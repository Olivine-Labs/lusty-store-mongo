local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local object_id = require 'resty-mongol.object_id'

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local data = context.query
    data['_id'] = object_id.new()
    local meta = getmetatable(data)
    if type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "post")
    end
    return col:insert({data}, 0, 1)
  end
}
