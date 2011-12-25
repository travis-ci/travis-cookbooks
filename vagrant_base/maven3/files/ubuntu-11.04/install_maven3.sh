# @author Yucca Nel
# @author Michael S. Klishin

#!/bin/sh
 
sudo apt-get install maven2
sudo mkdir -p /usr/lib/mvn

sudo rm -rf /tmp/*.tar.gz
cd /tmp

wget http://mirrors.powertech.no/www.apache.org/dist//maven/binaries/apache-maven-3.0.3-bin.tar.gz
tar -xvf ./*gz

sudo mv /tmp/apache-maven-3.* /usr/lib/mvn/

sudo apt-get remove maven2
sudo rm -f /usr/bin/mvn
sudo ln -s /usr/lib/mvn/apache-maven-3.0.3/bin/mvn /usr/bin/mvn

exit 0
