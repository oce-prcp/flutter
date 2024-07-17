const sequelize = require('../database/database')
const { DataTypes } = require('sequelize')

const Loisir = sequelize.define('loisir', {
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
    },
    nom:{
        type: DataTypes.STRING,
        unique: true,
        allowNull: false
    },
    description: {
        type: DataTypes.STRING,
        allowNull: false
    },
    notation: {
        type: DataTypes.FLOAT,
        allowNull: false
    },
    dateSortie: {
        type: DataTypes.DATE,
        allowNull: false
    },
    imagePath: {
        type: DataTypes.STRING,
        allowNull: true
    }
},{
    freezeTableName: true
})
 
module.exports = Loisir