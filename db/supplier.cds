namespace sup;

/**
 * Supplier master data – replicated from syq-sp-database-artifacts-cap
 * via cross-container HANA synonyms pointing at RT_ tables.
 *
 * @cds.persistence.exists – CDS does not create/manage these objects in HANA.
 * @cds.persistence.table  – points directly at the hdbsynonym name (SUP_*),
 *                           so generated hdbviews reference the synonym, not
 *                           the CDS-internal namespace-prefixed name.
 */

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIER'
entity Supplier {
  key BusinessPartner : String(10);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERADDRESS'
entity SupplierAddress {
  key BusinessPartner : String(10);
  key AddressNumber   : String(10);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERBANK'
entity SupplierBank {
  key Supplier    : String(10);
  key BankCountry : String(3);
  key BankAccount : String(18);
  key Bank        : String(15);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERCOMPANY'
entity SupplierCompany {
  key Supplier    : String(10);
  key CompanyCode : String(4);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_BIDDER'
entity Bidder {
  key BusinessPartner : String(10);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_BIDDERADDRESS'
entity BidderAddress {
  key BusinessPartner : String(10);
  key AddressNumber   : String(10);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_PURCHASEORDER'
entity PurchaseOrder {
  key PurchaseOrder : String(10);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_PURCHASEORDERITEM'
entity PurchaseOrderItem {
  key PurchaseOrder     : String(10);
  key PurchaseOrderItem : String(5);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_PURCHASEORDERSCHEDULELINE'
entity PurchaseOrderScheduleLine {
  key PurchaseOrder             : String(10);
  key PurchaseOrderItem         : String(5);
  key PurchaseOrderScheduleLine : String(4);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_PURORDSUPPLIERCONFIRMATION'
entity PurOrdSupplierConfirmation {
  key PurchaseOrder             : String(10);
  key PurchaseOrderItem         : String(5);
  key SequentialNmbrOfSuplrConf : String(4);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERINVOICE'
entity SupplierInvoice {
  key SupplierInvoice : String(10);
  key FiscalYear      : String(4);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERINVOICEITEM'
entity SupplierInvoiceItem {
  key SupplierInvoice     : String(10);
  key SupplierInvoiceItem : String(4);
  key FiscalYear          : String(4);
}

@cds.persistence.exists @cds.persistence.table: 'SUP_SUPPLIERINVOICEPAYMENT'
entity SupplierInvoicePayment {
  key CompanyCode            : String(4);
  key AccountingDocument     : String(10);
  key FiscalYear             : String(4);
  key AccountingDocumentItem : String(3);
}
