import "./wrenja" for Wrenja

var template1 = Wrenja.template("

# {{title}}
## {{subtitle}}

{#This is a comment#}

List: {$ for i in 0...5 $}
  - {{ i }}
{$ endfor $}

Maps: {$ for user in users $}
  - {{ user.name }}, {{ user.age }}
{$ endfor $}

")

System.print("Template 1:")
System.print(template1.render({
  "title": "Wrenja", 
  "subtitle": "A templating engine",
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
}))

System.print("\nTemplate 2:")
var template2 = Wrenja.template("

{$ for i in 0...10 $}
  {$ if i \% 3 == 0 && i \% 5 == 0 $}
    {{ i }} FizzBuzz
  {$ elif i \% 3 == 0 $}
    {{ i }} Fizz
  {$ elif i \% 5 == 0 $}
    {{ i|toString }} Buzz
  {$ else $}
    {#{{ i|toString }}#}
    Num
  {$ endif $}
{$ endfor $}

")

System.print(template2.render(null))
