alias vim='nvim'
alias python='python3'

alias dc='docker compose'

alias ..='cd ..'
alias ...='cd ../..'

alias connect-langgraph="docker exec -it -u vscode -w /workspaces/langgraph-example-monorepo/ $(docker ps --filter=label=devcontainer_for=langgraph_prototyping --format={{.Names}}) /bin/bash"

alias ghcps='gh copilot suggest'
