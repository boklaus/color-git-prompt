function _color_git_prompt {
  local DEFAULT="\[\e[0;39m\]"
  local RED="\[\e[1;31m\]"
  local GREEN="\[\e[1;32m\]"
  local YELLOW="\[\e[1;33m\]"
  local BLUE="\[\e[1;34m\]"
  local BLINK_WHITE="\[\e[1;5;97m\]"
  local PROMPT=""
  PROMPT=$PROMPT"$BLUE\u$GREEN@\h:$YELLOW\w\n"
  local GIT_STATUS=$(git status 2> /dev/null)

  if [ -n "$GIT_STATUS" ]
  then
    branch=$(git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
    PROMPT=$PROMPT" $DEFAULT("$branch

    # Merging status
    echo $GIT_STATUS | grep "Unmerged paths" > /dev/null 2>&1

    if [ "$?" -eq "0" ]
    then
      PROMPT=$PROMPT$YELLOW"|MERGING"
    fi

    git_status="$(git status 2> /dev/null)"
    git_ahead_number="$(git rev-list --left-only --count ${branch}...origin/${branch} 2> /dev/null)"
    git_behind_number="$(git rev-list --right-only --count ${branch}...origin/${branch} 2> /dev/null)"

    # Red dot for untracked file
    if [[ ${git_status} =~ "Untracked files:" ]];
    then
      PROMPT=$PROMPT" $RED""•"
    fi

    # Green dot for added files
    if [[ ${git_status} =~ "Changes to be committed" ]];
    then
      PROMPT=$PROMPT" $GREEN""•"
    fi

    # Blink for number of commits ahead
    if [[ ${git_ahead_number} != "0" ]]; 
    then
      PROMPT=$PROMPT$BLINK_WHITE" +"$git_ahead_number
    fi

    # Blink for number of commits behind
    if [[ ${git_behind_number} != "0" ]]; 
    then
      PROMPT=$PROMPT$BLINK_WHITE" -"$git_behind_number
    fi

    PROMPT=$PROMPT"$DEFAULT)"
  fi

  # Set back to default color
  PROMPT=$PROMPT"$DEFAULT\$ "

  export PS1=$PROMPT
}

export PROMPT_COMMAND="_color_git_prompt"
