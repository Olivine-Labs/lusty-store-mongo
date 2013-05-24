local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local object_id = require 'resty-mongol.object_id'

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    if not context.data['_id'] then
      context.data['_id'] = object_id.new():tostring()
    end
    local meta = getmetatable(context.data)
    if meta and type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "put")
    end
    col:delete(context.query)
    context.data.lastModified = os.time()
    return col:insert({context.data}, 0, 1)
  end
}
