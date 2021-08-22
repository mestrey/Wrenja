# Wrenja

<img align="right" width="140" height="120" title="wrenja" src="https://downloader.disk.yandex.ru/preview/a30398426ab73bc6fbba42a11d5e9b064d6678406bf7e858c3fc5d205efc9634/61226dc4/LS0vpQINelzUFT9MTU1T9-IVsL2oQm1Dxji0riWQ1MSaxT-3DusXi5wZnB64EVUViXzZ0BQAcjK_yVatKPWrZg%3D%3D?uid=0&filename=wrenja_logo.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048">
     
Wrenja is a templating engine for Wren with a Jinja / Twig syntax.

It is written completely in wren.

# Install

First, clone this directory.

Then import the `wrenja.wren` file:

```js
import "./path/to/wrenja/wrenja" for Wrenja
```

# How to use it

See the example (`example.wren`) for an overview.

Here is a simple utilization (with variable):

```js
import "./wrenja" for Wrenja

var myTemplate = Wrenja.template("{{title}}")

myTemplate.render({ "title": "Hello World!" })
```

For loops in map (key: value):

```js
import "./wrenja" for Wrenja

var template = Wrenja.template("
Users:
{$ for user in users $}
  - {{ user.name }}, {{ user.age }}
{$ endfor $}
")

template.render({
  "users": [
    {
      "name": "John",
      "age": 20
    },
    {
      "name": "Amanda",
      "age": 26
    }
  ]
})
```

# What is now supported

For the moment, you can use variables `{{ map.variable.name }}`, comments `{# comments are ignored by the compiler #}` and for loops `{$ for i in 0...10 $}`

# Must be implemented

- filters (`{{ title|uppercase }}`)
- if statement (`{$ if true $}{$ elif false $}{$ else $}{$ endif $}`)
- ... and many many more

# Contributing

Go ahead, what are you waiting? 
