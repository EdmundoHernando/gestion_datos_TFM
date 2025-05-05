# Crear certificados solo si no existen
if [ ! -f "./nifi/certs/keystore.p12" ]; then
  echo "Generando certificados de NiFi..."
  keytool -genkeypair -alias nifi -keyalg RSA -keysize 2048 \
    -keystore ./nifi/certs/keystore.p12 -storepass gatvgatv \
    -keypass gatvgatv -dname "CN=NiFi, OU=Dev, O=Org, L=City, S=State, C=Country" \
    -storetype PKCS12 \
    -ext "SAN=DNS:localhost,DNS:nifi"  # Agregar SAN aquí
  keytool -exportcert -alias nifi -keystore ./nifi/certs/keystore.p12 \
    -storepass gatvgatv -file ./nifi/certs/nifi-cert.pem
else
  echo "Certificados de NiFi ya existen. No se generarán de nuevo."
fi

if [ ! -f "./nifi/certs/truststore.p12" ]; then
  echo "Generando TrustStore de NiFi (PKCS12)..."
  keytool -import -alias nifi-cert \
    -file ./nifi/certs/nifi-cert.pem \
    -keystore ./nifi/certs/truststore.p12 \
    -storepass gatvgatv -storetype PKCS12 -noprompt
else
  echo "El TrustStore de NiFi (PKCS12) ya existe. No se generará de nuevo."
fi
