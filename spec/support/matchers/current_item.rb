# Check if the menu has a specific current item
RSpec::Matchers.define :have_current_item do |item = nil|
  match do |menu|
    @current_item = menu.current_item

    if item.nil?
      !@current_item.nil?
    else
      @current_item == item
    end
  end

  description do
    "have a current item"
  end

  failure_message do
    if item.nil?
      <<~EOL
        expected a current item, but no current item was found
      EOL
    else
      <<~EOL
        expected: #{item.url}
          actual: #{actual}
      EOL
    end
  end

  failure_message_when_negated do
    if item.nil?
      <<~EOL
        expected: no current item
          actual: #{actual}
      EOL
    else
      <<~EOL
        expected: url != #{item.url}
          actual: #{actual}
      EOL
    end
  end

  def actual
    if @current_item.nil?
      "nil"
    else
      @current_item.url
    end
  end
end
