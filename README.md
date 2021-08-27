# Wrenja

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

(see the dev branch for upcoming features)

Go ahead, what are you waiting? 
