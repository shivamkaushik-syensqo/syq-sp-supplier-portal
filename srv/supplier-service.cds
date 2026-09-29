using sup from '../db/supplier';

@path: '/api/supplier'
service SupplierPortalService @(requires: 'authenticated-user') { // TODO: restore 'authenticated-user' after testing

  // ── Supplier master ────────────────────────────────────────────
  @readonly entity Suppliers              as projection on sup.Supplier;
  @readonly entity SupplierAddresses      as projection on sup.SupplierAddress;
  @readonly entity SupplierBanks          as projection on sup.SupplierBank;
  @readonly entity SupplierCompanies      as projection on sup.SupplierCompany;

  // ── Bidder ─────────────────────────────────────────────────────
  @readonly entity Bidders                as projection on sup.Bidder;
  @readonly entity BidderAddresses        as projection on sup.BidderAddress;

  // ── Purchase orders ────────────────────────────────────────────
  @readonly entity PurchaseOrders         as projection on sup.PurchaseOrder;
  @readonly entity PurchaseOrderItems     as projection on sup.PurchaseOrderItem;
  @readonly entity PurchaseOrderScheduleLines as projection on sup.PurchaseOrderScheduleLine;
  @readonly entity PurOrdSupplierConfirmations as projection on sup.PurOrdSupplierConfirmation;

  // ── Goods receipts & invoices ──────────────────────────────────
  @readonly entity SupplierInvoices       as projection on sup.SupplierInvoice;
  @readonly entity SupplierInvoiceItems   as projection on sup.SupplierInvoiceItem;
  @readonly entity SupplierInvoicePayments as projection on sup.SupplierInvoicePayment;
}
