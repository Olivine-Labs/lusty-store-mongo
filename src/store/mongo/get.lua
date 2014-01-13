local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local q, m = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local cursor = col:find(q, m.fields)

    if m.sort then
      cursor:sort(m.sort)
    end

    if m.limit then
      if m.limit.offset then
        cursor:skip(m.limit.offset)
      end
      if m.limit.length then
        cursor:limit(m.limit.length)
      end
    end

    return cursor:pairs()
  end
}
