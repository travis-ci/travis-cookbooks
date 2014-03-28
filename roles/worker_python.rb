name "worker_python"
description "Travis Python Worker"
run_list(
  # Missing travis user setup
  # Missing git setup
  "recipe[python::pyenv]",
  "recipe[python::system]",
  "recipe[python::devshm]",
  "recipe[sweeper]"
)