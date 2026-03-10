# Source prompt init
if [ -f ~/.bash_prompt ]; then
	source ~/.bash_prompt
fi

#######################################################
# EXPORTS
#######################################################

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that 
# start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, 
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it 
# so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Check if the shell is interactive
if [[ $- == *i* ]]; then
    # Bind Ctrl+f to insert 'zi' followed by a newline
    bind '"\C-f":"zi\n"'
fi

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'


# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi


#######################################################
# ALIAS
#######################################################

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias plz='sudo $(fc -ln -1)'
alias now='date "+%Y-%m-%d %a %T %Z"'

# Search the corresponding bat command installed on the system.
if command -v bat &> /dev/null; then
    BAT=bat
elif command -v batcat &> /dev/null; then
    BAT=batcat
fi

# Replace the cat command with the bat command to brighten up the terminal a little 🤗
if [ -n "$BAT" ]; then
    cat() { "$BAT" --style=-numbers "$@"; }
    man() { 
        command man "$@" | "$BAT" -l man --style=-numbers
        return ${PIPESTATUS[0]}
    }
fi

# Change directory aliases
alias home='cd ~'        
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose'

# Alias's for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias ft="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"


#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
for archive in "$@"; do
    if [ -f "$archive" ]; then
        case $archive in
        *.tar.bz2) tar xvjf $archive ;;
        *.tar.gz) tar xvzf $archive ;;
        *.bz2) bunzip2 $archive ;;
        *.rar) rar x $archive ;;
        *.gz) gunzip $archive ;;
        *.tar) tar xvf $archive ;;
        *.tbz2) tar xvjf $archive ;;
        *.tgz) tar xvzf $archive ;;
        *.zip) unzip $archive ;;
        *.Z) uncompress $archive ;;
        *.7z) 7z x $archive ;;
        *) echo "don't know how to extract '$archive'..." ;;
        esac
    else
        echo "'$archive' is not a valid file!"
    fi
done
}

# Searches for text in all files in the current folder
ftext() {
# -i case-insensitive
# -I ignore binary files
# -H causes filename to be printed
# -r recursive search
# -n causes line number to be printed
# optional: -F treat search term as a literal, not a regular expression
# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "$1" "$2" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "$1")" count=0
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
    local d=""
    limit=$1
    for ((i = 1; i <= limit; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Automatically do an ls after each cd, z, or zoxide
cd() {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls --color=auto
    else
        builtin cd ~ && ls --color=auto
    fi
}

# IP address lookup
wip() {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -4 ifconfig.me
    echo -n ""
}


#######################################################
# DEV FUNCTIONS
#######################################################

_run_in_project() {
    _has_project_file() {
        local dir="$1"
        for marker in package.json Cargo.toml pyproject.toml setup.py go.mod; do
            [ -f "$dir/$marker" ] && return 0
        done
        return 1
    }

    _find_project_root() {
        local dir="$PWD"
        while [ "$dir" != "/" ]; do
            _has_project_file "$dir" && echo "$dir" && return 0
            dir="$(dirname "$dir")"
        done
        return 1
    }

    local cmd_name="$1"
    local dir
    dir="$(_find_project_root)" || { echo "No projects recognized in the tree structure"; return 1; }

    (cd "$dir" && {
        if [ -f package.json ]; then
            case "$cmd_name" in
                lint) npm run lint ;;
                test) npm test ;;
            esac
        elif [ -f Cargo.toml ]; then
            case "$cmd_name" in
                lint) cargo clippy ;;
                test) cargo test ;;
            esac
        elif [ -f pyproject.toml ] || [ -f setup.py ]; then
            case "$cmd_name" in
                lint) ruff check . 2>/dev/null || flake8 . ;;
                test) pytest ;;
            esac
        elif [ -f go.mod ]; then
            case "$cmd_name" in
                lint) golangci-lint run ;;
                test) go test ./... ;;
            esac
        fi
    })

    unset -f _has_project_file _find_project_root
}

alias dev="npm run watch"
lint() { _run_in_project lint; }
test() { _run_in_project test; }

# Git
alias push="lint && test && git push -f"
alias clean="git branch | egrep -v '(^\\*|main|master|develop)' | xargs git branch -d"
alias gprunesquashmerged='git checkout -q develop && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base develop $branch) && [[ $(git cherry develop $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

rebase-on() {
  git checkout "$1" && git pull -r && git checkout - && git rebase "$1"
}

git-clean-merged() {
  BASE=${1:-main}

  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    case "$branch" in
      main|master|develop) continue ;;
      "$BASE") continue ;;
    esac

    # Calculating the branch patch ID
    branch_patch=$(git log "$BASE..$branch" --pretty=format:%H | \
      xargs -r git show | git patch-id --stable | cut -d' ' -f1)

    # If no commit -> already merged
    if [ -z "$branch_patch" ]; then
      echo "Deletion (fast-forward): $branch"
      git branch -d "$branch"
      continue
    fi

    # Check whether the patch already exists in BASE
    base_patches=$(git log "$BASE" | \
      git patch-id --stable | cut -d' ' -f1)

    if echo "$base_patches" | grep -q "$branch_patch"; then
      echo "Deletion (squash): $branch"
      git branch -d "$branch"
    fi
  done
}

git-clean-old() {
  MONTHS=${1:-3}

  LIMIT=$(date -d "$MONTHS months ago" +%s)

  for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
    case "$branch" in
      main|master|develop) continue ;;
    esac

    last_commit=$(git log -1 --format=%ct "$branch")

    if [ "$last_commit" -lt "$LIMIT" ]; then
      echo "Deletion: $branch"
      git branch -D "$branch"
    fi
  done
}