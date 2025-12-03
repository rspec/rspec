function is_mri {
  if ruby -e "exit(RUBY_ENGINE == 'ruby')"; then
    # RUBY_ENGINE only returns 'ruby' on MRI.
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

function is_ruby_32_plus {
  if ruby -e "exit(RUBY_VERSION.to_f >= 3.2)"; then
    return 0
  else
    return 1
  fi
}

function is_ruby_4_plus {
  if ruby -e "exit(RUBY_VERSION.to_f >= 4)"; then
    return 0
  else
    return 1
  fi
}
