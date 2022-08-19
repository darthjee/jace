Jace
====
[![Code Climate](https://codeclimate.com/github/darthjee/jace/badges/gpa.svg)](https://codeclimate.com/github/darthjee/jace)
[![Test Coverage](https://codeclimate.com/github/darthjee/jace/badges/coverage.svg)](https://codeclimate.com/github/darthjee/jace/coverage)
[![Issue Count](https://codeclimate.com/github/darthjee/jace/badges/issue_count.svg)](https://codeclimate.com/github/darthjee/jace)
[![Gem Version](https://badge.fury.io/rb/jace.svg)](https://badge.fury.io/rb/jace)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/49845fb44afa4f658460e52cccce84b8)](https://www.codacy.com/manual/darthjee/jace?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=darthjee/jace&amp;utm_campaign=Badge_Grade)
[![Inline docs](http://inch-ci.org/github/darthjee/jace.svg?branch=master)](http://inch-ci.org/github/darthjee/jace)

![jace](https://raw.githubusercontent.com/darthjee/jace/master/jace.jpg)

Yard Documentation
-------------------
[https://www.rubydoc.info/gems/jace/0.1.0](https://www.rubydoc.info/gems/jace/0.1.0)

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

  registry = described_class.new
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
