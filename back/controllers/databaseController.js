const sequelize = require('../database/database')
const type = require('../models/typeModel');

exports.createAllTable = async(req, res)=>{
    await sequelize.sync({ alter: true})
    res.status(200).json('toutes les tables on été créées')
}
