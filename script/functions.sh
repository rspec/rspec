ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SCRIPT_DIR="${ROOT_DIR}/script"
source $SCRIPT_DIR/predicate_functions.sh

function decide_what_to_run {
  local cmd=$1
  local maybe_library=$2

  if [ $PWD -ef $ROOT_DIR ]; then
    local lib_dir=false

    # if an argument is provided, lets see if it is an rspec lib
    if [ -n "$maybe_library" ]; then
      lib_dir=( $(find . -maxdepth 1 -type d -name "rspec-$maybe_library*") )
    fi;

    if [ -d $lib_dir ]; then
      echo "Running in $lib_dir only..."
      echo

      # if it is an rspec lib run the command in that folder only
      pushd $lib_dir > /dev/null
        $cmd
      popd > /dev/null
    else
      echo "Running in all directories..."
      echo

      # otherwise run it for all folders
      for lib_dir in `ls -d rspec-*`; do
        pushd $lib_dir > /dev/null
          $cmd
        popd > /dev/null
      done
    fi;
  else
    # run command if in folder
    $cmd
  fi;
}
