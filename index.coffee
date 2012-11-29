common = require './common'

module.exports.html = (data) ->

    if Array.isArray data
        if data.length is 0 then ''
        else
            if 'string' is typeof data[0]

                {tag, id, classes} = common.parseTagString data[0]
                out = "<#{tag}"
                hasAttributes = 'object' is typeof data[1] and not Array.isArray data[1]
                attrs = if hasAttributes then data[1] else {}
                attrs.id = id if id? and not attrs.id?
                attrs.class = classes.join(' ') if classes.length isnt 0 and not attrs.class?

                for k, v of attrs
                    if not v?
                        throw new Error "value of attribute `#{k}` in tag #{tag} is undefined or null"
                    out += " #{k}=\"#{common.quoteAttribute v.toString()}\""

                rest = data.slice(if hasAttributes then 2 else 1)

                if common.isVoidTag tag
                    unless rest.length is 0
                        throw new Error "void tag `#{tag}` can't have content"
                    out += " />"
                    return out

                out += ">"

                rest.forEach (content) ->
                    out += module.exports.html content

                out += "</#{tag}>"
                out
            else
                data.map(module.exports.html).join('')
    else
        common.encodeContent data.toString()

module.exports.html5 = (data) -> '<!DOCTYPE html>\n' + module.exports.html data
