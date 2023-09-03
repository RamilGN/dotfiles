sources=(
  'oh-my-zsh'
  'misc'
  'languages'
  'docker'
  'git'
  'curl'
  'insales'
  'secrets'
  'keymaps'
)

for s in "${sources[@]}"; do
  source $HOME/dotfiles/zshrc/source/${s}.zsh
done
