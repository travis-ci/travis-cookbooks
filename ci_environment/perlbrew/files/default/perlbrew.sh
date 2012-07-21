#!/bin/sh

[[ -s "$HOME/perl5/perlbrew/etc/bashrc" ]] && . "$HOME/perl5/perlbrew/etc/bashrc"

# cpan.mirrors.travis-ci.org is link-local to travis-ci.org worker machines, hosted in southern Germany.
# We add one German and one Austrian mirror for better availability. MK.
export PERL_CPANM_OPT="--mirror http://cpan.mirrors.travis-ci.org --mirror http://gd.tuwien.ac.at/languages/perl/CPAN/ --mirror http://ftp-stud.hs-esslingen.de/pub/Mirrors/CPAN/"
