local util = require 'lusty.util'
local col = util.inline((...)..'.connection', {lusty=lusty, config=config})

return {
  handler = function(context)
    local query = context.query
    return col:find(query, {lastModified:1})
  end
}
