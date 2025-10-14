ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SCRIPT_DIR="${ROOT_DIR}/script"
source $SCRIPT_DIR/predicate_functions.sh

function decide_what_to_run {
  if [ "$#" -lt 1 ]; then
    echo "Missing cmd"
    exit 1
  fi

  local cmd=$1
  local maybe_library=$2
  local lib_dir=false
  local args=""

  # if a second argument is provided, lets see if it is an rspec lib
  if [ -n "$maybe_library" ]; then
    maybe_result=( $(find . -maxdepth 1 -type d -name "rspec-$maybe_library*") )

    if [[ ! -z $maybe_result ]]; then
      lib_dir=$maybe_result
    fi
  fi;

  # if more arguments are provided then they are to be passed through
  if [ "$#" -gt 2 ]; then
    shift 2
    args=$@
  fi

  # if the second argument isn't a directory and is provided then shift it back onto args
  if [ ! -d $lib_dir ] && $lib_dir; then
    args="${lib_dir} ${args}"
  fi;

  if [ $PWD -ef $ROOT_DIR ]; then
    if [ -d $lib_dir ]; then
      echo "Running in $lib_dir only..."
      echo

      # if it is an rspec lib run the command in that folder only
      pushd $lib_dir > /dev/null
        $cmd $args
      popd > /dev/null
    else
      echo "Running in all directories..."
      echo

      # otherwise run it for all folders
      for repo_dir in `ls -d rspec-*`; do
        pushd $repo_dir > /dev/null
          $cmd $args
        popd > /dev/null
      done
    fi;
  else
    # run command if in folder
    $cmd $args
  fi;
}
