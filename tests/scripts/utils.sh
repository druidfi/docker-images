title () {
   echo -e "\e[96m# $1\e[39;49m"
}

info () {
   echo -e "\e[33m$1\e[39;49m"
}

error () {
   echo -e "\e[41m$1\e[39;49m" && exit 1
}
