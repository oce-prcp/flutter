const express = require('express')
const route = express.Router()
const typeController = require('../controllers/typeController')

route.get('/all', typeController.allType)

module.exports = route