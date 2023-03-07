# Creates a directory then changes to it
# The -- prevents that the arg $1 gonna be treated like an option 
# The "" surrounding the arg enshures expansion
function mkcdir() {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

function b() {
  local i=0
  local levels=${1:-1}

  while (( $i < $levels )) && [[ $PWD != $HOME ]]
  do
    cd ..
    ((i++))
  done
}

b2() {
  cd "$(printf '../%.0s' $(seq 1 ${1:-1}))" 2>/dev/null || echo "Error: invalid dir"
}


function prompt() {
  local message="$1"
  local response
  local result

  read -p "$message [y/N] " response

  while true; do
    case "$response" in
      [yY])
        return 0 # For bash this means that execution don't failed
        ;;
      [nN]|"")
        return 1 # Execution failed
        ;;
      *)
        read -p "Please respond with 'y' or 'n' " response
        ;;
    esac
  done
}

function rrm() {
  if [ -z "$1" -o ! -e "$1" ]; then return 0; fi

  local filecount=$(find "$1" -mindepth 1 -type d,f | wc -l)

  local multiple_files_message=$([ $filecount -gt 0 ] && echo " and its $filecount files and directories" || echo "")
  local prompt_message="Warning: This action will permanently delete '$1'$multiple_files_message. Do you wish to proceed?"
  local successful_message="'$1'$multiple_files_message have been permanently deleted."
  local error_message="Error: deletion failed"

  if prompt "$prompt_message"; then
    if rm -rf -- "$1"; then
      echo $successful_message
    else
      echo $error_message
    fi
  fi
}
