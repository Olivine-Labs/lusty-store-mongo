local util        = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local objectId    = require 'resty-mongol.object_id'

return {
  handler = function(context)
    local col   = util.inline(packageName..'.connection', {lusty=lusty, config=config})

    local data  = context.query
    data['_id'] = objectId.new():tostring()
    data.lastModified = os.time()

    return col:insert({data}, 0, 1)
  end
}
