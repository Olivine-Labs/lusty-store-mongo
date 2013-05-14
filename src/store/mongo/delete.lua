local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    return col:delete(context.query, 0, 1)
  end
}
