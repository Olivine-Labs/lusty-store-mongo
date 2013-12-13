local util        = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local objectId    = require 'resty-mongol.object_id'
local query       = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local q = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    if not context.data['_id'] then
      context.data['_id'] = q['_id'] or objectId.new():tostring()
    end
    col:delete(q)
    context.data.lastModified = os.time()
    return col:insert({context.data}, 0, 1)
  end
}
