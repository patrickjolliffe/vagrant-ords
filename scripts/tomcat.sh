#!/bin/bash
#tomcat-native part of EPEL
yum install -y tomcat tomcat-native

cat > /tmp/sed_herefile << EOF
   <!-- HTTP -->
   <Connector port="8001"    protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="1" connectionTimeout="20000" />

   <Connector port="8002"    protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="2" connectionTimeout="20000" />

   <Connector port="8004"    protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="4" connectionTimeout="20000" />

   <Connector port="8008"    protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="8" connectionTimeout="20000" />

   <Connector port="8016"     protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="16" connectionTimeout="20000" />

   <Connector port="8032"     protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="32" connectionTimeout="20000" />

   <Connector port="8064"     protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="64" connectionTimeout="20000" />

   <Connector port="8128"      protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="128" connectionTimeout="20000" />              

   <!-- APR/native connector -->   
   <Connector port="1110"    protocol="org.apache.coyote.http11.Http11AprProtocol"
              maxThreads="4"
              connectionTimeout="20000" />

   <!-- Non-blocking Java connector -->
   <Connector port="1111" protocol="org.apache.coyote.http11.Http11NioProtocol"
              maxThreads="4"
              connectionTimeout="20000" />

  <!-- Blocking Java connector -->
  <Connector port="1112" protocol="org.apache.coyote.http11.Http11Protocol"
              maxThreads="8"
              connectionTimeout="20000" />

  <!-- Not Implemented in Tomcat 7 :(
  <Connector port="1112" protocol="org.apache.coyote.http11.Http11Nio2Protocol"
              maxThreads="8"
              connectionTimeout="20000" />              
   -->              

   <!-- HTTPS -->
   <!-- APR/Native Connector uses OpenSSL -->
   <Connector  port="1210" protocol="org.apache.coyote.http11.Http11AprProtocol"
               SSLCertificateFile="/usr/local/ssl/ords.crt"
               SSLCertificateKeyFile="/usr/local/ssl/ords.key"
               maxThreads="8" SSLEnabled="true" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS" />

   <!-- Non-blocking Java connector uses JSSE SSL  -->
   <Connector port="1211" protocol="org.apache.coyote.http11.Http11NioProtocol"              
              keystoreFile="/usr/local/ssl/ords.jks"
              keystorePass="Password123"
              maxThreads="8" SSLEnabled="true" scheme="https" secure="true"
              clientAuth="false" sslProtocol="TLS" />


   <!-- Non-blocking Java connector uses JSSE SSL  -->
   <Connector port="1212" protocol="org.apache.coyote.http11.Http11Protocol"              
              keystoreFile="/usr/local/ssl/ords.jks"
              keystorePass="Password123"
              maxThreads="8" SSLEnabled="true" scheme="https" secure="true"
              clientAuth="false" sslProtocol="TLS" />
EOF

sed -i '/<Service name="Catalina">/r /tmp/sed_herefile' /etc/tomcat/server.xml

#Skip these changes, they don't seem to improve performance
#echo JAVA_OPTS="-Xms2048m -Xmx2048m -server" >> /etc/tomcat/tomcat.conf
#sed -i "/<Valve className=\"org.apache.catalina.valves.AccessLogValve\" /i\ <\!--" /etc/tomcat/server.xml
echo JAVA_OPTS="-Djava.security.egd=file:/dev/urandom" >> /etc/tomcat/tomcat.conf
/usr/bin/systemctl enable tomcat.service
/usr/bin/systemctl start tomcat.service

#Allow Vagrant user to acccess Tomcat logs
usermod -G tomcat -a vagrant
chown tomcat:tomcat /var/log/tomcat