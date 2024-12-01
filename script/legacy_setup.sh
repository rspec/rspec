set -e

bundle install --standalone --binstubs --without coverage documentation

if [ -x ./bin/rspec ]; then
  echo "RSpec bin detected"
else
  if [ -x rspec-core/exe/rspec ]; then
    cp rspec-core/exe/rspec ./bin/rspec
    echo "RSpec restored from exe"
  else
    echo "No RSpec bin available"
    exit 1
  fi
fi
