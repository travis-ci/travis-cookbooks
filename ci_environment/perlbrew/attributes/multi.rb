default[:perlbrew] = {
  :perls   => [{ :name => "5.21", :version => "perl-5.21.0" },
               { :name => "5.20", :version => "perl-5.20.0"  },
               { :name => "5.20-extras", :version => "perl-5.20.0", :arguments => "-Duseshrplib -Duseithreads", :alias => '5.20-shrplib'},
               { :name => "5.18", :version => "perl-5.18.2" },
               { :name => "5.18-extras", :version => "perl-5.18.2", :arguments => "-Duseshrplib -Duseithreads", :alias => '5.18-shrplib' },
               { :name => "5.16", :version => "perl-5.16.3" },
               { :name => "5.14", :version => "perl-5.14.4" },
               { :name => "5.12", :version => "perl-5.12.5" },
               { :name => "5.10", :version => "perl-5.10.1" },
               { :name => "5.8",  :version => "perl-5.8.9"  }],
  :modules => %w(ExtUtils::MakeMaker Dist::Zilla Moose Test::Pod Test::Pod::Coverage Test::Exception Dist::Zilla::Plugin::Bootstrap::lib LWP Module::Install Test::Most)
}
