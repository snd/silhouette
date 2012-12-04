{html} = require './index'
{parseTagString} = common = require './common'

module.exports =

    'isComponent':

        'object with render function is a component': (test) ->
            test.ok common.isComponent {render: ->}
            test.done()
        'empty object is not a component': (test) ->
            test.ok not common.isComponent {}
            test.done()
        'string is not a component': (test) ->
            test.ok not common.isComponent 'foo'
            test.done()

    'parseTag':

        'empty': (test) ->
            test.ok not common.parseTag ''
            test.done()

        'invalid tag': (test) ->
            test.ok not common.parseTag '$h1'
            test.done()

        'valid tag': (test) ->
            test.equal 'h1', common.parseTag 'h1'
            test.done()

        'tag with suffix': (test) ->
            test.equal 'h1', common.parseTag 'h1#heading.awesome.super'
            test.done()

    'parseId':

        'empty': (test) ->
            test.ok not common.parseId ''
            test.done()

        'pure id': (test) ->
            test.equal 'heading', common.parseId '#heading'
            test.done()

        'id in tagstring': (test) ->
            test.equal 'heading', common.parseId 'h1#heading.awesome.super'
            test.done()

    'parseClass':

        'empty': (test) ->
            test.ok not common.parseClass ''
            test.done()

        'one class': (test) ->
            test.equal 'awesome', common.parseClass '.awesome'
            test.done()

        'three classes': (test) ->
            test.equal 'awesome super cool', common.parseClass '.awesome.super.cool'
            test.done()

        'three classes in tagstring': (test) ->
            test.equal 'awesome super cool', common.parseClass 'h1.awesome.super#heading.cool'
            test.done()

    'html':

        'throw when':

            'attribute value is undefined': (test) ->
                test.throws -> html ['div', {foo: undefined}]
                test.done()

            'void tag has content': (test) ->
                test.throws -> html ['input', 'lorem ipsum']
                test.throws -> html ['input', ['span']]
                test.done()

        'empty array': (test) ->
            data = []
            test.equal html(data), ''
            test.done()

        'string is encoded': (test) ->
            data = '<script>alert("foo"); alert(\'bar\');</script>'
            test.equal html(data), "&lt;script&gt;alert(&quot;foo&quot;); alert(&#x27;bar&#x27;);&lt;&#x2F;script&gt;"
            test.done()

        'void tag':

            'without attributes': (test) ->
                data = ['input']
                test.equal html(data), '<input />'
                test.done()

            'with attributes': (test) ->
                data = ['input', {type: 'text', name: 'data'}]
                test.equal html(data), '<input type="text" name="data" />'
                test.done()

            'with classes and ids in tag string': (test) ->
                data = ['input#my-id.my-class-1.my-class-2']
                test.equal html(data), '<input id="my-id" class="my-class-1 my-class-2" />'
                test.done()

            'attributes override classes and ids in tag string': (test) ->
                data = ['input#my-id.my-class', {class: 'my-real-class', id: 'my-real-id'}]
                test.equal html(data), '<input class="my-real-class" id="my-real-id" />'
                test.done()

            'attributes are encoded': (test) ->
                data = ['img', {id: '" onclick=\'alert("foo")\''}]
                test.equal html(data), '<img id="&quot; onclick=\'alert(&quot;foo&quot;)\'" />'
                test.done()

        'regular tag':

            'empty':

                'without attributes': (test) ->
                    data = ['div']
                    test.equal html(data), '<div></div>'
                    test.done()

                'with attributes': (test) ->
                    data = ['div', {'data-toggle': 'tag', style: 'margin: 10px'}]
                    test.equal html(data), '<div data-toggle="tag" style="margin: 10px"></div>'
                    test.done()

            'text content':

                'without attributes': (test) ->

                    data = ['a', 'my text content']
                    test.equal html(data), '<a>my text content</a>'
                    test.done()

                'with attributes': (test) ->

                    data = ['a', {href: '/', class: 'my-class'}, 'my text content']
                    test.equal html(data), '<a href="/" class="my-class">my text content</a>'
                    test.done()

            'html content':

                'without attributes': (test) ->

                    data = ['p',
                        ['a', 'first link']
                        ['p', ['a', 'second link']]]
                    test.equal html(data), '<p><a>first link</a><p><a>second link</a></p></p>'
                    test.done()

                'with attributes': (test) ->

                    data = ['p', {id: 'container'},
                        ['a', 'first link']
                        ['p', ['a', 'second link']]]
                    test.equal html(data), '<p id="container"><a>first link</a><p><a>second link</a></p></p>'
                    test.done()

        'everything together': (test) ->
            data =
                ['html',
                    ['head',
                        ['title', 'a title']
                        ['script', {
                            src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'
                            type: 'text/javascript'}]]
                    ['body',
                        ['div#container',
                            ['h1', 'a heading']
                            ['h2.secondary-heading', 'another heading']
                            ['ul', 'first second third'.split(' ').map((x) -> ['li', ['a', x]])]
                            ['p', 'Before the break', ['br'], 'After the break']]]]
            expected ='<html><head><title>a title</title><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script></head><body><div id="container"><h1>a heading</h1><h2 class="secondary-heading">another heading</h2><ul><li><a>first</a></li><li><a>second</a></li><li><a>third</a></li></ul><p>Before the break<br />After the break</p></div></body></html>'
            test.equal html(data), expected
            test.done()
