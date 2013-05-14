local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local results = {}
    local cursor = col:find(context.query, context.data)
    for index, result in cursor:pairs() do
      table.insert(results, result)
    end
    return results
  end
}
