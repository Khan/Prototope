# adding documentation

here's the idea: each method gets its own markdown file, these live `_methods/<class/stuct slug>/<method slug>.md`

suppose you have a method for color that's like `public func interpolate(a: Color, b: Color) -> [Color]`

you would save it in `_methods/color/interpolate.md` and you would seed it with the following jekyll frontmatter

    ---
    slug: interpolate
    title: "public func interpolate(a: Color, b: Color) -> [Color]"
    doctype:
        - method
    ---

    some documentation for how to use this method and what it probably does

then, you would go into `_data/api_docs.yml` and you would add the `slug` field (in our case *interpolate*), to the color section, it would probably look like this

    - title: Color
      docs:
      - init_rgba
      - init_hex
      - init_hsb
      - init_white
      - interpolate  # this is what we just added
      - vars

some notes:

* the `slug` parameter in the frontmatter does not have to be unique globally, only unique within the color files. to help maintain this, you should name the file `<slug>.md`
* the `doctype` is a list of classes that gets appended to the whole piece of documentation. The idea is to make it easier to filter methods, variables, typealiases, etc at some point.

*future planning note: if doing docs for multiple languages (i.e. swift + js), our best bet may be to add a parallel title element, i.e. `js_title` alongside the regular title (which would be implicitly a swift title) and also a separate `js_types` array and, having a `swift_notes`, `js_notes`, etc parameter that could be multi-line. This way we can keep the docs together for each function, but keep the data distinct?*

## class variables

variables work mostly the same way, except their markdown files don't usually contain content: everything is hosted in the frontmatter. here's a sample

    ---
    slug: vars
    layout: variables
    doctype:
        - variable
    title: "Contentious variables"  # .title is optional
    variables:
      -
        name: "public private(set) var favoriteColor: Color!"
        desc: |
            this could possibly be my favoritest color... ever

            or not, who knows
        type:
            - variable
            - private
      -
        name: "public var leastFavoriteColor: Color?"
        desc: "a color i am not partial to, i am easily swayed."
      -
        name: "public func stareAtSun() -> RetinalDamage?"
        desc: "do we dare find out what happens"
        type:
            - method
            - optional
    ---

    any text in the content, here, prepends the block of variables. contextualizing them, if you will.

some notes on this:

* the `title` parameter in the frontmatter is *optional*, if you don't include it, it defaults to "variables"
* the `desc` parameter here is shown in multiline and single line form. both get markodwnified.
* the `type` param here overrides the doctype (which is variable) (the `stareAtSun` method will not even be tagged as a variable, instead it will be tagged with `method` and `optional`)
* you'll notice some `convenience_methods` versions of this file, they are basically for methods which also are mostly self-explanatory setters/getters or for overloaded operators that operate on special prototope structs/classes. the idea is basically the same, though.

## Top Level Documents

for documenting classes, structs, etc, you need to create a document in `_docs/`

here is what the frontmatter looks like for that

    ---
    layout: api_doc
    slug: colorama
    title: Coloama
    doctype: struct
    ---
    a veritable kaleidoscope!

In an ideal world, this document is more detailed than all the other method docs (which should provide, on their own, tantalizing use cases and examples for each method). This document though should proved the story of the class/struct/meta whatever so that it's clear why it warrants a spot in the top level.

### perf

there's probably a reason why generating a page takes five seconds, but i don't know better jekyll fu than this.

hugs!
