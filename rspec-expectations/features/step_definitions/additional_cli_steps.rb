# Useful for when the output is slightly different on different versions of ruby
Then(/^the output should contain "([^"]*)" or "([^"]*)"$/) do |string1, string2|
  unless [string1, string2].any? { |s| all_output.include?(s) }
    fail %(Neither "#{string1}" or "#{string2}" were found in:\n#{all_output})
  end
end

Then(/^the output should contain all of these:$/) do |table|
  table.raw.flatten.each do |string|
    if RUBY_VERSION == '1.8.7' && string =~ /\{.+=>.+\}/
      warn "Skipping checking #{string} on 1.8.7 because hash ordering is not consistent"
    elsif RUBY_VERSION.to_f > 3.3
      expect(all_output).to include_output_string string.gsub('undefined method `', "undefined method '")
    else
      expect(all_output).to include_output_string string
    end
  end
end

Then(/^the example(?:s)? should(?: all)? pass$/) do
  step 'the output should contain "0 failures"'
  step 'the exit status should be 0'
end

Then(/^the example should fail$/) do
  step 'the output should contain "1 failure"'
  step 'the exit status should not be 0'
end

Then(/^the output should contain, ignoring hash syntax, "(.*)"$/) do |output|
  if RUBY_VERSION.to_f > 3.3
    expect(all_output).to include(output.gsub(/:(\w+)=>/, '\1: '))
  else
    expect(all_output).to include(output)
  end
end

RSpec::Matchers.define :match_table do |lines|
  match do |all_output|
    lines.all? { |line| all_output.include?(line) }
  end

  diffable
end

Then "the output should contain all of these, ignoring hash syntax:" do |table|
  lines = table.raw.flatten.reject(&:empty?)

  if RUBY_VERSION.to_f > 3.3
    lines = lines.map { |line| line.gsub(/:(\w+)\s+=>\s+/, '\1: ') }
  end

  expect(all_output).to match_table(lines)
end
