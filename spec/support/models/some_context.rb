# frozen_string_literal: true

class SomeContext
  def do_something(instant)
    puts "doing something #{instant}"
  end

  def text
    @text ||= []
  end

  def puts(string)
    text << string
  end
end
