for containername in aswl4-mongodb-1 mongodb ; do

  docker exec -it ${containername} /usr/bin/mongosh \
    --eval "var conn = new Mongo(); \
          var db = conn.getDB('dbsa'); \
					var cursor = db.alignments.find(); \
					while ( cursor.hasNext() ) { \
					   printjson( cursor.next() ); \
					}"
done

