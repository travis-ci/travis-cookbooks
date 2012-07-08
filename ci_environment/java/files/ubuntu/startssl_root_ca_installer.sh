#!/bin/sh
#
# Downloads and installs the startssl CA certs into the global java keystore
# Author: Klaus Reimer <k@ailis.de>
#

# Check if JAVA_HOME is set
if [ "$JAVA_HOME" = "" ]
then
    JAVA_HOME="/usr/lib/jvm/java-7-oracle"
fi

# Check if cacerts file is present
if [ ! -f $JAVA_HOME/jre/lib/security/cacerts ]
then
    echo "ERROR: \$JAVA_HOME/jre/lib/security/cacerts not found. JAVA_HOME set correctly?"
    exit 1
fi

# Download the startssl certs
echo "Downloading certs..."
wget --continue http://www.startssl.com/certs/ca.crt
wget --continue http://www.startssl.com/certs/sub.class1.server.ca.crt
wget --continue http://www.startssl.com/certs/sub.class2.server.ca.crt
wget --continue http://www.startssl.com/certs/sub.class3.server.ca.crt
wget --continue http://www.startssl.com/certs/sub.class4.server.ca.crt

# Install certs into global keystore
echo "Adding certs to cacerts keystore (sudo password required)..."
sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias startcom.ca -file ca.crt
sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias startcom.ca.sub.class1 -file sub.class1.server.ca.crt
sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias startcom.ca.sub.class2 -file sub.class2.server.ca.crt
sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias startcom.ca.sub.class3 -file sub.class3.server.ca.crt
sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias startcom.ca.sub.class4 -file sub.class4.server.ca.crt

# If jsse is installed then also put the certs into jssecacerts keystore
if [ -f $JAVA_HOME/jre/lib/security/jssecacerts ]
then
    echo "Adding certs to jssecacerts keystore (sudo password required)..."
    sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/jssecacerts -storepass changeit -noprompt -alias startcom.ca -file ca.crt
    sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/jssecacerts -storepass changeit -noprompt -alias startcom.ca.sub.class1 -file sub.class1.server.ca.crt
    sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/jssecacerts -storepass changeit -noprompt -alias startcom.ca.sub.class2 -file sub.class2.server.ca.crt
    sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/jssecacerts -storepass changeit -noprompt -alias startcom.ca.sub.class3 -file sub.class3.server.ca.crt
    sudo keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/jssecacerts -storepass changeit -noprompt -alias startcom.ca.sub.class4 -file sub.class4.server.ca.crt
fi

# Remove downloaded certs
rm -f ca.crt sub.class1.server.ca.crt sub.class2.server.ca.crt sub.class3.server.ca.crt sub.class4.server.ca.crt
