# Setup fzf
# ---------
if [[ ! "$PATH" == */home/gabriel/.fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/home/gabriel/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/gabriel/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/gabriel/.fzf/shell/key-bindings.bash"


# Kubectl
# ------------

source <(kubectl completion bash )

alias k=kubectl

_FZF_KUBE_HEIGHT=20

_fzf_complete_k_get_namespaced() {
    export K_NAMESPACE_COLUMN=y
    FZF_COMPLETION_TRIGGER='' _fzf_complete --height $_FZF_KUBE_HEIGHT -- "$@" < <(
        kubectl get $1 --all-namespaces
    )
}

_fzf_complete_k_get_namespaced_labels() {
    export K_NAMESPACE_COLUMN=y
    FZF_COMPLETION_TRIGGER='' _fzf_complete --no-sort --height $_FZF_KUBE_HEIGHT -- "$@" < <(
        kubectl get $1 --all-namespaces -o json | \
            jq -r '.items[] | 
            .metadata.namespace as $n | 
            .metadata.labels | 
            keys[] as $k | 
            "\($n) \($k)=\(.[$k])"' | \
            sort | uniq
    )
    export K_NAMESPACE_COLUMN=
}
 

_fzf_complete_k_get_pod_containers() {
    FZF_COMPLETION_TRIGGER='' _fzf_complete --no-sort -- "$@" < <(
        kubectl get pods "$@" -o json | \
            jq -r 'if .items == null then . else .items[] end | .spec.containers[].name' | \
            sort | uniq
    )
}


_fzf_complete_k() {
    local cur prev words
    _get_comp_words_by_ref -n = cur prev words

    local subcommand=${words[1]}

    case $subcommand in
        get|describe)
            case $prev in
                get|describe)
                    FZF_COMPLETION_TRIGGER='' _fzf_complete --height $_FZF_KUBE_HEIGHT -- "$@" < <(
                        kubectl api-resources | awk '{print $1}'
                    )
                    ;;
                -l)
                    _fzf_complete_k_get_namespaced_labels ${words[2]}
                    ;;
                 *)
                    _fzf_complete_k_get_namespaced ${words[2]}
                    ;;
            esac
            ;;
        logs)
            case $prev in
                -l)
                    _fzf_complete_k_get_namespaced_labels pods
                    ;;

                -c)
                    local args=( "${words[@]:2:${#words[@]}-4}" )
                    _fzf_complete_k_get_pod_containers "${args[@]}"
                    ;;
                *)
                    _fzf_complete_k_get_namespaced pods
                    ;;
            esac
            ;;
        exec)
            case $prev in
                -c)
                    local args=( "${words[@]:2:${#words[@]}-4}" )
                    local clean_args=()
                    for elem in "${args[@]}"; do 
                        if [[ $elem != -* ]] || [[ $elem == -n ]]; then
                            clean_args+=($elem);
                        fi
                    done
                    _fzf_complete_k_get_pod_containers "${clean_args[@]}"
                    ;;
                *)
                    _fzf_complete_k_get_namespaced pods
                    ;;
            esac
            ;;

    esac
}

_fzf_complete_k_get_namespaced_post() {
    awk '{printf "%s -n %s", $2, $1}'
}

_fzf_complete_k_get_namespaced_labels_post() {
    _fzf_complete_k_get_namespaced_post
}

complete -F _fzf_complete_k -o default -o bashdefault kubectl k
