contentEncodings =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
    '\'': '&#x27;'
    '/': '&#x2F;'

contentRegex = /[&<>"'\/]/g
contentEncoder = (char) -> contentEncodings[char]

# performance optimization: looking up a key in an object is much faster
# than searching for existence in an array.

voidTag =
    area: true
    base: true
    br: true
    col: true
    command: true
    embed: true
    hr: true
    img: true
    input: true
    keygen: true
    link: true
    met: true
    param: true
    source: true
    track: true
    wbr: true
    frame: true

module.exports =
    parseTagString: (string) ->

        mode = 'tag'
        acc = ''
        tag = ''
        id = ''
        classes = []

        error = (msg) ->
            throw new Error "#{msg} (when parsing tag string '#{string}')"

        throw new Error 'empty tag string' if string is ''

        for i in [0...string.length]
            char = string[i]
            switch mode
                when 'tag'
                    switch char
                        when '#'
                            error 'tag name required before id' if acc is ''
                            tag = acc
                            acc = ''
                            mode = 'id'
                        when '.'
                            error 'tag name required before class' if acc is ''
                            tag = acc
                            acc = ''
                            mode = 'class'
                        else acc += char
                when 'id'
                    switch char
                        when '#' then error 'only one id is allowed'
                        when '.'
                            throw error 'empty id' if acc is ''
                            id = acc
                            acc = ''
                            mode = 'class'
                        else acc += char
                when 'class'
                    switch char
                        when '#'
                            throw error 'id must appear before classes'
                        when '.'
                            throw error 'empty class' if acc is ''
                            classes.push acc
                            acc = ''
                        else acc += char

        switch mode
            when 'tag'
                throw error 'empty tag' if acc is ''
                tag = acc
            when 'id'
                throw error 'empty id' if acc is ''
                id = acc
            when 'class'
                throw error 'empty class' if acc is ''
                classes.push acc

        returns = {tag: tag, classes: classes}
        returns.id = id if id isnt ''
        return returns

    encodeContent: (s) -> s.toString().replace contentRegex, contentEncoder

    quoteAttribute: (s) -> s.replace /"/g, '&quot;'

    isVoidTag: (tag) -> voidTag[tag]?
