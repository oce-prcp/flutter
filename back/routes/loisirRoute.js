const express = require('express')
const route = express.Router()
const loisirController = require('../controllers/loisirController')

route.post('/create', loisirController.CreateLoisir)
route.put('/update/:id', loisirController.UpdateLoisir)
route.get('/all', loisirController.AllLoisirs)
route.get('/:id', loisirController.LoisirId)
route.delete('/:id', loisirController.DeleteLoisir)

module.exports = route