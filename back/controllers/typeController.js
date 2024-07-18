const Type = require('../models/typeModel')

exports.allType= async(req, res)=>{
    const type = await Type.findAll()
    res.status(200).json(type)
}

exports.getTypeById = async (req, res) => {
    const typeId = req.params.id; 
    try {
      const type = await Type.findByPk(typeId);
      if (!type) {
        return res.status(404).json({ error: 'Type not found' });
      }
      res.status(200).json(type);
    } catch (error) {
      console.error('Error fetching type by id:', error);
      res.status(500).json({ error: 'Failed to fetch type' });
    }
  };