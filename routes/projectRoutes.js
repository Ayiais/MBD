const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');

router.post('/add', projectController.addProject);
router.put('/update', projectController.updateProject);
router.delete('/delete/:title', projectController.deleteProjectByTitle);

module.exports = router;
