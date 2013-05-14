local util = require 'lusty.util'
local col = util.inline((...)..'.connection', {lusty=lusty, config=config})

return {
  handler = function(context)
    local query, data = context.query, context.data
    return col:find(query, data)
  end
}
