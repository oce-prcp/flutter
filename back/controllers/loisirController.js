const { describe } = require('node:test')
const Loisir = require('models/loisirModel')

exports.CreateLoisir = async(req,res)=>{
    let loisir = req.body
    let result = await Loisir.create(loisir)
    result.save()
    res.status(201).json(result.nom)
}

exports.UpdateLoisir = async(req, res)=>{
    let idP = parseInt(req.params.id)
    let UpdateLoisir = req.body
    
    let loisir = await Loisir.update(
        {
            typeId: UpdateLoisir.id,
            nom: UpdateLoisir.nom,
            description: UpdateLoisir.description,
            notation: UpdateLoisir.notation,
            dateSortie: UpdateLoisir.dateSortie,
            imagePath: UpdateLoisir.imagePath,
        },
        {
        where: {
            id: idP
        }
    })
    res.status(200).json(loisir)
}

exports.AllLoisirs= async(req, res)=>{
    const loisir = await Loisir.findAll({
        order: [['notation', 'DESC']],
    })
    res.status(200).json(loisir)
}

exports.LoisirId= async(req, res)=>{
    const loisir = await Loisir.findByPk(parseInt(req.params.id))
    res.status(200).json(loisir)
}

exports.DeleteLoisir= async(req, res) => {
    const id = req.params.id;
    const result = await Loisir.destroy({
        where: {
            id: id
        }
    })
    res.status(200).json({ message : "Success" })
}

exports.TopLoisir= async(req, res)=>{
    const loisir = await Loisir.findOne({
        order: [['notation', 'DESC']],
    })
    res.status(200).json(loisir)
}


exports.LoisirsByTypeId= async(req, res)=>{
    const typeId = parseInt(req.params.id); 
    const loisir = await Loisir.findAll({
        order: [['notation', 'DESC']],
        where: {
            typeId : typeId
        }
    })
    res.status(200).json(loisir)
}