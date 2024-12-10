const express = require('express');
const router = express.Router();
const projectController = require('../controllers/functionController');

// Define routes for project functionalities
router.get('/average-rating/:projectTitle', projectController.getAverageRating);
router.get('/payment-status/:projectTitle', projectController.getPaymentStatus);
router.get('/total-payment/:projectTitle', projectController.getTotalPayment);
router.get('/offer-status/:projectTitle', projectController.getOfferStatus);

module.exports = router;
