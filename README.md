# Warning: Historical Fork [*&rarr; current version*](https://github.com/ifad/hermes)

This project was implemented during the [2013 Rails Rumble](http://r13.railsrumble.com/entries/385-hermes)
in the thriving setting of [48rails](http://www.48rails.it) by `@amedeo`, `@liquid1982`, `@maisongb` and
`@vjt` (see [contributors](https://github.com/vjt/r13-hermes/graphs/contributors)) in less than 48 hours.

Then, on November 2014, the project development has been funded by [IFAD](https://github.com/ifad) and it
the frontend part has been largely improved by @stecb - another 48rails folk. 

The current version lives on [the IFAD fork](https://github.com/ifad/hermes), while this version is left
here only for historical purposes, as-it-was after the 48-hours hackaton aftermath :smile:

Enjoy! :heart:

Hermes
------

This app allows site owners to insert help elements in their site: tooltips,
banners, tutorials.

It works by requesting the embed of a `.js` file in the site, and then it
establishes a channel through which, for each page load (FIXME) a payload
is requested from the app, that describes the help elements to display in
that specific page.


