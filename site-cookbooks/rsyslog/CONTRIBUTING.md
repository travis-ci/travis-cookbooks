# Contributing to Chef Cookbooks

We are glad you want to contribute to Chef Cookbooks! The first
step is the desire to improve the project. If you're new to the Chef
community, please read
[How to become a contributor](https://supermarket.getchef.com/become-a-contributor)
on the Supermarket website for more information.

## Quick-contribute

* Create an account on the [Supermarket](http://supermarket.getchef.com)
* Sign our contributor agreement (CLA)[online](https://supermarket.getchef.com/ccla-signatures/new)
* Visit the Github page for the project.
* Fork the repository
* Create a feature branch for your change.
* Create a Pull Request for your change.

We regularly review contributions and will get back to you if we have
any suggestions or concerns.

## The Apache License and the CLA/CCLA

Licensing is very important to open source projects, it helps ensure
the software continues to be available under the terms that the author
desired. Chef uses the Apache 2.0 license to strike a balance between
open contribution and allowing you to use the software however you
would like to.

The license tells you what rights you have that are provided by the
copyright holder. It is important that the contributor fully
understands what rights they are licensing and agrees to them.
Sometimes the copyright holder isn't the contributor, most often when
the contributor is doing work for a company.

To make a good faith effort to ensure these criteria are met, Chef
Software Inc requires a Contributor License Agreement (CLA) or a Corporate
Contributor License Agreement (CCLA) for all contributions. This is
without exception due to some matters not being related to copyright
and to avoid having to continually check with our lawyers about small
patches.

It only takes a few minutes to complete a CLA, and you retain the
copyright to your contribution.

You can complete our contributor agreement (CLA)
[online](https://supermarket.getchef.com/ccla-signatures/new) If
you're contributing on behalf of your employer, have your employer
fill out our
[Corporate CLA](https://supermarket.getchef.com/ccla-signatures/new)
instead.

## Using git

You can get a quick copy of the repository for this cookbook by
running `git clone git://github.com/opscode-coobkooks/COOKBOOKNAME.git`.

For collaboration purposes, it is best if you create a Github account
and fork the repository to your own account. Once you do this you will
be able to push your changes to your Github repository for others to
see and use.

If you have another repository in your GitHub account named the same
as the cookbook, we suggest you suffix the repository with -cookbook.

### Branches and Commits

Create a _topic branch_ and a pull request on Github. It is a best
practice to have your commit message have a _summary line_ followed by
an empty line and then a brief description of the commit. This also
helps other contributors understand the purpose of changes to the
code.

If your branch has multiple commits, please quash them into a
single commit. If the PR is addressing an issue in the Github issue
tracker, please reference it in the summary line.

    [#42] - platform_family and style

    * use platform_family for platform checking
    * update notifies syntax to "resource_type[resource_name]" instead of
      resources() lookup
    * #40 - delete config files dropped off by packages in conf.d
    * dropped debian 4 support because all other platforms have the same
      values, and it is older than "old stable" debian release

Remember that not all users use Chef in the same way or on the same
operating systems as you, so it is helpful to be clear about your use
case and change so they can understand it even when it doesn't apply
to them.

### More information

Additional help with git is available on the
[Working with Git](http://wiki.opscode.com/display/chef/Working+with+Git)
wiki page.

## Functional and Unit Tests

This cookbook is set up to run tests under
[Kitchen-ci's test-kitchen](https://github.com/test-kitchen/test-kitchen).
It uses Serverspec or Bats to perform integration tests after the node
has been converged.

Test kitchen should run completely without exception using the default
[baseboxes provided by Chef](https://github.com/opscode/bento).
Because Test Kitchen creates VirtualBox machines and runs through
every configuration in the Kitchenfile, it may take some time for
these tests to complete.

If your changes are only for a specific recipe, run only its
configuration with Test Kitchen. If you are adding a new recipe, or
other functionality such as a LWRP or definition, please add
appropriate tests and ensure they run with Test Kitchen.

If any don't pass, investigate them before submitting your patch.

Any new feature should have unit tests included with the patch with
good code coverage to help protect it from future changes. Similarly,
patches that fix a bug or regression should have a _regression test_.
Simply put, this is a test that would fail without your patch but
passes with it. The goal is to ensure this bug doesn't regress in the
future. Consider a regular expression that doesn't match a certain
pattern that it should, so you provide a patch and a test to ensure
that the part of the code that uses this regular expression works as
expected. Later another contributor may modify this regular expression
in a way that breaks your use cases. The test you wrote will fail,
signalling to them to research your ticket and use case and accounting
for it.

If you need help writing tests, please ask on the Chef Developer's
mailing list, or the #chef-hacking IRC channel.

## Code Review

Chef regularly reviews code contributions and provides suggestions
for improvement in the code itself or the implementation.

Depending on the project, these tickets are then merged within a week
or two, depending on the current release cycle.

## Release Cycle

The versioning for Chef Cookbook projects is X.Y.Z.

* X is a major release, which may not be fully compatible with prior
  major releases
* Y is a minor release, which adds both new features and bug fixes
* Z is a patch release, which adds just bug fixes

Releases of Chef's cookbooks are usually announced on the Chef user
mailing list. Releases of several cookbooks may be batched together
and announced on the [Chef Blog](http://www.getchef.com/blog).

## Working with the community

These resources will help you learn more about Chef and connect to
other members of the Chef community:

* [chef](http://lists.opscode.com/sympa/info/chef) and
  [chef-dev](http://lists.opscode.com/sympa/info/chef-dev) mailing
  lists
* #chef and #chef-hacking IRC channels on irc.freenode.net
* [Community Cookbook site](http://community.opscode.com)
* [Chef wiki](http://wiki.opscode.com/display/chef)
* Chef, Inc [product page](http://www.getchef.com/chef)

## Cookbook Contribution Do's and Don't's

Please do include tests for your contribution. If you need help, ask
on the [chef-dev mailing list](http://lists.opscode.com/sympa/info/chef-dev)
or the [#chef-hacking IRC channel](http://community.opscode.com/chat/chef-hacking).
Not all platforms that a cookbook supports may be supported by Test
Kitchen. Please provide evidence of testing your contribution if it
isn't trivial so we don't have to duplicate effort in testing. Chef
10.14+ "doc" formatted output is sufficient.

Please do indicate new platform (families) or platform versions in the
commit message, and update the relevant ticket.

If a contribution adds new platforms or platform versions, indicate
such in the body of the commit message(s).

    git commit -m 'Updated pool resource to correctly delete.'

Please do ensure that your changes do not break or modify behavior for
other platforms supported by the cookbook. For example if your changes
are for Debian, make sure that they do not break on CentOS.

Please do not modify the version number in the metadata.rb, Chef
Software, Inc will select the appropriate version based on the release
cycle information above.

Please do not update the CHANGELOG.md for a new version. Not all
changes to a cookbook may be merged and released in the same versions.
Opscode will update the CHANGELOG.md when releasing a new version of
the cookbook.
