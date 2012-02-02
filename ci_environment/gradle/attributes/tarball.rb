gradle_version = "1.0-milestone-7"

default[:gradle] = {
  :version          => gradle_version,
  :installation_dir => "/usr/local/gradle",
  :tarball => {
    :url => "http://repo.gradle.org/gradle/distributions/gradle-#{gradle_version}-bin.zip"
  }
}
