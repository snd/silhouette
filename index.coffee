common = require './common'

module.exports.html = (data) ->

    if Array.isArray data
        if data.length is 0 then ''
        else
            if 'string' is typeof data[0]

                # it's a tag

                string = data[0]

                tag = common.parseTag string
                unless tag?
                    throw new Error "no tag found in  tagstring `#{string}`"

                hasAttributes = 'object' is typeof data[1] and (not Array.isArray data[1]) and (not common.isComponent data[1])

                out = "<#{tag}"

                attrs = if hasAttributes then data[1] else {}

                if tag.length isnt string.length
                    if not attrs.id?
                        id = common.parseId string
                        attrs.id = id if id?
                    if not attrs.class?
                        clazz = common.parseClass string
                        attrs.class = clazz if clazz?

                for k, v of attrs
                    unless v?
                        throw new Error "value of attribute `#{k}` in tag #{tag} is undefined or null"
                    out += " #{k}=\"#{v.toString().replace /"/g, '&quot;'}\""
                out

                leaderLength = if hasAttributes then 2 else 1

                if common.isVoidTag tag
                    unless data.length is leaderLength
                        throw new Error "void tag `#{tag}` can't have content"
                    out += " />"
                    return out

                out += ">"

                i = leaderLength
                while i < data.length
                    out += module.exports.html data[i++]

                out += "</#{tag}>"
                out
            else
                data.map(module.exports.html).join('')
    else if common.isComponent data
        module.exports.html data.render()
    else unless data?
        throw new Error 'missing data'
    else
        common.encodeContent data.toString()

module.exports.html5 = (data) -> '<!DOCTYPE html>\n' + module.exports.html data
