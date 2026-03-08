Jace
====
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/darthjee/jace/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/darthjee/jace/tree/main)
[![Gem Version](https://badge.fury.io/rb/jace.svg)](https://badge.fury.io/rb/jace)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/49845fb44afa4f658460e52cccce84b8)](https://app.codacy.com/gh/darthjee/jace/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![Codacy Badge](https://app.codacy.com/project/badge/Coverage/49845fb44afa4f658460e52cccce84b8)](https://app.codacy.com/gh/darthjee/jace/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_coverage)
[![Inline docs](http://inch-ci.org/github/darthjee/jace.svg?branch=master)](http://inch-ci.org/github/darthjee/jace)

![jace](https://raw.githubusercontent.com/darthjee/jace/master/jace.jpg)

Yard Documentation
-------------------
[https://www.rubydoc.info/gems/jace/0.1.1](https://www.rubydoc.info/gems/jace/0.1.1)

Jace is designed to have a semi event driven development

Using `Jace::Registry`, event handlers can be registered to events, and when an event
is triggered, the block that triggers it is given to Jace, which will triger, around it,
the +before+ and +after+ handlers

Installation
---------------

- Install it

```bash
  gem install jace
```

- Or add Sinclair to your `Gemfile` and `bundle install`:

```bash
  gem 'jace'
```

```bash
  bundle install jace
```

Using
-----

Initialize a registry, register event handlers nad trigger events

```ruby
  class SomeContext
    def do_something(instant)
      puts "doing something #{instant}"
    end
  end

  registry = Jace::Registry.new
  context = SomeContext.new

  registry.register(:the_event) { do_something(:after) }
  registry.register(:the_event, :before) { do_something(:before) }

  registry.trigger(:the_event, context) do
   context.do_something(:middle)
  end

  # puts 'doing something before',
  # puts 'doing something middle',
  # puts 'doing something after'
```
