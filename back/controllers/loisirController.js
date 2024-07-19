const Loisir = require('../models/loisirModel')

exports.createLoisir = async (req, res) => {
   const { nom, description, dateSortie, notation, typeId } = req.body;
   const imagePath = req.file ? `images/${req.file.filename}` : null;

   try {
      const loisir = await Loisir.create({
         nom,
         description,
         dateSortie,
         notation,
         typeId,
         imagePath,
      });
      res.status(201).json(loisir);
   } catch (error) {
      res.status(500).json({ error: error.message });
   }
};

exports.updateLoisir = async (req, res) => {
   const { nom, description, dateSortie, notation, typeId } = req.body;
   const imagePath = req.file ? `images/${req.file.filename}` : req.body.imagePath;

   try {
      const loisir = await Loisir.update(
         { nom, description, dateSortie, notation, typeId, imagePath },
         { where: { id: req.params.id } }
      );
      res.status(200).json(loisir);
   } catch (error) {
      res.status(500).json({ error: error.message });
   }
};


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