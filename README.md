# contour (draft)

contour generates html from an array representation

[![Build Status](https://travis-ci.org/snd/contour.png)](https://travis-ci.org/snd/contour)

### install

```
npm install contour
```

### require

```coffeescript
{html, html5} = require 'contour'
```

### use

```coffeescript
html5 ['html',
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
```

returns

```html
<!DOCTYPE html>
<html>
<head>
<title>a title</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
</head>
<body>
<div id="container">
<h1>a heading</h1>
<h2 class="secondary-heading">another heading</h2>
<ul>
<li>
<a>first</a>
</li>
<li>
<a>second</a>
</li>
<li>
<a>third</a>
</li>
</ul>
<p>Before the break<br />
After the break</p>
</div>
</body>
</html>
```

`html5` prepends `<!DOCTYPE html>\n` to the output of `html`

### forms

##### tag

```coffeescript
html ['p']
```

returns

```html
<p></p>
```

##### void tag

```coffeescript
html ['input']
```

returns

```html
<input />
```

`area`, `base`, `br`, `col`, `command`, `embed`, `hr`, `img`, `input`, `keygen`, `link`, `meta`, `param`, `source`, `track`, `wbr` and `frame`
are void tags. they have no content and no closing tag.

##### tag with id and classes

tag with id and classes

```coffeescript
html ['p#my-id.my-class-1.my-class-2']
```

returns

```html
<p id="my-id", class="my-class-1 my-class-2"></p>
```

##### tag with attributes

```coffeescript
html ['form', {method: 'post', action: '/submit'}]
```

returns

```html
<form method="post" action="/submit"></form>
```

the `class` and `id` attributes overwrite classes and id parsed from the tag string.

##### tag with inner text

```coffeescript
html ['p', 'lorem ipsum']
```

returns

```html
<p>lorem ipsum</p>
```

##### tag with inner html and inner text

```coffeescript
html
    ['p',
        'lorem ipsum ',
        ['span',
            'dolor sit ',
            ['b', 'amet']]]
```

returns

```html
<p>lorem ipsum <span>dolor sit <b>amet</b></span></p>
```

##### unsafe strings

```coffeescript
html ['p', ['$unsafe', 'djfsklfjdslk']] # => '<p id="my-id", class="my-class-1 my-class-2"></p>'
```

##### script tags with function arguments

```coffeescript
html ['script', -> alert("hello world")]
```

returns

```html
<script>function(){alert("hello world");}()</script>
```

##### components

contour handles objects specially when they have a `render` property which is a function.
it will call the `render` function and use the generated markup in place of the component.

```coffeescript
html ['div', {render: -> ['p', 'a text inside a component']}]
```

returns

```html
<div><p>a text inside a component</p>/<div>
```


when contour encounters a list of components the output is concatenated.

```coffeescript
beget = require 'beget'

script =
    render: -> ['script', {@src}]

html ['html',
    ['head', [
        beget(script, {src: '/lskjlkd.js'})
        beget(script, {src: '/lskjlkd.js'})
        beget(script, {src: '/lskjlkd.js'})]]
    ['body']]
# => '<div><p data-component-id="1">a text inside a component</p>/<div>
```

### xss prevention

contour will [html escape content](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.231_-_html_escape_before_inserting_untrusted_data_into_html_element_content).

- [escape attributes](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.232_-_attribute_escape_before_inserting_untrusted_data_into_html_common_attributes)
    - Kup properly quotes all attributes with double quotes
    - properly quoted attributes can only be escaped with the corresponding quote
    - Kup escapes all double quotes inside attributes to prevent escaping

### why i think contour is better than kup

contour is much cleaner than kup. it is purely functional.
`html` and `html5` have no side effects.
contour has easier syntax for classes and ids.
with contour there is no weird `k` object to pass around.

with contour we can handle html as data, which can be transformed.

contour really composes. you can drop a fragment 

this isn't possible with kup

performance.

##### advantages

- seamlessly interleave components and markup

- components using kup would produce html directly

- less typing

- data which is passed to a function for processing

- nicer component composition

- transform the syntax tree

- the renderer could add an attribute `data-component-id` to each and every component

as i am writing a lot of clojure at the moment i don't mind the syntax
but i can see how someone could have a problem with it.
i think after trying it for a while it will soon be as natural as writing kup code.

### license: MIT
