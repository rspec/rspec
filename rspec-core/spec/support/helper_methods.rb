module RSpecHelpers
  SAFE_LEVEL_THAT_TRIGGERS_SECURITY_ERRORS = 1

  def relative_path(path)
    RSpec::Core::Metadata.relative_path(path)
  end

  def ignoring_warnings
    original = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original
    result
  end

  # Intended for use with indented heredocs.
  # taken from Ruby Tapas:
  # https://rubytapas.dpdcart.com/subscriber/post?id=616#files
  def unindent(s)
    s.gsub(/^#{s.scan(/^[ \t]+(?=\S)/).min}/, "")
  end

  if RUBY_VERSION.to_f > 3.3
    def quoted(string)
      "'#{string}'"
    end
  else
    def quoted(string)
      "`#{string}'"
    end
  end
end
