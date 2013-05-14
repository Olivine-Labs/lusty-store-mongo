local util = require 'lusty.util'
local col = util.inline((...)..'.connection', {lusty=lusty, config=config})

return {
  handler = function(context)
    return col:delete(context.query, 0, 1)
  end
}
