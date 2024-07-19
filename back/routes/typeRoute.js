const express = require('express');
const route = express.Router(); 
const typeController = require('../controllers/typeController');

route.get('/all', typeController.allType);
route.get('/:id', typeController.getTypeById); 

module.exports = route;