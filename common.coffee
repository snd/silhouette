contentEncodings =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
    '\'': '&#x27;'
    '/': '&#x2F;'

contentRegex = /[&<>"'\/]/g
contentEncoder = (char) -> contentEncodings[char]

module.exports =
    parseTag: (string) -> /^\w+/.exec(string)?[0]
    parseId: (string) -> /#([\w\-]+)/.exec(string)?[1]
    parseClass: (string) ->
        regex = /\.([\w\-]+)/g

        match = regex.exec string

        return null unless match?

        classes = []

        while match?
            classes.push match[1]
            match = regex.exec string
        classes.join ' '

    encodeContent: (s) -> s.toString().replace contentRegex, contentEncoder

    isVoidTag: (tag) ->
        /area|base|br|col|command|embed|hr|img|input|keygen|link|meta|param|source|track|wbr|frame/.test tag

    isComponent: (x) ->
        ('object' is typeof x) and x.render? and ('function' is typeof x.render)
