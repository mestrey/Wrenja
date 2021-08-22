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



// var test = Wrenja.template("    
//   <h1>{{ title|uppercase }}</h1>
//   <h1>{{ desc|reverse|slice(2,3,'hehe')|uppercase }}</h1>
//   <ul>
//     {# loop through users #}
//     {$ for user in users $}
//       <li>{{ user.name }}</li>
//     {$ endfor $}
//     {$ for i in 0...1 $}
//       <li>{{ i }}</li>
//     {$ endfor $}    
//   </ul>
// ")
