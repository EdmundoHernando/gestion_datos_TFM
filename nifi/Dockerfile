# Usa la imagen de NiFi basada en Debian Bullseye
FROM apache/nifi:2.0.0

# Cambiar a usuario root para instalar dependencias
USER root

# Instalar dependencias para compilar Python
RUN apt-get update && apt-get install -y \
    wget build-essential libssl-dev libffi-dev \
    python3-pip libsqlite3-dev libbz2-dev \
    libreadline-dev libncursesw5-dev zlib1g-dev \
    liblzma-dev tk-dev uuid-dev libgdbm-dev \
    libnss3-dev libgdbm-compat-dev

# Descargar y compilar Python 3.10 desde código fuente
WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz && \
    tar -xf Python-3.10.13.tgz && \
    cd Python-3.10.13 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall

# Verificar instalación de Python
RUN python3.10 --version

# Restaurar el usuario original de NiFi
USER nifi

# Exponer el puerto web de NiFi
EXPOSE 8443

