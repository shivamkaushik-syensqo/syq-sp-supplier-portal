# Supplier Overview Portal

A CAP application that consumes replicated supplier data from the **syq-sp-database-artifacts-cap** project via HANA cross-container synonyms.

## Architecture

```
syq-sp-database-artifacts-cap          supplier-overview-portal
┌──────────────────────────┐           ┌──────────────────────────┐
│  VT_SUP_*  (virtual)     │           │                          │
│       ↓                  │           │  CDS entities            │
│  RT_SUP_*  (replicated)  │──synonym──│  → hdbsynonym → RT_SUP_* │
│       ↑                  │           │  → CDS service (OData)   │
│  RemoteSubscription_*    │           │                          │
└──────────────────────────┘           └──────────────────────────┘
     HDI container A                        HDI container B
     (grantor service)                     (consumer)
```

## Tables consumed (16)

| Synonym | Source RT_ Table |
|---------|-----------------|
| RT_SUP_Supplier | Supplier master |
| RT_SUP_SupplierAddress | Supplier addresses |
| RT_SUP_SupplierBank | Supplier bank details |
| RT_SUP_SupplierCompany | Supplier company codes |
| RT_SUP_Bidder | Bidder master |
| RT_SUP_BidderAddress | Bidder addresses |
| RT_SUP_PurchaseOrder | PO headers |
| RT_SUP_PurchaseOrderItem | PO line items |
| RT_SUP_PurchaseOrderScheduleLine | PO schedule lines |
| RT_SUP_PurchaseOrderStatus | PO statuses |
| RT_SUP_PurchaseOrderHistory | PO history |
| RT_SUP_PurOrdSupplierConfirmation | Supplier confirmations |
| RT_SUP_SupplierGoodsReceipt | Goods receipts |
| RT_SUP_SupplierInvoice | Invoice headers |
| RT_SUP_SupplierInvoiceItem | Invoice items |
| RT_SUP_SupplierInvoicePayment | Invoice payments |

## Prerequisites

1. **syq-sp-database-artifacts-cap** must be deployed first (creates the RT_ tables and the grantor service `syq-sp-database-cap-grantor`).
2. The `external_access` role in the source project must be deployed (grants SELECT on RT_ tables).

## Local Development

```bash
npm install
cds watch
```

> Note: Cross-container synonyms only work on HANA. For local testing with SQLite, mock data in `test/data/` can be used.

## Deployment

```bash
mbt build
cf deploy mta_archives/supplier-overview-portal_1.0.0.mtar
```
