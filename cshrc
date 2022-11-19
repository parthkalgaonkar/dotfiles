# ====== Colors ======

set red = "%{\033[1;31m%}"
set green = "%{\033[0;32m%}"
set yellow = "%{\033[1;33m%}"
set blue = "%{\033[0;34m%}"
set magenta = "%{\033[1;35m%}"
set cyan = "%{\033[1;36m%}"
set white = "%{\033[0;37m%}"
set end = "%{\033[0m%}"

source /arm/tools/setup/init/tcsh

set prompt = "${green}%n${blue}@%m ${end}%c]$ ${end}"

unset red green yellow blue magenta cyan white end
