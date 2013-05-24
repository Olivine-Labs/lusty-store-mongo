local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local data = nil
    if context.query['_id'] then
      data = col:find_one(context.query)
    else
      data = col:find(context.query)
    end
    col:delete(context.query, 0, 1)
    return data
  end
}
