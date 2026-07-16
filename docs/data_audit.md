# Data Audit Report

## Project

**Olist E-Commerce Intelligence**

---

# 1. Purpose

This document presents the results of the initial data audit performed on the raw Olist Brazilian E-Commerce dataset before any transformations were applied.

The objective of this audit is to understand the quality, completeness, and structure of the source data entering the analytics platform. The findings from this assessment directly informed the design of the dbt staging models and the downstream Medallion Architecture.

This report documents:

* Dataset inventory
* Schema validation
* Row and column statistics
* Missing value analysis
* Data type profiling
* Data quality observations
* Cleaning actions implemented during the staging layer
* Comparison between the raw source data and the standardized staging layer

The audit focuses only on factual observations derived from the source datasets and implemented transformations. It intentionally excludes business insights and analytical findings, which are documented separately.

---

# 2. Audit Scope

The audit covers every raw dataset ingested into the Bronze layer of the Databricks Lakehouse.

All datasets were profiled before any transformations, joins, aggregations, or business rules were applied.

## Data Source

| Attribute | Value |
|----------|-------|
| Dataset | Olist Brazilian E-Commerce Public Dataset |
| Source | Kaggle |
| Format | CSV |
| Number of Source Tables | 9 |
| Storage Layer | Databricks Unity Catalog Bronze Schema |
| Profiling Tool | DuckDB |
| Transformation Framework | dbt Core |
| Target Platform | Databricks |

---

# 3. Audit Methodology

Each raw dataset was profiled using DuckDB prior to ingestion into the analytical warehouse.

The profiling process collected the following metadata for every table.

* Total row count
* Total column count
* Data types
* Distinct values
* Null counts
* Null percentage
* Column cardinality

No source records were modified during profiling.

The resulting statistics established the baseline data quality prior to implementation of the staging layer.

---

# 4. Dataset Inventory

The Bronze layer contains nine operational datasets representing customers, sellers, products, orders, logistics, reviews, payments, geolocation, and product category translations.

| Dataset | Rows | Columns |
|----------|-----:|--------:|
| olist_customers_dataset | 99,441 | 5 |
| olist_geolocation_dataset | 1,000,163 | 5 |
| olist_orders_dataset | 99,441 | 8 |
| olist_order_items_dataset | 112,650 | 7 |
| olist_order_payments_dataset | 103,886 | 5 |
| olist_order_reviews_dataset | 99,224 | 7 |
| olist_products_dataset | 32,951 | 9 |
| olist_sellers_dataset | 3,095 | 4 |
| product_category_name_translation | 71 | 2 |

Total datasets audited: **9**

---

# 5. Dataset Summary

The source data contains transactional records representing an end to end Brazilian marketplace ecosystem.

The datasets naturally separate into four categories.

| Category | Tables |
|----------|--------|
| Master Data | Customers, Sellers, Products |
| Transactions | Orders, Order Items, Payments |
| Customer Experience | Reviews |
| Reference Data | Geolocation, Category Translation |

The largest dataset is the geolocation reference table containing more than one million records.

The smallest dataset is the product category translation lookup containing 71 rows.

---

# 6. Schema Validation

All source tables were successfully read using DuckDB without schema conflicts.

The inferred data types aligned with the expected business entities.

Observed data types include:

* VARCHAR
* BIGINT
* DOUBLE
* TIMESTAMP

No unsupported or malformed data types were detected during profiling.

No corrupted CSV files were encountered.

---

# 7. Master Data Profiling Matrix

Rather than evaluating datasets in isolation, the operational source layers were profiled to map out warehouse volume and identify systemic missing values. 

| Dataset | Total Rows | Primary Identifier | Primary Ingestion Quality Flag & Null % |
|:---|---:|:---|:---|
| `olist_customers_dataset` | 99,441 | `customer_id` | 100% Complete; `customer_unique_id` tracks repeat buyers. |
| `olist_sellers_dataset` | 3,095 | `seller_id` | 100% Complete geographic distribution. |
| `olist_products_dataset` | 32,951 | `product_id` | 1.85% nulls across category and physical dimension fields. |
| `olist_orders_dataset` | 99,441 | `order_id` | Null operational milestones (`order_delivered_customer_date` is 2.98% null). |
| `olist_order_items_dataset` | 112,650 | Composite | Multi-item fan-out ledger; lacks single-column PK. |
| `olist_order_payments_dataset`| 103,886 | None | Multi-method transaction log; lacks single-column PK. |
| `olist_order_reviews_dataset` | 99,224 | `review_id` | High text sparsity (88.34% null titles); numeric scores 100% complete. |
| `olist_geolocation_dataset` | 1,000,163 | None | High-density coordinates; requires spatial deduplication. |
| `product_category_name_translation`| 71 | `product_category_name`| 100% Complete mapping index. |

---

# 8. Quality Vulnerabilities & Staging Resolutions

The raw Bronze tables remain completely immutable. The staging layer applies targeted SQL adjustments to address the structural anomalies and fan-out risks discovered during the profiling phase.

| Raw Target Dataset | Identified Quality Risk | dbt Staging Resolution Action |
|:---|:---|:---|
| **Geolocation** | Duplicate ZIP rows creating massive 1-to-many fan-out risk. | Groups records by `zip_code` and extracts the `AVG()` latitude/longitude. |
| **Products** | Missing categories (1.85%) breaking downstream joins. | Implements `COALESCE(product_category_name, 'unknown')` to prevent orphan records. |
| **Order Items** | Missing single primary key for line items. | Generates an MD5 surrogate hash (`order_item_key`) from `order_id` + `order_item_id`. |
| **Order Items** | Fragmented financial values. | Automatically calculates `total_item_value` via `price + freight_value`. |
| **Orders** | Cryptic operational status and raw timestamp names. | Adds boolean `is_delivered` flag and standardizes logistics columns using `_at` suffix. |
| **Categories** | Portuguese-only descriptions. | Prepares standardized columns for downstream English translation lookup. |

---

# 9. Audit Summary

The raw Olist datasets were profiled before any transformations were implemented.

The audit produced the following findings:

* Nine source datasets were successfully profiled.
* Customer, seller, payment, and translation datasets contain no missing values.
* Order logistics timestamps contain expected operational nulls associated with non-delivered orders.
* Product data contains a small percentage of missing category information.
* Review text fields contain a high proportion of missing values, while review scores remain complete.
* The geolocation dataset contains duplicate ZIP code records that require aggregation before analytical use.
* The order items dataset requires a generated surrogate key because no single-column primary key exists.

The staging layer addresses structural consistency issues while intentionally preserving the original business meaning of the source data.

No analytical aggregations or business metrics are introduced during this phase.

---

# 10. Audit Limitations

This audit focuses exclusively on the raw source datasets and the transformations implemented within the staging layer.

The following areas are outside the scope of this report:

* Business logic implemented within the Silver dimensional models.
* KPI calculations implemented in the Gold marts.
* Dashboard-level calculations.
* Performance benchmarking of Databricks SQL Warehouse.
* Airflow orchestration monitoring.
* dbt test execution results.

These components are documented separately within the project documentation.

---

# 11. Conclusion

The data audit confirms that the Olist source datasets are generally suitable for analytical processing.

The majority of identified data quality issues are expected characteristics of operational e-commerce systems rather than data corruption.

The staging layer introduces only the transformations required to standardize schemas, improve consistency, resolve structural issues, and prepare the data for dimensional modeling.

This approach aligns with Medallion Architecture principles by keeping the Bronze-to-Staging transformation lightweight while reserving business logic and analytical calculations for the Silver and Gold layers.