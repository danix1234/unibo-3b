const study = db.getSiblingDB("study")
const restaurants = study.restaurants

// 10. Mostrare tutti i ristoranti esclusi quelli che si trovano a Brooklyn o nel Bronx
// restaurants.find({ borough: { $nin: ["Brooklyn", "Bronx"] } })

// 11. Mostrare i campi restaurant_id, name, borough e cuisine di tutti i documenti nella collezione.
// restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 12. Mostrare restaurant_id, name, borough e cuisine (escludere _id) di un ristorante che si trova a Queens
// restaurants.findOne({ borough: "Queens" }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1, _id: 0 })

// 13. Mostrare i primi 5 ristoranti che si trovano nel Bronx
// restaurants.find({ borough: "Bronx" }, { name: 1 }).limit(5)

// 14. Mostrare i prossimi 5 (escludendo i primi 5) ristoranti che si trovano nel Bronx
// restaurants.find({ borough: "Bronx" }, { name: 1 }).skip(5).limit(5)

// 15. Mostrare restaurant_id, name, borough e cuisine per tutti i ristoranti il cui nome inizia con 'Wil'
// restaurants.find({name: /^Wil/}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })
