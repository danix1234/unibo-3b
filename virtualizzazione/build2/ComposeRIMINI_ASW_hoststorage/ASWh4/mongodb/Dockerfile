FROM mongo:8.0.1-noble

# Dovrebbe gia' esistere l'utente mongodb 
# ensure that if running as custom user that "mongosh" has a valid "HOME"
# https://github.com/docker-library/mongo/issues/524
# ENV HOME /data/db

# Per avere strumenti di debugging dentro ai container
# Sto comando RUN si puo' togliere quando funziona tutto
RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    iptables net-tools netcat curl \
    iputils-ping iproute2   &&  \
  apt-get -y clean; \
  rm -rf /var/lib/apt/lists/*;

# the VOLUME directive in the Dockerfile only defines that a volume should be created for a specific path in the image (/container when running). The name of the volume should never be dictated by an image, because that's something that should be defined at runtime
VOLUME /data/db /data/configdb

ADD mydbinit.js /docker-entrypoint-initdb.d/

# Nota: i flag di set fanno questo: 
# -e termina  la bash se un comando fallisce.
# -x fa vedere in output i comandi eseguiti. 
# -u genera errore se un comando cerca di espandere una variabile che non esiste.
RUN set -eux; \
	chown mongodb /docker-entrypoint-initdb.d/mydbinit.js; \
	chgrp mongodb /docker-entrypoint-initdb.d/mydbinit.js; \
	chmod 755 /docker-entrypoint-initdb.d/mydbinit.js

# questo script serve a inizializzare l'ambiente per il DB
# se non gli passiamo argomenti lui usa come argomento il CMD 
# cioe' esegue come servizio mongod.
# Questo script poi va nella directory /docker-entrypoint-initdb.d/
# ed esegue gli script che trova li' dentro.
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 27017 27018 27019
CMD ["mongod"]

