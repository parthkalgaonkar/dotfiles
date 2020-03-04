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

module load arm/cluster
module load swdev
module load util
module load eda
module load git/git/2.18.0
module load openoffice/openoffice/4.1.2
module load util gnu/tmux/3.0
module load util vim/vim/8.2

alias run_cmd "bsub -q inter -Is -P PJ1100055 -R 'rhe7&&os64' -R 'rusage[mem=8192]' -Jd top_val-PD-sim_vcs -W '5000' -app FG"
setenv LSB_DEFAULTPROJECT PJ1100055 # PJ02774
alias slot_status "bshares -q PD | grep -i PJ1100055"
alias bs "bsub -q inter -Is -P PJ1100055 -R 'rhe7&&os64' -R 'rusage[mem=49152]' -Jd top_val-PD-sim_vcd -W '5000'"
setenv project_dir "/projects/pd/pj1100055_olympus/users/parkal01"
setenv scratch_dir "/arm/projectscratch/pd/pj1100055_olympus/users/parkal01"
setenv validation_home "/arm/projectscratch/pd/pj1100055_olympus/users/parkal01/validation_src"
