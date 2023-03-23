sources=(
  'oh-my-zsh'
  'misc'
  'languages'
  'docker'
  'git'
  'insales'
)

for s in "${sources[@]}"; do
  source $HOME/dotfiles/zshrc/source/${s}.zsh
done
