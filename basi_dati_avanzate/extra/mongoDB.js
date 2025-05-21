// comandi di base

//mostra i database presenti nell’istanza
db.getMongo().getDBs() 
show dbs 

//mostra le collezioni nel DB corrente
db.getCollectionNames() 
show collections
// passa al database local
use local
db.getSiblingDB("local") // usa local senza modificare la variabile db nella shell 


//Per lavorare su una collezione
db.[collectionName].[method]([parameters])

//---------------------------------------------------------------------------------------
//CRUD: insert
//create la collezione users
db.createCollection("users")

db.user.insertOne ({
	name: "mila",
	age: 15,
	status: "A"
})

//Eliminare una collezione
db.users.drop()

//Inserimento multiplo
var myusers = [{name: "al", age: 18, status: "A"}, 
{name: "lee", age: 28, status: "B"}, 
{name: "jan",	age: 21,status: "A"}];

db.users.insertMany(myusers);

//Bulk insert
var bulk = db.users.initializeUnorderedBulkOp();
bulk.insert({name: "kai", age: 38, status: "C"});
bulk.insert({name: "sam", age: 18, status: "B"});
bulk.insert({name: "mel", age: 38 ,status: "A"});
bulk.execute();

//----------------------------------------------------------------------------------------
//CRUD: read

//Selezionare tutti i documenti
db.users.find()

//Con un criterio di ricerca
db.users.find ({status: "A"})

//Con selezione e proiezione
db.users.find (
{status: "A"},  //criterio 
{name:1,age:1 } //proiezione 
)

//Ordinare i documenti
db.users.find().sort({age:1 }) //1= crescente, -1= decrescente

//Contare i documenti
db.users.find().count()

//Limitare l’output
db.users.find (
{status: "A"},  //criterio 
{name:1,age:1 } //proiezione 
).limit(5) //modificatore

//Solo il primo:
db.users.findOne (
{status: "A"}  //criterio 
) 


//----------------------------------------------------------------------------------------
//CRUD: update

//modifica lo stato degli utenti di 18 anni
db.users.updateMany(
{ age: 18},
{ $set: { status: "A"} },
)


//setOnInsert
db.users.update(
{ name: "tom" },
{ $set: {name: "tom",
  age: 24, 
  status: "C",
  hobbies : ["volley", "bike"]},
  $setOnInsert : {createdAt : new Date()} //solo in caso di insert
},
{ upsert:true }
)

//aggiungere campi a un array
db.users.updateOne(
	{ name: "lee" },
	{
	    $set: { status: "B"},
	    $inc: { age: 1 },
	    $currentDate: {lastModified: true},
	    $addToSet: {hobbies : { $each :["food","skate"] }}
           //$addToSet: { hobbies : "skate"}
	}
)

//----------------------------------------------------------------------------------------
//CRUD: delete

//elimino un documento in base a un criterio
db.users.deleteMany({status: "A"})

//elimino un'intera collezione
db.users.drop()

//---------------------------------------------------------------------------------------
//Uso di Find: DB restaurant

//alcune interrogazioni semplici (clausole di uguaglianza)
db.restaurants.find() //Restituisce tutti i documenti
db.restaurants.findOne() //Restituisce solo il primo documento
db.restaurants.find({cuisine: "Hamburgers"}) //Restituisce i documenti in cui l’attributo cuisine (se presente) è valorizzato con la stringa "Hamburgers"
db.restaurants.find({},{cuisine: 1}) //Restituisce tutti i documenti, ma proiettando solamente l’attributo cuisine (oltre all’_id, che viene restituito di default)
db.restaurants.find({cuisine: "Hamburgers"},{cuisine: 1}) //La combinazione di selezione e proiezione

//Trova i ristoranti con restaurant_id> "40356483" 
db.restaurants.find({restaurant_id >= "40356483"}); //non funziona
db.restaurants.find({restaurant_id: {$gte : "40356483"}});

//Operatori di confronto
db.restaurants.find({name: {$gt : "Regi", $lt : "Regl"}}); 
db.restaurants.find({restaurant_id: {$gte : "40356483", $lte : "40357500"}});
db.restaurants.find({cuisine: {$ne : "Hamburgers"}} )

//Condizioni multiple
db.restaurants.find({cuisine: {$nin : ["Hamburgers","Chicken"]} })
db.restaurants.find({cuisine: {$in : ["Chinese", "Jewish/Kosher"]} })
db.restaurants.find({$or: [{cuisine: {$in : ["Chinese", "Irish"]}} , {borough: "Brooklyn" }]}) 
db.restaurants.find({$and:[{cuisine:"American"},{borough:"Bronx"}]})
db.restaurants.find({cuisine:"American", borough:"Bronx"}) //preferibile: la  condizione è comunque in AND

//Interrogare le stringhe
db.restaurants.find( { borough: /^Bro/ } ).count() //ristoranti del Bronx o Brooklyn
db.restaurants.find( { name: /ALE/i } ) //ristoranti con nome che contengono la stringa ALE (case insentive)
db.restaurants.find( { name: {$regex: /ALE/i }} ) //come sopra

//interrogare un array
var mysamples = [{ _id: 1, tests: 3, results: [ 82, 95, 88 ] },
{ _id: 2, tests: 6, results: [ 82, 98, 99 ] },
{ _id: 3, tests: 4, results: [ 75, 95, 82 ] }
];
db.scores.insert(mysamples); //creazione della collezione scores

db.scores.find({results : 95}) //match se l’array contiene 95 (restituisce: 1 e 3)
db.scores.find({results : {$all : [82, 95]}}) //match se l’array contiene sia 82 che 95 (restituisce: 1 e 3)
db.scores.find({results : {$in : [82, 95]}}) //match se l’array contiene 82 o 95 (restituisce: 1, 2 e 3)
db.scores.find({results : [95, 82, 88]}) //match se l’array corrisponde esattamente a quello indicato (restituisce: nulla)
db.scores.find({results : {$size : 3}}) // match se l’array contiene 3 elementi (restituisce: 1, 2 e 3)
db.scores.find({"results.2" : 88}) //match se l’array contiene 88 in posizione 2 0-based (restituisce: 1)
db.scores.find({ results: { $elemMatch: { $gte: 97, $lt: 100 } } }) //match se l’array almeno un elemento tra 97 e 100 (restituisce: 2)

db.scores.find({tests : {$gt:5, $lt:7}}) //Il valore di tests deve essere maggiore di 5 e minore di 7
db.scores.find({results : {$gt:93, $lt:96}}) // Almeno un elemento di results deve essere >93 o <96
db.scores.find({results : {$elemMatch: {$gt:93, $lt:96}}}) // Almeno un elemento di results deve essere >93 e <96

//interrogare oggetti
var mysamples = [
{
    "content" : "prova",
    "writer" : {first:"Joe", middle:"K" , last:"Shoe" },
    "comments" : [ 
        {
            "author" : "joe",
            "score" : 3.0,
            "comment" : "nice"
        }, 
        {
            "author" : "mary",
            "score" : 6.0,
            "comment" : "terrible"
        }
    ]
},
{
    "content" : "post2",
    "writer" : {first:"Ann", last:"Brown" },
    "comments" : [ 
        {
            "author" : "nick",
            "score" : 2.0,
            "comment" : "good"
        }, 
        {
            "author" : "joe",
            "score" : 5.0,
            "comment" : "bad"
        }
    ]
}
];
db.blog.insert(mysamples); //creazione della collezione scores


//Obiettivo: cercare i commenti di Joe con un punteggio >= 5
db.blog.find({comments : {author : "joe",  "score" : {$gte : 5}}})  // Sbagliato: cerca il match esatto
db.blog.find({"comments.author" : "joe", "comments.score" : {$gte : 5}})  //Sbagliato: le condizioni sono valutate sui diversi commenti della lista (esiste almeno un commento che soddisfa ciascuna condizione): 
db.blog.find({comments : {$elemMatch : {author : "joe", score : {$gte : 5}}}}) //OK



//i modificatori: collezione users
db.users.find().limit(3) //Limit: restituisce solo i primi n documenti
db.users.find().skip(3) //Skip: salta i primi n documenti e restituisci i successivi
db.users.find().sort({ age : -1,status :1}) //

//Questi comandi possono essere combinati (ad esempio per gestire la paginazione dei risultati)
db.users.find().limit(20).sort({name:1})
db.users.find().limit(20).skip(20).sort({name:1})


db.users.count({status : "A"}) //Count conta i documenti restituiti da una query
db.users.distinct( "status",  {hobbies : {"$exists" : true} } )  //Distinct restituisce i valori distinti di un campo
//--------------------------------------------------------------------------------------
//indexes
db.stores.insertMany([
    { _id: 1, name: "Java Hut", description: "Coffee and cakes" },
    { _id: 2, name: "Burger Buns", description: "Gourmet hamburgers" },
    { _id: 3, name: "Coffee Shop", description: "Just coffee" },
    { _id: 4, name: "Clothes Clothes", description: "Discount clothing" },
    { _id: 5, name: "Java Shopping", description: "Indonesian goods" }])

db.stores.createIndex( { name: "text", description: "text" } ) 

db.stores.find( { $text: { $search: "java coffee shop" } } )
//Le parole indicate sono considerate in OR

db.stores.find( { $text: { $search: "java \"coffee shop\""} } )
//Le stringhe indicate tra virgolette (") vengono cercate esattamente 
//Se la ricerca contiene una frase + altre parole viene cercata solo la frase

db.stores.find( { $text: { $search: "java shop -coffee" } } )
//Le parole precedute dal meno (-) causano l'esclusione del documento


//---------------------------------------------------------------------------------------
//Aggregate

//collezione students 
var mystud = [
{"name": "Gadaffy","unit": "A","age": 18,"marks": [20, 50, 38] },
{"name": "John","unit": "B","age": 17,"marks": [38, 60, 70]},
{"name": "David","unit": "A","age": 30},
{"name": "Emily","unit": "C","age": 18, "marks": [40, 87, 34]},
{"name": "Cynthia","unit": "B","age": 16, "marks": [60, 90, 98]},
{"name": "Mary","unit": "B","age": 28, "marks": [52, 50, 56]}
];
db.students.insert(mystud); //creazione della collezione students

//Seleziona nome e età degli studenti di più di 20 anni e ordina per età
db.students.aggregate([
  {$match: {age: {$gt:20}}},
  {$project: {_id: 0, name:1, age:1} },
  {$sort: {age: 1}}
])

//Operatore $project:Restituisce il nome dello studente ed esclude il campo _id
db.students.aggregate([{$project:{ "name":1,"_id":0}}]);
//Operatore $project:Rinomina il campo _id in userId
db.students.aggregate([{$project:{ "userId" : "$_id", "name" : 1, "_id" : 0}}]);

//Esempio di $Project
//Collezione Bios
db.bios.insertMany([
   {
       "_id" : 1,
       "name" : {
           "first" : "John",
           "last" : "Backus"
       },
       "birth" : ISODate("1924-12-03T05:00:00Z"),
       "death" : ISODate("2007-03-17T04:00:00Z"),
       "contribs" : [
           "Fortran",
           "ALGOL",
           "Backus-Naur Form",
           "FP"
       ],
       "awards" : [
           {
               "award" : "W.W. McDowell Award",
               "year" : 1967,
               "by" : "IEEE Computer Society"
           },
           {
               "award" : "National Medal of Science",
               "year" : 1975,
               "by" : "National Science Foundation"
           },
           {
               "award" : "Turing Award",
               "year" : 1977,
               "by" : "ACM"
           },
           {
               "award" : "Draper Prize",
               "year" : 1993,
               "by" : "National Academy of Engineering"
           }
       ]
   },
   {
       "_id" : 2,
       "name" : {
           "first" : "John",
           "last" : "McCarthy"
       },
       "birth" : ISODate("1927-09-04T04:00:00Z"),
       "death" : ISODate("2011-12-24T05:00:00Z"),
       "contribs" : [
           "Lisp",
           "Artificial Intelligence",
           "ALGOL"
       ],
       "awards" : [
           {
               "award" : "Turing Award",
               "year" : 1971,
               "by" : "ACM"
           },
           {
               "award" : "Kyoto Prize",
               "year" : 1988,
               "by" : "Inamori Foundation"
           },
           {
               "award" : "National Medal of Science",
               "year" : 1990,
               "by" : "National Science Foundation"
           }
       ]
   },
   {
       "_id" : 3,
       "name" : {
           "first" : "Grace",
           "last" : "Hopper"
       },
       "title" : "Rear Admiral",
       "birth" : ISODate("1906-12-09T05:00:00Z"),
       "death" : ISODate("1992-01-01T05:00:00Z"),
       "contribs" : [
           "UNIVAC",
           "compiler",
           "FLOW-MATIC",
           "COBOL"
       ],
       "awards" : [
           {
               "award" : "Computer Sciences Man of the Year",
               "year" : 1969,
               "by" : "Data Processing Management Association"
           },
           {
               "award" : "Distinguished Fellow",
               "year" : 1973,
               "by" : " British Computer Society"
           },
           {
               "award" : "W. W. McDowell Award",
               "year" : 1976,
               "by" : "IEEE Computer Society"
           },
           {
               "award" : "National Medal of Technology",
               "year" : 1991,
               "by" : "United States"
           }
       ]
   },
   {
       "_id" : 4,
       "name" : {
           "first" : "Kristen",
           "last" : "Nygaard"
       },
       "birth" : ISODate("1926-08-27T04:00:00Z"),
       "death" : ISODate("2002-08-10T04:00:00Z"),
       "contribs" : [
           "OOP",
           "Simula"
       ],
       "awards" : [
           {
               "award" : "Rosing Prize",
               "year" : 1999,
               "by" : "Norwegian Data Association"
           },
           {
               "award" : "Turing Award",
               "year" : 2001,
               "by" : "ACM"
           },
           {
               "award" : "IEEE John von Neumann Medal",
               "year" : 2001,
               "by" : "IEEE"
           }
       ]
   },
   {
       "_id" : 5,
       "name" : {
           "first" : "Ole-Johan",
           "last" : "Dahl"
       },
       "birth" : ISODate("1931-10-12T04:00:00Z"),
       "death" : ISODate("2002-06-29T04:00:00Z"),
       "contribs" : [
           "OOP",
           "Simula"
       ],
       "awards" : [
           {
               "award" : "Rosing Prize",
               "year" : 1999,
               "by" : "Norwegian Data Association"
           },
           {
               "award" : "Turing Award",
               "year" : 2001,
               "by" : "ACM"
           },
           {
               "award" : "IEEE John von Neumann Medal",
               "year" : 2001,
               "by" : "IEEE"
           }
       ]
   },
   {
       "_id" : 6,
       "name" : {
           "first" : "Guido",
           "last" : "van Rossum"
       },
       "birth" : ISODate("1956-01-31T05:00:00Z"),
       "contribs" : [
           "Python"
       ],
       "awards" : [
           {
               "award" : "Award for the Advancement of Free Software",
               "year" : 2001,
               "by" : "Free Software Foundation"
           },
           {
               "award" : "NLUUG Award",
               "year" : 2003,
               "by" : "NLUUG"
           }
       ]
   },
   {
       "_id" : 7,
       "name" : {
           "first" : "Dennis",
           "last" : "Ritchie"
       },
       "birth" : ISODate("1941-09-09T04:00:00Z"),
       "death" : ISODate("2011-10-12T04:00:00Z"),
       "contribs" : [
           "UNIX",
           "C"
       ],
       "awards" : [
           {
               "award" : "Turing Award",
               "year" : 1983,
               "by" : "ACM"
           },
           {
               "award" : "National Medal of Technology",
               "year" : 1998,
               "by" : "United States"
           },
           {
               "award" : "Japan Prize",
               "year" : 2011,
               "by" : "The Japan Prize Foundation"
           }
       ]
   },
   {
       "_id" : 8,
       "name" : {
           "first" : "Yukihiro",
           "aka" : "Matz",
           "last" : "Matsumoto"
       },
       "birth" : ISODate("1965-04-14T04:00:00Z"),
       "contribs" : [
           "Ruby"
       ],
       "awards" : [
           {
               "award" : "Award for the Advancement of Free Software",
               "year" : "2011",
               "by" : "Free Software Foundation"
           }
       ]
   },
   {
       "_id" : 9,
       "name" : {
           "first" : "James",
           "last" : "Gosling"
       },
       "birth" : ISODate("1955-05-19T04:00:00Z"),
       "contribs" : [
           "Java"
       ],
       "awards" : [
           {
               "award" : "The Economist Innovation Award",
               "year" : 2002,
               "by" : "The Economist"
           },
           {
               "award" : "Officer of the Order of Canada",
               "year" : 2007,
               "by" : "Canada"
           }
       ]
   },
   {
       "_id" : 10,
       "name" : {
           "first" : "Martin",
           "last" : "Odersky"
       },
       "contribs" : [
           "Scala"
       ]
   }
] )


//Restituisce l’anno di nascita
db.bios.aggregate([{ $project : {
   "name" :1,"YOB" : {"$year": "$birth"}}}])

//Restituisce l'età
db.bios.aggregate([{ $project : {
"name" :1, "age" : { "$subtract" : [{"$year" : new Date()}, {"$year" : "$birth"}}}])

db.bios.aggregate([{ $project : {  
"name" :1, "age" : { "$subtract" : [{"$year" : new Date()}, {"$year" : "$birth"}]}}}])


//Restituisce il nome e cognome e un indirizzo email tipo a.lumini@gmail.com
db.bios.aggregate([{ 
  $project : {
	"fullname" : {"$concat": ["$name.first"," ","$name.last"]},
	"e-mail" :  {"$concat" :[{"$substr" : ["$name.first", 0, 1]},      ".", "$name.last", "@gmail.com"]}}}])

//Restituisce il primo e l’ultimo contributo di ciascuna persona
db.bios.aggregate([{
 $project: {
   name :1,
   firstContrib: { $arrayElemAt: ["$contribs", 0 ] },
	lastcontrib: { $arrayElemAt: ["$contribs", -1 ] } 
}}]);


//Esempio di $Group
//Collezione Students


//Raggruppa gli studenti per «unit» e conta in numero di studenti per gruppo (ordinando per cardinalità dei gruppi)
db.students.aggregate([
  {$match: {age: {$gt:16}}},
  {$group: {"_id": "$unit", "numStud" : {"$sum" : 1}} },
  {$sort: {numStud: -1}}
])

//Raggruppa gli studenti per unità e ne visualizza età massima e minima
db.students.aggregate([{"$group" : {"_id" : "$unit",   "lowestAge" : {"$min" : "$age"},   "highestAge" : {"$max" : "$age"}} }])

//Restituisce l’elenco degli studenti in ciascun gruppo
db.students.aggregate([ 
    {$project : {"unit" : 1, "name" : 1}}, 
    {$group : {"_id":"$unit","numStud":{"$sum":1}, "studentList" : { "$addToSet" : "$name"}}}  ]);

//Esempi di $unwind
//Restituisce i voti di John (con relativo ordine)
db.students.aggregate([
	{$match: {"name": "John"}},
	{$unwind: {path : "$marks",includeArrayIndex : "m_ix"}},
	{$project: {"_id" : 0,"name" : 1,"mark" : "$marks", "m_ix":1} }])


//Restituisce la media voti per unit
db.students.aggregate([
	{$unwind: {path : "$marks"}},
	{$group :{"_id":"$unit","avgMark" : {"$avg" : "$marks"} }}])


//Esempio di $Lookup
//Collezioni orders e inventory
db.orders.insert([
{ "_id" : 1, "item" : "abc", "price" : 12, "quantity" : 2 },
{ "_id" : 2, "item" : "jkl", "price" : 20, "quantity" : 1 },
{ "_id" : 3  }])
db.inventory.insert([
{"_id": 1, "sku" : "abc", description: "product 1", "instock" : 120 },
{"_id": 2, "sku" : "def", description: "product 2", "instock" : 80 },
{"_id": 3, "sku" : "ghi", description: "product 3", "instock" : 60 },
{"_id": 4, "sku" : "jkl", description: "product 4", "instock" : 70 },
{"_id": 5, "sku": null, description: "Incomplete" },
{"_id": 6 }])
//Esempio: ricomporre ordini con i dati di inventario 
db.orders.aggregate([
{ $lookup: {from: "inventory", localField: "item", foreignField: "sku", as: "inventory_docs" }}])

//Viste in mongoDB

db.createView(
  "orders_view",
  "orders",
[{   "$lookup" : { 
                "from" : "inventory", 
                "localField" : "item", 
                "foreignField" : "sku", 
                "as" : "inventory_docs" }}, 
 {   "$project" : { 
                "_id" : 1.0, 
                "item" : 1.0, 
                "price" : 1.0, 
                "quantity" : 1.0, 
                "desc" : {"$arrayElemAt" :["$inventory_docs",0]} }}, 
 {   "$project" : { 
                "_id" : 1.0, 
                "item" : 1.0, 
                "price" : 1.0, 
                "quantity" : 1.0, 
                "description" : "$desc.description", 
                "instock" : "$desc.instock" } }]);
 
// Visualizza ordini che non possono essere evasi
db.orders_view.aggregate([{$match:{$expr:{$gt:["$instock", "$quantity"]}}}])










