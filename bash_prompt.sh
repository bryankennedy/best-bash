#!/usr/bin/env bash
# Sexy bash prompt by twolfson
# https://github.com/twolfson/sexy-bash-prompt
# Forked from gf3, https://gist.github.com/gf3/306785

# Customizations by bryankennedy

prompt_reset="\033[m"
prompt_time_color="\033[1;31m" # RED
prompt_user_color="\033[1;35m" # PURPLE
prompt_preposition_color="\033[1;37m" # WHITE
prompt_device_color="\033[1;33m" # YELLOW
prompt_dir_color="\033[1;34m" # BLUE
prompt_git_status_color="\033[1;31m" # RED
prompt_git_progress_color="\033[1;33m" # YELLOW
prompt_symbol_color="" # NORMAL

# Apply any color overrides that have been set in the environment
if [[ -n "$PROMPT_TIME_COLOR" ]]; then prompt_time_color="$PROMPT_TIME_COLOR"; fi
if [[ -n "$PROMPT_USER_COLOR" ]]; then prompt_user_color="$PROMPT_USER_COLOR"; fi
if [[ -n "$PROMPT_PREPOSITION_COLOR" ]]; then prompt_preposition_color="$PROMPT_PREPOSITION_COLOR"; fi
if [[ -n "$PROMPT_DEVICE_COLOR" ]]; then prompt_device_color="$PROMPT_DEVICE_COLOR"; fi
if [[ -n "$PROMPT_DIR_COLOR" ]]; then prompt_dir_color="$PROMPT_DIR_COLOR"; fi
if [[ -n "$PROMPT_GIT_STATUS_COLOR" ]]; then prompt_git_status_color="$PROMPT_GIT_STATUS_COLOR"; fi
if [[ -n "$PROMPT_GIT_PROGRESS_COLOR" ]]; then prompt_git_progress_color="$PROMPT_GIT_PROGRESS_COLOR"; fi
if [[ -n "$PROMPT_SYMBOL_COLOR" ]]; then prompt_symbol_color="$PROMPT_SYMBOL_COLOR"; fi

function get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ "$ref" != "" ]]; then
    echo "$ref"
  else
    echo "(no branch)"
  fi
}

function get_git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  git_dir="$(git rev-parse --git-dir)"

  # git merge
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo " [merge]"
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    # git am
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo " [am]"
    # git rebase
    else
      echo " [rebase]"
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    # git rebase --interactive/--merge
    echo " [rebase]"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    # git cherry-pick
    echo " [cherry-pick]"
  fi
  if [[ -f "$git_dir/BISECT_LOG" ]]; then
    # git bisect
    echo " [bisect]"
  fi
  if [[ -f "$git_dir/REVERT_HEAD" ]]; then
    # git revert --no-commit
    echo " [revert]"
  fi
}

is_branch1_behind_branch2 () {
  # $ git log origin/master..master -1
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # Find the first log (if any) that is in branch1 but not branch2
  first_log="$(git log $1..$2 -1 2> /dev/null)"

  # Exit with 0 if there is a first log, 1 if there is not
  [[ -n "$first_log" ]]
}

branch_exists () {
  # List remote branches           | # Find our branch and exit with 0 or 1 if found/not found
  git branch --remote 2> /dev/null | grep --quiet "$1"
}

parse_git_ahead () {
  # Grab the local and remote branch
  branch="$(get_git_branch)"
  remote_branch="origin/$branch"

  # $ git log origin/master..master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the remote branch is behind the local branch
  # or it has not been merged into origin (remote branch doesn't exist)
  if (is_branch1_behind_branch2 "$remote_branch" "$branch" ||
      ! branch_exists "$remote_branch"); then
    # echo our character
    echo 1
  fi
}

parse_git_behind () {
  # Grab the branch
  branch="$(get_git_branch)"
  remote_branch="origin/$branch"

  # $ git log master..origin/master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the local branch is behind the remote branch
  if is_branch1_behind_branch2 "$branch" "$remote_branch"; then
    # echo our character
    echo 1
  fi
}

function parse_git_dirty() {
  # If the git status has *any* changes (e.g. dirty), echo our character
  if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
    echo 1
  fi
}

function is_on_git() {
  git rev-parse 2> /dev/null
}

function get_git_status() {
  # Grab the git dirty and git behind
  dirty_branch="$(parse_git_dirty)"
  branch_ahead="$(parse_git_ahead)"
  branch_behind="$(parse_git_behind)"

  # Iterate through all the cases and if it matches, then echo
  if [[ "$dirty_branch" == 1 && "$branch_ahead" == 1 && "$branch_behind" == 1 ]]; then
    echo "⬢"
  elif [[ "$dirty_branch" == 1 && "$branch_ahead" == 1 ]]; then
    echo "▲"
  elif [[ "$dirty_branch" == 1 && "$branch_behind" == 1 ]]; then
    echo "▼"
  elif [[ "$branch_ahead" == 1 && "$branch_behind" == 1 ]]; then
    echo "⬡"
  elif [[ "$branch_ahead" == 1 ]]; then
    echo "△"
  elif [[ "$branch_behind" == 1 ]]; then
    echo "▽"
  elif [[ "$dirty_branch" == 1 ]]; then
    echo "*"
  fi
}

get_git_info () {
  # Grab the branch
  branch="$(get_git_branch)"

  # If there are any branches
  if [[ "$branch" != "" ]]; then
    # Echo the branch
    output="$branch "

    # Add on the git status
    output="$output$(get_git_status)"

    # Echo our output
    echo "$output"
  fi
}

# Symbol displayed at the line of every prompt
function get_prompt_symbol() {
  # If we are root, display `#`. Otherwise, `$`
  if [[ "$UID" == 0 ]]; then
    echo "#"
  else
    echo "\$"
  fi
}

# Define the sexy-bash-prompt
PS1="\n\
\[$prompt_time_color\]\t\[$prompt_reset\] \
\[$prompt_user_color\]\u\[$prompt_reset\]\
\[$prompt_preposition_color\]@\[$prompt_reset\]\
\[$prompt_device_color\]\h\[$prompt_reset\]\
\[$prompt_preposition_color\]\[$prompt_reset\] \
\$( is_on_git && \
  echo -n \"\[$prompt_preposition_color\]\[$prompt_reset\]\" && \
  echo -n \"\[$prompt_git_status_color\]\$(get_git_info)\"&& \
  echo -n \"\[$prompt_git_progress_color\]\$(get_git_progress)\" && \
  echo -n \"\[$prompt_preposition_color\]\") \[$prompt_reset\]\
\[$prompt_dir_color\]\w\[$prompt_reset\]\
\[$prompt_preposition_color\]\n\[$prompt_reset\]\
\[$prompt_symbol_color\]$(get_prompt_symbol) \[$prompt_reset\]"

