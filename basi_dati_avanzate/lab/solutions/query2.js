// display more
config.set('displayBatchSize', 30)

use("study")

let r = db.restaurants
let s = db.student
let g = db.games
let n = db.nba2016players

// 23. Restituire (in campi separati) l’anno, il mese ed il giorno di ogni partita
g.aggregate([{
    $project: {
        year: { "$year": "$date" },
        month: { "$month": "$date" },
        day: { "$dayOfMonth": "$date" },
    },
}])

// 24. Restituire un campo che indichi quanti anni fa è stata disputata ciascuna partita (sottrarre l’anno di new Date() dall’anno della partita)
g.aggregate([{
    $project: {
        yearsAgo: { "$subtract": [{ "$year": new Date() }, { "$year": "$date" }] }
    }
}])

// 25. Restituire l’anno, il mese ed il giorno di ogni partita e i nomi delle 2 squadre
g.aggregate([{
    $project: {
        date: { $dateToString: { format: "%d/%m/%Y", date: "$date" } },
        team1: { $arrayElemAt: ["$teams.name", 0] },
        team2: { $arrayElemAt: ["$teams.name", 1] },
    },
}
])

// 26. Restituire, per ogni partita: i due team, il rispettivi punti e la differenza tra i punteggi delle due squadre
g.aggregate([{
    $project: {
        team1_name: { $arrayElemAt: ["$teams.name", 0] },
        team2_name: { $arrayElemAt: ["$teams.name", 1] },
        team1_score: { $arrayElemAt: ["$teams.score", 0] },
        team2_score: { $arrayElemAt: ["$teams.score", 1] },
        score_differential: {
            $subtract: [
                { $arrayElemAt: ["$teams.score", 0] },
                { $arrayElemAt: ["$teams.score", 1] },
            ]
        },
    }
}])

// 27. Data la query precedente, filtrare solo le partite in cui la differenza è di un unico punto e in cui ha vinto la squadra di casa (la squadra che ha vinto è il team0)
g.aggregate([{
    $project: {
        team1_name: { $arrayElemAt: ["$teams.name", 0] },
        team2_name: { $arrayElemAt: ["$teams.name", 1] },
        team1_score: { $arrayElemAt: ["$teams.score", 0] },
        team2_score: { $arrayElemAt: ["$teams.score", 1] },
        team1_home: { $arrayElemAt: ["$teams.home", 0] },
        score_differential: {
            $subtract: [
                { $arrayElemAt: ["$teams.score", 0] },
                { $arrayElemAt: ["$teams.score", 1] },
            ]
        },
    }
}, {
    $match: {
        score_differential: 1,
        team1_home: true,
    }
}])
