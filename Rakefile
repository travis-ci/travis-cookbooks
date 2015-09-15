require 'foodcritic'

task default: [:foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.files = %w(ci_environment worker_host)
  t.options = {
    exclude: %w(./worker_host/opsmatic-cookbook/),
    tags: %w(
      ~FC001
      ~FC002
      ~FC003
      ~FC004
      ~FC005
      ~FC007
      ~FC009
      ~FC015
      ~FC016
      ~FC017
      ~FC019
      ~FC022
      ~FC023
      ~FC024
      ~FC031
      ~FC041
      ~FC043
      ~FC045
      ~FC047
      ~FC048
      ~readme
    ),
  }
end
