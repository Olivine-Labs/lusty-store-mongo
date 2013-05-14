local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local results = {}
    local cursor = col:find(context.query, {_id=1, lastModified=1})
    for index, result in cursor:pairs() do
      table.insert(results, result)
    end
    return results
  end
}
