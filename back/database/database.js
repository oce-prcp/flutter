const Sequelize = require('sequelize')
require('dotenv').config()

const sequelize = new Sequelize(process.env.DBDATABASE, process.env.DBUSER, process.env.DBPASSWORD, {
    host: process.env.DBHOST,
    dialect: 'mariadb'
})

// tester la connexion
sequelize.authenticate().then(()=>{
    console.log('success')
}).catch((err)=>{
    console.log(err);
})

module.exports = sequelize