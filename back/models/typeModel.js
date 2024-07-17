const sequelize = require('../database/database');
const { DataTypes } = require('sequelize');

const Loisir = require('./loisirModel');
 
const Type = sequelize.define('type', {
    id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true
      },
    nom: {
        type: DataTypes.STRING,
        unique: true,
        allowNull: false
    },
    description: {
        type: DataTypes.STRING,
        allowNull: false
    },
}, {
    sequelize,
    freezeTableName: true
  });
 

  //RELATION ICI
 Type.hasMany(Loisir, { foreignKey: 'typeId'})
 Loisir.belongsTo(Type, { foreignKey: 'typeId'})
 
module.exports = Type;