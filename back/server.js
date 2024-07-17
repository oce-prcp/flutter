const express = require('express')
const cors = require ('cors')

const databaseRoute = require('./routes/databaseRoute')
const loisirRoute = require('./routes/loisirRoute')
const typeRoute = require('./routes/typeRoute')
const app = express()

app.use(express.json())
app.use(cors())

app.use('/database', databaseRoute)
app.use('/loisir', loisirRoute)
app.use('/type', typeRoute)


app.listen(8000, ()=>{
    console.log("serveur lancé sur le port 8000");
})


