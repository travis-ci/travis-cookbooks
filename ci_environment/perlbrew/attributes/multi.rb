default[:perlbrew] = {
  :perls   => [{ :name => "5.19",          :version => "perl-5.19.0"                               },
               { :name => "5.19-ithreads", :version => "perl-5.19.0", :arguments => '-Dusethreads' },
               { :name => "5.18",          :version => "perl-5.18.0"                               },
               { :name => "5.18-ithreads", :version => "perl-5.18.0", :arguments => '-Dusethreads' },
               { :name => "5.17",          :version => "perl-5.17.7"                               },
               { :name => "5.17-ithreads", :version => "perl-5.17.7", :arguments => '-Dusethreads' },
               { :name => "5.16",          :version => "perl-5.16.3"                               },
               { :name => "5.16-ithreads", :version => "perl-5.16.3", :arguments => '-Dusethreads' },
               { :name => "5.14",          :version => "perl-5.14.4"                               },
               { :name => "5.14-ithreads", :version => "perl-5.14.4", :arguments => '-Dusethreads' },
               { :name => "5.12",          :version => "perl-5.12.5"                               },
               { :name => "5.12-ithreads", :version => "perl-5.12.5", :arguments => '-Dusethreads' },
               { :name => "5.10",          :version => "perl-5.10.1"                               },
               { :name => "5.10-ithreads", :version => "perl-5.10.1", :arguments => '-Dusethreads' },
               { :name => "5.8",           :version => "perl-5.8.9"                                },
               { :name => "5.8-ithreads",  :version => "perl-5.8.9",  :arguments => '-Dusethreads' }],
  :modules => %w(Dist::Zilla Moose Test::Pod Test::Pod::Coverage Test::Exception Test::Kwalitee Dist::Zilla::Plugin::Bootstrap::lib LWP Module::Install Test::Most)
}
