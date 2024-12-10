const express = require('express');
const router = express.Router();
const penawaranController = require('../controllers/penawaranController');

router.post('/add', penawaranController.addPenawaran);
router.delete('/delete/:projectTitle', penawaranController.deletePenawaranByProject);
router.post('/accept/:projectTitle', penawaranController.acceptPenawaranByProject);
router.get('/all', penawaranController.readAllPenawaran);

module.exports = router;
