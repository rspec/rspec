function is_ruby_23_plus {
  if ruby -e "exit(RUBY_VERSION.to_f >= 2.3)"; then
    return 0
  else
    return 1
  fi
}

function is_ruby_31_plus {
  if ruby -e "exit(RUBY_VERSION.to_f >= 3.1)"; then
    return 0
  else
    return 1
  fi
}
