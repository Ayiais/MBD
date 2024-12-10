const projectModel = require('../models/functionModel');

module.exports = {
    getAverageRating: async (req, res) => {
        try {
            const { projectTitle } = req.params;
            const result = await projectModel.getAverageRating(projectTitle);
            res.status(200).json({ averageRating: result.average_rating });
        } catch (error) {
            res.status(500).json({ message: 'Error fetching average rating', error });
        }
    },

    getPaymentStatus: async (req, res) => {
        try {
            const { projectTitle } = req.params;
            const result = await projectModel.getPaymentStatus(projectTitle);
            res.status(200).json({ paymentStatus: result.payment_status });
        } catch (error) {
            res.status(500).json({ message: 'Error fetching payment status', error });
        }
    },

    getTotalPayment: async (req, res) => {
        try {
            const { projectTitle } = req.params;
            const result = await projectModel.getTotalPayment(projectTitle);
            res.status(200).json({ totalPayment: result.total_pembayaran });
        } catch (error) {
            res.status(500).json({ message: 'Error fetching total payment', error });
        }
    },

    getOfferStatus: async (req, res) => {
        try {
            const { projectTitle } = req.params;
            const result = await projectModel.getOfferStatus(projectTitle);
            res.status(200).json({ offerStatus: result.status_penawaran_terkini });
        } catch (error) {
            res.status(500).json({ message: 'Error fetching offer status', error });
        }
    }
};
