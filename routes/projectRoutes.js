const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');

router.post('/add', projectController.addProject);
router.put('/update', projectController.updateProject);
router.delete('/delete/:title', projectController.deleteProjectByTitle);
router.get('/read', projectController.readProject);

router.put('/update-status/:projectName', projectController.updateProjectToCompleted);

module.exports = router;
