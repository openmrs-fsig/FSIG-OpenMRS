#! /bin/bash
#Configure automatic Certbot certificate renewal
echo "Renewing certbot certificate"

#remove previous certificates
rm /opt/tomcat/webapps/fsig-mrs.com.jks
rm /opt/tomcat/webapps/fsig-mrs.com_fullchain_and_key.p12 

#renew cert
certbot renew --force-renew

#generate JKS keystore
openssl pkcs12 -export -out /opt/tomcat/webapps/fsig-mrs.com_fullchain_and_key.p12 \
    -in /etc/letsencrypt/live/fsig-mrs.com/fullchain.pem \
    -inkey /etc/letsencrypt/live/fsig-mrs.com/privkey.pem \
    -name tomcat \
    -passin pass:<CERT PASSWORD> \
    -passout pass:<CERT PASSWORD>

#import keystore
keytool -importkeystore \
    -deststorepass <CERT PASSWORD> -destkeypass <CERT PASSWORD> -destkeystore /opt/tomcat/webapps/fsig-mrs.com.jks \
    -srckeystore /opt/tomcat/webapps/fsig-mrs.com_fullchain_and_key.p12  -srcstoretype PKCS12 -srcstorepass <CERT PASSWORD> \
    -alias tomcat

#restart application
echo "Restarting tomcat"
systemctl restart tomcat

