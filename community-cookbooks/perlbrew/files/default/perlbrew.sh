#!/bin/sh

[[ -s "$HOME/perl5/perlbrew/etc/bashrc" ]] && . "$HOME/perl5/perlbrew/etc/bashrc"

# cpan.mirrors.travis-ci.org is link-local to travis-ci.org worker machines.
# We add a few more mirrors for better availability. MK.
# remove the mirrors for now as VMs are now based in the US
# export PERL_CPANM_OPT="--mirror http://cpan.mirrors.travis-ci.org --mirror http://gd.tuwien.ac.at/languages/perl/CPAN/ --mirror http://ftp-stud.hs-esslingen.de/pub/Mirrors/CPAN/ --mirror http://cpan.cpantesters.org/ --mirror http://search.cpan.org/CPAN --cascade-search --skip-satisfied"
