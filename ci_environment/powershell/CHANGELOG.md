## v1.0.8:

* [COOK-1834] - fix broken notifies

## v1.0.6:

* Refactor the powershell resource from a core-Chef monkey-patch into a proper LWRP.
* Take advantage of native Win32 support for `cwd` and `environment` in Chef 0.10.8+.
* [COOK-630] force powershell scripts to terminate immediately and return an error code on failure
* ensure more sane default options are set on PowerShell process

## v1.0.4:

* [COOK-988] - Powershell never exists on the powershell resource

## v1.0.2:

* always reference powershell.exe in a fully qualified way in case PATH
* move download url and checksums to attribute file
* massive refactor of default recipe...leverages windows_package and version helper
provided by recent windows cookbook updates

## v1.0.1:

* [COOK-581] force 64-bit powershell process from 32-bit ruby processes

## v1.0.0:

* initial release
