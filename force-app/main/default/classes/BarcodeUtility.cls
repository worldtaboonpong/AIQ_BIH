public with sharing class BarcodeUtility {

    /**
     * Generates a barcode based on the appointment ID.
     * This is a simple implementation where the barcode is just a base64 encoded version of the ID.
     */
    public static String generateBarcode(Id appointmentId) {
        // Simulate barcode generation by encoding the appointment ID
        return EncodingUtil.base64Encode(Blob.valueOf(appointmentId));
    }
}