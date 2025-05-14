COME COSTRUIRE IL SISTEMA

BUILD IMAGES
  docker compose build
  docker images

RUN & USE
  docker compose up -d
  ./show_db_from_mongodb.sh 
  ./show_db_from_nodejsapp.sh 

DELETE
  docker compose down

//////////////////////////
PIU' COMPLETO:

# BUILD IMAGES
cd ./ASWh4
docker compose build

# RUN
docker compose up -d

# USA mediante POST e GET
curl --header "Content-Type: application/x-www-form-urlencoded"  --request POST --data 'seq1=ALFABETAGAMMA&seq2=VAFFA' http://0.0.0.0:3000/
curl http://0.0.0.0:3000/show
# da browser per vedere la form che chiede le due stringhe
curl http://0.0.0.0:3000/show

