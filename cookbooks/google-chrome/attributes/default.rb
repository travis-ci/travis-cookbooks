default['google-chrome']['pkg']['url'] = 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'

default['google-chrome']['deps'] = %w(
  gconf-service
  libasound2
  libcairo2
  libcups2
  libfontconfig1
  libgconf-2-4
  libgdk-pixbuf2.0-0
  libgtk2.0-0
  libnspr4
  libnss3
  libpango1.0-0
  libx11-6
  libxcomposite1
  libxcursor1
  libxdamage1
  libxext6
  libxfixes3
  libxi6
  libxrandr2
  libxrender1
  libxss1
  libxtst6
  libdbusmenu-glib4
  libdbusmenu-gtk4
  libindicator7
  libappindicator1
  libcurl3
  xdg-utils
)
