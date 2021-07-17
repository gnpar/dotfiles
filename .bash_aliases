alias config='/usr/bin/git --git-dir=/home/gabriel/.dotfiles/ --work-tree=/home/gabriel'
alias gcc89="gcc -Wall -ansi -pedantic"

alias :q=exit  # Not sure whether to be proud or ashamed ¬‿¬

repo() {
    [ -n "$1" ] && [ -d ~/repo/"$1" ] && cd ~/repo/"$1" && return
    [ -z "$1" ] && cd ~/src && return
    echo "No existe ~/repo/$1" >&2
    return 1
}
complete -W "$(ls ~/repo)" repo


workspace() {
    [ -n "$1" ] && [ -d ~/workspace/"$1" ] && cd ~/workspace/"$1" && return
    echo "No existe ~/workspace/$1" >&2
    return 1
}
alias ws=workspace
complete -W "$(ls ~/workspace)" workspace
complete -W "$(ls ~/workspace)" ws

## Invoke autocomplete (automatically generated by invoke)
_complete_invoke() {
    local candidates
    candidates=`invoke --complete -- ${COMP_WORDS[*]}`
    COMPREPLY=( $(compgen -W "${candidates}" -- $2) )
}
complete -F _complete_invoke -o default invoke inv
