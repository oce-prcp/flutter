const Type = require('../models/typeModel')

exports.allType= async(req, res)=>{
    const type = await Type.findAll()
    res.status(200).json(type)
}