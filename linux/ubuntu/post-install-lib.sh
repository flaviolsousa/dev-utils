NC='\033[0m'

REGULAR='\033[0;'
BOLD='\033[1;'
UNDERLINE='\033[4;'

BLACK='30m'
RED='31m'
GREEN='32m'
YELLOW='33m'
BLUE='34m'
PURPLE='35m's
CYAN='36m'
WHITE='37m'

function p_h1()
  {
    COLOR_CMD="${BOLD}${GREEN}"
    echo -e "${COLOR_CMD}\n\n >>> $1 ${NC}\n"
  }
function p_h2()
  {
    COLOR_CMD="${REGULAR}${YELLOW}"
    echo -e "${COLOR_CMD}\n\n >>> $1 ${NC}\n"
  }
function p_prop()
  {
    COLOR_CMD="${BOLD}${WHITE}"
    echo -e "${COLOR_CMD}$1=${NC}$2"
  }
function p_error()
  {
    COLOR_CMD="${BOLD}${RED}"
    echo -e "${COLOR_CMD}$1${NC}"
  }
function p_br()
  {
    echo -e ""
  }
