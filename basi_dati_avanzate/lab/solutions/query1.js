let study = db.getSiblingDB("study")
let restaurants = study.restaurants
let dbg

// 10. Mostrare tutti i ristoranti esclusi quelli che si trovano a Brooklyn o nel Bronx
restaurants.find({ borough: { $nin: ["Brooklyn", "Bronx"] } })

// 11. Mostrare i campi restaurant_id, name, borough e cuisine di tutti i documenti nella collezione.
restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 12. Mostrare restaurant_id, name, borough e cuisine (escludere _id) di un ristorante che si trova a Queens
restaurants.findOne({ borough: "Queens" }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1, _id: 0 })

// 13. Mostrare i primi 5 ristoranti che si trovano nel Bronx
restaurants.find({ borough: "Bronx" }, { name: 1 }).limit(5)

// 14. Mostrare i prossimi 5 (escludendo i primi 5) ristoranti che si trovano nel Bronx
restaurants.find({ borough: "Bronx" }, { name: 1 }).skip(5).limit(5)

// 15. Mostrare restaurant_id, name, borough e cuisine per tutti i ristoranti il cui nome inizia con 'Wil'
restaurants.find({ name: /^Wil/ }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 16. Mostrare i ristoranti che hanno almeno un score >90
restaurants.find({ "grades.score": { $gt: 90 } })

// 16bis: proiezione sui dati utili (nome, solo grades con score >90)
restaurants.find({ "grades.score": { $gt: 90 } }, { name: 1, _id: 0, "grades.score.$": 1 })

// 16ter. Mostrare i ristoranti che hanno un score >90 e <100
restaurants.find({ "grades": { $elemMatch: { score: { $gt: 90, $lt: 100 } } } })

// 17. Mostrare i ristoranti che hanno cucina diversa da "American", score>70 e latitudine (address.coord.0) <-65
restaurants.find({ cuisine: { $ne: "American" }, "grades.score": { $gt: 70 }, "address.coord.0": { $lt: -65 } })

// 18. Mostrare i ristoranti che non hanno avuto un score >10
restaurants.find({ "grades.score": { $not: { $gt: 10 } } })

// 19. Contare i ristoranti nel cui indirizzo non è specificata la street
restaurants.find({ "address.street": { $exists: false } }).count()

// 20. Contare i ristoranti che hanno 6 voti (grades)
restaurants.find({ "grades": { $size: 6 } }).count()

// 21. Contare i ristoranti che hanno più di 6 voti
restaurants.find({ "grades.5": { $exists: true } }).count()

// 22. Visualizzare tutti i tipi distinti di cucina
restaurants.distinct("cuisine", {})
