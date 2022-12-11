sources=(
  'oh-my-zsh'
  'aliases'
  'other'
  'languages'
  'docker'
  'git'
  'insales'
)

for s in "${sources[@]}"; do
  source $HOME/dotfiles/zshrc/source/${s}.zsh
done
