Dealing with RVM
Derived from https://github.com/jamesotron/cookbooks/tree/master/rvm

How To Use:

Note that the attribute specifing the version comes in those 3 parts.

run_list (
          'recipe[rvm::install]'
          )

override_attributes( 
  :rvm => { :ruby => { :implementation => "ree",
                       :version => "1.8.7",
                       :patch_level => "2011.03" } }
)

