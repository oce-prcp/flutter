const express = require('express');
const router = express.Router();
const multer = require('multer');
const loisirController = require('../controllers/loisirController');

const MIME_TYPES = {
   'image/jpg': 'jpg',
   'image/jpeg': 'jpg',
   'image/png': 'png',
};

const storage = multer.diskStorage({
   destination: (req, file, cb) => {
      cb(null, 'images/');
   },
   filename: (req, file, cb) => {
      const name = file.originalname.split(' ').join('_');
      const extension = MIME_TYPES[file.mimetype];
      cb(null, name + Date.now() + '.' + extension);
   },
});

const upload = multer({ storage: storage });

// Routes existantes
router.post('/create', upload.single('image'), loisirController.createLoisir);
router.put('/update/:id', upload.single('image'), loisirController.updateLoisir);
router.get('/all', loisirController.AllLoisirs);
router.get('/getByType/:id', loisirController.LoisirsByTypeId);
router.get('/top', loisirController.TopLoisir);
router.get('/:id', loisirController.LoisirId);
router.delete('/:id', loisirController.DeleteLoisir);

module.exports = router;
