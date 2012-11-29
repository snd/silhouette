# silhouette (beta)

silhouette generates html from an array representation

[![Build Status](https://travis-ci.org/snd/silhouette.png)](https://travis-ci.org/snd/silhouette)

### install

```
npm install silhouette
```

### require

```coffeescript
{html, html5} = require 'silhouette'
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
are void tags. they have no closing tag and can't have content.

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

the `class` and `id` attributes overwrite classes and ids parsed from the tag string.

##### content

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

silhouette handles objects specially when they have a `render` property that is a function.
it will call the `render` function and use the generated markup in place of the component.

```coffeescript
html ['div', {render: -> ['p', 'a text inside a component']}]
```

returns

```html
<div><p>a text inside a component</p>/<div>
```


when silhouette encounters a list of components the output is concatenated.

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


##### loops



##### conditionals

silhouette is very forgiving in the way
it treats contento

it will just flatten everything out, ignore null values and concatenate the outputs



### xss prevention

silhouette will [html escape content](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.231_-_html_escape_before_inserting_untrusted_data_into_html_element_content).

- [escape attributes](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.232_-_attribute_escape_before_inserting_untrusted_data_into_html_common_attributes)
    - Kup properly quotes all attributes with double quotes
    - properly quoted attributes can only be escaped with the corresponding quote
    - Kup escapes all double quotes inside attributes to prevent escaping

### why i think silhouette is better than kup

silhouette is much cleaner than kup. it is purely functional.
`html` and `html5` have no side effects.
silhouette has easier syntax for classes and ids.
with silhouette there is no weird `k` object to pass around.

with silhouette we handle html as data (nested arrays), which can be traversed and transformed.
this is impossible with kup since we can't look inside functions.


silhouette really composes. you can drop a fragment 

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

##### performance

performance should be the least of our concerns.

the expensive part are string operations

### license: MIT
