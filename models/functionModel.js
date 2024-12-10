const db = require('../config/db'); // Sesuaikan dengan konfigurasi database Anda

module.exports = {
    getAverageRating: async (projectTitle) => {
        const [rows] = await db.execute('CALL get_average_rating_procedure(?)', [projectTitle]);
        return rows[0]; // Hasil rata-rata rating
    },

    getPaymentStatus: async (projectTitle) => {
        const [rows] = await db.execute('CALL check_payment_status_procedure(?)', [projectTitle]);
        return rows[0]; // Status pembayaran
    },

    getTotalPayment: async (projectTitle) => {
        const [rows] = await db.execute('CALL get_project_total_payment(?)', [projectTitle]);
        return rows[0]; // Total pembayaran
    },

    getOfferStatus: async (projectTitle) => {
        const [rows] = await db.execute('CALL get_current_offer_status(?)', [projectTitle]);
        return rows[0]; // Status penawaran
    }
};
