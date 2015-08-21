# Travis cookbooks!

Travis cookbooks are collections of Chef cookbooks used with [Chef
Solo](http://docs.opscode.com/chef_solo.html) for setting up:

 * Linux VMs for running tests (CI environment in `/ci_environment`)
 * Travis worker machine (host OS in `/worker_host`)

The Chef run lists that are used to build the different VM images for Travis CI
environment are defined in YAML files, that are stored in `/vm_templates`
subdirectory.  This custom definition format is similar to Chef roles and is
used by [travis-images](https://github.com/travis-ci/travis-images) tool.

## Developing Cookbooks

### Requirements

All the required cookbooks are stored in this single repository (no
Berkshelf/Librarian, no git modules). You can find more details about this
approach in ["Making Breakfast: Chef at
Airbnb"](http://nerds.airbnb.com/making-breakfast-chef-airbnb/).

* Chef cookbooks currently must be compatible with **Chef 12**.
* The VM template/basebox should be installed with **Ubuntu 12.04** or
  **Ubuntu 14.04** , which are the supported plaforms.

### Branches

There are two long-lived branches:

- `master` per tradition, which is compatible with **Ubuntu 14.04**
- `precise-stable`, which is compatible with **Ubuntu 12.04**

Target your patches accordingly.

### Vagrant

Cookbooks can be easily developed using
[Vagrant](https://github.com/mitchellh/vagrant) with [Sous
Chef](https://github.com/michaelklishin/sous-chef) workflow.

There is a `Vagrantfile` in this project that includes a VirtualBox setup,
though testing is possible with other [Vagrant
providers](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers).
For VirtualBox, make sure to use Vagrant 1.6.2+ and VirtualBox 4.3.12+, or you
might encounter [Vagrant #3341](https://github.com/mitchellh/vagrant/issues/3341).

The included `Vagrantfile` defines multiple machines, where each machine is a
target worker platform:

* `precise64`: this VM is defined as `primary` as Ubuntu 12.04 is officially
  supported by travis-cookbooks.
* `trusty64`: this VM is experimental and is not automatically started.
* `win8`: this VM is
  [experimental](https://github.com/travis-ci/travis-cookbooks/commits/ha-feature-windows)
and is not automatically started.

By default, Vagrant is configured to provision the `worker_standard` role. There
are [more possible
setups](https://github.com/travis-ci/travis-cookbooks/tree/master/vm_templates)
(`ruby`, `python`, etc.) but since all Travis worker machines are based on
`worker_standard` it provides good cookbook coverage. It is also possible to
narrow down the Chef run list to only install a specific set of cookbooks, as
commented in the `Vagrantfile` itself.

#### Windows Image

Vagrant will automatically install boxes for Ubuntu Linux (`precise64` and
`trusty64`) if you don't have them. Windows will not automatically install, and
in fact licensing concerns have preventing anyone from publishing a Vagrant box
that supports Windows on VirtualBox.

The following Windows boxes are available:
- [VagrantBox containing Windows on Hyper-V](http://vagrantbox.msopentech.com/)
  are available from Microsoft Open Technologies, but you can only use Hyper-V
if your host OS is Window... so don't waste your time downloading on Mac or
Linux.
- [Non-Vagrant VirtualBox
  images](http://modern.ie/en-us/virtualization-tools#downloads) - are available
from the modern.ie. Follow [these
instructions](https://github.com/WinRb/vagrant-windows#creating-a-base-box) to
create your own Windows base box.
- Go faster and simpler, use the cloud! Several of the [vagrant
  providers](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers)
are for clouds that have Windows images. *Unfortunately*: communication with
Windows is currently insecure and syncing folders (especially from non-Windows
hosts) is not widely supported - so cloud providers are more of a future option
unless you're willing to accept the known issues.

## License

See the LICENSE files.
