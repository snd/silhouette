# silhouette (draft)

**i'm not maintaining this package anymore**

[![Build Status](https://travis-ci.org/snd/silhouette.png)](https://travis-ci.org/snd/silhouette)

silhouette generates html from an array representation

### require

```coffeescript
{html, html5} = require 'silhouette'
```

### use

```coffeescript
html5
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

silhouette generates html from tag forms.
a tag form is defined as an array consisting of a name string, an optional attributes object and
a variable number of content elements.

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

```coffeescript
html ['p#my-id.my-class-1.my-class-2']
```

returns

```html
<p id="my-id" class="my-class-1 my-class-2"></p>
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

##### tag with text content

```coffeescript
html ['p', 'lorem ipsum']
```

returns

```html
<p>lorem ipsum</p>
```

##### tag with mixed html and text content

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

##### components

a component is defined as an object which has a `render` property that is a function.
when silhouette encounters a component
it will call the `render` function of the component and use its return value in place of the component.

```coffeescript
html ['div', {render: -> ['p', 'text inside a component']}]
```

returns

```html
<div><p>text inside a component</p><div>
```

##### loops and conditionals

silhouette will just loop over any array that is not a tag form and concatenate the output.

```coffeescript
html ['div', ['first', 'second', 'third'].map((x) -> ['p', x])]
```

returns

```html
<div><p>first</p><p>second</p><p>third</p><div>
```

the empty array acts as the identity. use it for conditional markup.

```coffeescript
renderSpan = false
html ['div', (if renderSpan then ['span'] else [])]
```

returns

```html
<div></div>
```

### xss prevention

silhouette will [html escape text content](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.231_-_html_escape_before_inserting_untrusted_data_into_html_element_content).

silhouette will [properly quote attributes using double quotes](https://www.owasp.org/index.php/xss_%28cross_site_scripting%29_prevention_cheat_sheet#rule_.232_-_attribute_escape_before_inserting_untrusted_data_into_html_common_attributes).
properly quoted attributes can only be escaped with the corresponding quote.
silhouette escapes all double quotes inside attributes values to prevent escaping.

### license: MIT
