#
# Cookbook Name:: travis_build_environment
# Recipe:: windows
# Copyright 2011-2014, Travis CI Development Team <contact@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


log "The Windows worker is still experimental... most things don't work"
include_recipe "chocolatey"

# TODO: Move from this quick & dirty recipe to separate (ideally community maintained) cookbooks.

# Compilers

# Microsoft Visual Studio Express

  chocolatey "VisualStudio2013ExpressWeb" do
  end

# Go

  # TODO: Needs 64-bit fix: cinst golang

# PowerShell: Assume the version in the VM image is recent enough
# OpenSSL

  chocolatey "OpenSSL.Light" do
  end

# PhantonJS: Already in common recipe

# ImageMagick
  # TODO: imagemagick::devel or imagemagick::rmagick on Windows?
  chocolatey "imagemagick" do
  end

# Runtimes

# Ruby

  # Note: Using Ruby 1.9 because DevKit isn't available in Chocolatey for Ruby 2

  chocolatey "ruby" do
    version "1.9.3.48400"
  end

  chocolatey "ruby.devkit" do
  end

# Java

  # Note: Oracle, not OpenJDK
  # Note: java.jdk didn't work

  chocolatey "jdk8" do
  end

# Python

  # Note: There is a PR to add Windows support to the python cookbook,
  # see https://github.com/poise/python/pull/76

  # Note: I didn't have any luck with virtualenvwrapper-powershell

  chocolatey "python" do
    # version '3.4.0.20140321'
  end

# Node.js

  # Note: Use nodejs.install, nodejs doesn't include npm

  chocolatey "nodejs.install" do
  end

# Go - Installed as part of compilers section