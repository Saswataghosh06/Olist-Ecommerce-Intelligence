# Data Quality Report

## Project

**Olist E Commerce Intelligence**

---

# 1. Introduction

## Purpose

This document describes the data quality framework implemented within the Olist E Commerce Intelligence project.

Its objective is to demonstrate how raw operational data is transformed into trusted analytical datasets through standardized data validation, cleansing, integrity checks, and automated dbt testing.

Rather than modifying the original source data, quality improvements are progressively introduced throughout the Medallion Architecture.

The report documents only the data quality controls that are implemented within this repository.

---

## Scope

This report covers the following areas.

* Raw source data quality observations
* Data quality controls applied during the staging layer
* Data integrity validation within the dimensional models
* Automated dbt tests
* Referential integrity enforcement
* Business rule validation
* Overall quality assessment

---

## Architecture Context

Data quality is enforced incrementally throughout the Medallion Architecture.

```
Raw CSV Files
        │
        ▼
Bronze Layer
(Raw Source Tables)
        │
        ▼
Staging Layer
(Standardization & Basic Cleaning)
        │
        ▼
Intermediate Layer
(Dimensions & Facts)
        │
        ▼
Gold Layer
(Business Marts)
```

Each layer has a different responsibility for maintaining data quality.

| Layer | Primary Responsibility |
|---------|------------------------|
| Bronze | Preserve raw source data exactly as received. |
| Staging | Standardize schemas and perform lightweight data cleaning. |
| Intermediate | Build conformed dimensions and fact tables while enforcing relationships. |
| Gold | Deliver trusted analytical datasets for reporting and business intelligence. |

---

# 2. Data Quality Framework

The project follows a layered approach to data quality rather than attempting to clean all issues in a single transformation.

Each layer is responsible for improving specific aspects of the data.

| Layer | Quality Objective |
|---------|------------------|
| Bronze | Maintain raw historical data without modification. |
| Staging | Improve consistency and usability while preserving business grain. |
| Intermediate | Build trusted analytical entities with referential integrity. |
| Gold | Deliver reliable business metrics and reporting datasets. |

This separation keeps raw operational data available for traceability while ensuring downstream models consume standardized and validated information.

---

# 3. Data Quality Dimensions

The project focuses on the following quality dimensions.

| Quality Dimension | Description | Implemented |
|-------------------|-------------|-------------|
| Completeness | Required business attributes should be available whenever expected. | ✓ |
| Uniqueness | Primary keys should uniquely identify each business entity. | ✓ |
| Consistency | Standardized naming conventions and data formats are applied across models. | ✓ |
| Referential Integrity | Fact tables reference valid dimension records through foreign key relationships. | ✓ |
| Validity | Business values are validated using accepted value tests. | ✓ |
| Accuracy | Geographic duplication and missing product categories are handled during staging. | ✓ |

No automated freshness monitoring or anomaly detection has been implemented within this project.

---

# 4. Quality Principles

The project follows several design principles for maintaining analytical data quality.

## Preserve Source Data

Raw datasets remain unchanged after ingestion into the Bronze layer.

No source records are modified or deleted.

---

## Lightweight Staging

The staging layer performs only structural improvements.

Examples include:

* Column renaming
* Data type standardization
* Null handling
* Surrogate key generation
* Translation preparation
* Geographic deduplication

Business calculations are intentionally excluded from this layer.

---

## Dimensional Integrity

The Intermediate layer constructs conformed dimensions and fact tables.

Relationships between entities are validated using dbt relationship tests.

---

## Automated Validation

dbt tests are executed during pipeline execution to verify that critical business rules continue to hold after each transformation.

This allows data quality issues to be detected before downstream reporting models are refreshed.

# 5. Source Data Quality Assessment

Before implementing any transformations, all raw source datasets were profiled to evaluate their structural quality.

The profiling process measured:

* Total row count
* Data types
* Null values
* Null percentage
* Distinct values

This assessment established the baseline quality of the raw Olist datasets before they entered the Medallion Architecture.

---

# 5.1 Dataset Summary

| Dataset | Rows | Overall Assessment |
|----------|-----:|-------------------|
| olist_customers_dataset | 99,441 | Excellent |
| olist_geolocation_dataset | 1,000,163 | Requires geographic deduplication |
| olist_orders_dataset | 99,441 | Good |
| olist_order_items_dataset | 112,650 | Excellent |
| olist_order_payments_dataset | 103,886 | Excellent |
| olist_order_reviews_dataset | 99,224 | Good |
| olist_products_dataset | 32,951 | Good |
| olist_sellers_dataset | 3,095 | Excellent |
| product_category_name_translation | 71 | Excellent |

---

# 5.2 Identified Source Data Issues

The raw profiling identified several expected operational data quality issues.

| Dataset | Issue | Business Impact |
|----------|-------|-----------------|
| Orders | Missing delivery timestamps | Expected for cancelled or in-transit orders |
| Products | Missing product categories | Prevents category-based reporting if not handled |
| Reviews | Missing review titles | Optional customer input |
| Reviews | Missing review messages | Optional customer input |
| Geolocation | Multiple coordinate records for the same ZIP code | Creates one-to-many joins unless deduplicated |

No critical corruption of the source datasets was identified.

---

# 5.3 Completeness Assessment

## Customer Dataset

The customer master data is complete.

| Column | Null % |
|---------|-------:|
| customer_id | 0.00% |
| customer_unique_id | 0.00% |
| customer_zip_code_prefix | 0.00% |
| customer_city | 0.00% |
| customer_state | 0.00% |

Assessment

* Complete customer master data.
* No mandatory business attributes are missing.

---

## Orders Dataset

The orders dataset contains expected operational null values.

| Column | Null % |
|---------|-------:|
| order_id | 0.00% |
| customer_id | 0.00% |
| order_status | 0.00% |
| order_purchase_timestamp | 0.00% |
| order_approved_at | 0.16% |
| order_delivered_carrier_date | 1.79% |
| order_delivered_customer_date | 2.98% |
| order_estimated_delivery_date | 0.00% |

Assessment

The missing logistics timestamps are consistent with the operational lifecycle of orders that were cancelled, unavailable, or had not yet completed delivery.

These values are preserved and are not artificially populated.

---

## Products Dataset

The products dataset contains a small percentage of missing category information.

| Column | Null % |
|---------|-------:|
| product_category_name | 1.85% |
| product_name_lenght | 1.85% |
| product_description_lenght | 1.85% |
| product_photos_qty | 1.85% |
| product_weight_g | 0.01% |
| product_length_cm | 0.01% |
| product_height_cm | 0.01% |
| product_width_cm | 0.01% |

Assessment

Missing product categories are handled in the staging layer using:

```sql
COALESCE(product_category_name, 'unknown')
```

This ensures downstream dimensional models always contain a valid category value.

---

## Reviews Dataset

Customer review scores are complete, while free-text review fields are largely optional.

| Column | Null % |
|---------|-------:|
| review_score | 0.00% |
| review_comment_title | 88.34% |
| review_comment_message | 58.70% |

Assessment

The high percentage of missing review titles and review messages is expected because customers are not required to provide written feedback.

The numerical review score remains available for analytical reporting.

---

# 6. Staging Layer Quality Controls

The staging layer performs lightweight quality improvements while preserving the original business grain.

No analytical aggregations or business metrics are introduced during this stage.

---

## 6.1 Column Standardization

Raw source columns are renamed using consistent business-friendly naming conventions.

Examples include:

| Raw Column | Standardized Column |
|------------|--------------------|
| customer_zip_code_prefix | zip_code |
| seller_city | city |
| seller_state | state |
| shipping_limit_date | shipping_limit_at |
| order_purchase_timestamp | order_purchase_at |
| order_delivered_customer_date | order_delivered_to_customer_at |

This improves readability while maintaining traceability to the original source data.

---

## 6.2 Null Handling

The only explicit null replacement implemented within the staging layer occurs in the product dataset.

| Model | Implementation |
|--------|----------------|
| stg_products | `COALESCE(product_category_name, 'unknown')` |

This ensures every product can be categorized during downstream reporting.

Other missing values remain unchanged to preserve the integrity of the source data.

---

## 6.3 Surrogate Key Generation

The raw order items dataset does not contain a single-column primary key.

The staging layer generates a surrogate key.

| Model | Generated Key |
|--------|---------------|
| stg_order_items | order_item_key |

The surrogate key is created from the combination of:

* order_id
* order_item_id

This guarantees uniqueness for every order line item.

---

## 6.4 Geographic Deduplication

The raw geolocation dataset contains multiple coordinate records for the same ZIP code.

The staging model aggregates these records into a single representative location by calculating the average latitude and longitude for each ZIP code.

This prevents one-to-many joins when enriching customer and seller dimensions with geographic information.
# 7. Intermediate Layer Quality Controls

The Intermediate layer transforms standardized staging models into conformed dimensions and fact tables.

Unlike the staging layer, this layer introduces entity relationships, business structure, and referential integrity while maintaining the original transactional grain.

---

# 7.1 Dimension Integrity

Dimension tables provide standardized business entities that can be consistently referenced throughout the warehouse.

| Dimension | Primary Key | Quality Control |
|-----------|-------------|-----------------|
| dim_customers | customer_id | Unique customer records with geographic enrichment |
| dim_sellers | seller_id | Unique seller records with geographic enrichment |
| dim_products | product_id | English category translation and standardized product attributes |
| dim_date | date_day | Complete calendar generated using Spark SQL sequence |

Each dimension exposes a single business entity with one unique record per primary key.

---

# 7.2 Fact Table Integrity

Fact tables preserve transactional business events while referencing validated dimension records.

| Fact Table | Business Grain |
|------------|----------------|
| fct_orders | One row per order |
| fct_order_items | One row per purchased item |
| fct_payments | One row per payment transaction |

Each fact table maintains its transactional grain throughout the transformation process.

---

# 7.3 Referential Integrity

Relationships between dimensions and facts are validated using dbt relationship tests.

The following relationships are implemented.

| Parent Model | Child Model | Foreign Key |
|--------------|-------------|-------------|
| dim_customers | fct_orders | customer_id |
| fct_orders | fct_order_items | order_id |
| fct_orders | fct_payments | order_id |

These tests ensure that downstream analytical models cannot reference non-existent parent records.

---

# 8. Automated dbt Data Quality Tests

The pipeline integrates dbt's native verification framework directly into the execution lifecycle. A model deployment is blocked from committing to production if an explicit `error` threshold constraint is breached.

## 8.1 Test Coverage Matrix

Instead of checking data manually, tests are executed automatically via `dbt build`.

| Model Layer | Unique | Not Null | Relationships (FK) | Accepted Values | Test Failure Severity |
|:---|:---:|:---:|:---:|:---:|:---|
| **Staging Models** (`stg_*`) | ✓ | ✓ | | ✓ | **Hard Error** on generated PKs; **Warn** on optional fields (e.g. timestamps). |
| **Dimensions** (`dim_*`) | ✓ | ✓ | | | **Hard Error** on all dimension attributes. |
| **Fact Ledgers** (`fct_*`) | ✓ | ✓ | ✓ | | **Hard Error** on parent keys; **Warn** on missing operational dates. |
| **Business Marts** (`mart_*`) | ✓ | ✓ | | ✓ | **Hard Error** on customer segment boundaries. |

# 8.2 Unique Tests

Unique tests verify that every business entity has exactly one identifier.

| Model | Column |
|--------|--------|
| stg_orders | order_id |
| stg_order_items | order_item_key |
| stg_customers | customer_id |
| stg_products | product_id |
| stg_sellers | seller_id |
| stg_translations | category_name_portuguese |
| dim_customers | customer_id |
| dim_sellers | seller_id |
| dim_products | product_id |
| dim_date | date_day |
| fct_orders | order_id |
| fct_order_items | order_item_key |
| mart_seller_performance | seller_id |
| mart_customer_rfm | customer_id |

Business domains are validated using `accepted_values` tests to protect downstream dashboards from breaking due to unexpected string values:
* **Order Statuses (`stg_orders`):** Constrained to `delivered`, `shipped`, `canceled`, `unavailable`, `invoiced`, `processing`, `created`, and `approved`.
* **RFM Customer Segments (`mart_customer_rfm`):** Validated strictly against `Active Loyal`, `New Customer`, `Churning Loyal`, and `One-Off`.


These tests verify that duplicate business entities are not introduced during transformation.

---

# 8.3 Not Null Tests

Required business attributes are validated using `not_null` tests.

Examples include:

| Model | Column |
|--------|--------|
| stg_orders | order_id |
| stg_order_items | order_item_key |
| stg_order_items | order_id |
| stg_customers | customer_id |
| stg_products | product_id |
| stg_sellers | seller_id |
| stg_order_payments | order_id |
| stg_order_reviews | review_id |
| stg_geolocation | zip_code |
| stg_translations | category_name_portuguese |
| dim_customers | customer_id |
| dim_sellers | seller_id |
| dim_products | product_id |
| dim_date | date_day |
| fct_orders | order_id |
| fct_orders | customer_id |
| fct_order_items | order_item_key |
| fct_order_items | order_id |
| fct_payments | order_id |
| mart_logistics_performance | order_id |
| mart_seller_performance | seller_id |
| mart_customer_rfm | customer_id |

These tests ensure critical identifiers are always populated before downstream models are built.

---

# 8.4 Relationship Tests

Relationship tests verify foreign key integrity across the warehouse.

| Child Model | Foreign Key | Parent Model |
|-------------|-------------|--------------|
| fct_orders | customer_id | dim_customers |
| fct_order_items | order_id | fct_orders |
| fct_payments | order_id | fct_orders |

These validations help prevent orphaned analytical records.

---

# 8.5 Accepted Values Tests

Business domains are validated using `accepted_values` tests.

## Order Status

The staging orders model accepts only the following lifecycle states.

| Allowed Values |
|----------------|
| delivered |
| shipped |
| canceled |
| unavailable |
| invoiced |
| processing |
| created |
| approved |

This ensures unexpected operational statuses are detected during pipeline execution.

---

## Customer Segment

The Gold RFM mart validates customer segmentation outputs.

| Allowed Values |
|----------------|
| Active Loyal |
| New Customer |
| Churning Loyal |
| One-Off |

Only these four business-defined customer segments can be written to the analytical warehouse.

# 9. Business Rule Validation

Beyond structural validation, the project enforces several business rules during transformation to ensure analytical consistency.

These rules are implemented directly within the dbt models.

---

# 9.1 Delivery Status Classification

The staging orders model derives a boolean delivery indicator.

## Rule

```sql
CASE
    WHEN order_status = 'delivered' THEN TRUE
    ELSE FALSE
END
```

## Purpose

Provides a standardized delivery flag for downstream logistics analysis without repeatedly evaluating order status values.

---

# 9.2 Product Category Standardization

Missing product categories are replaced with a default value during staging.

## Rule

```sql
COALESCE(product_category_name, 'unknown')
```

## Purpose

Ensures every product belongs to a reporting category, preventing null values from propagating into the product dimension.

---

# 9.3 Product Category Translation

Portuguese category names are translated into English during dimensional modeling.

## Rule

A left join is performed between the standardized products dataset and the category translation lookup table.

If no translation exists, the value defaults to:

```
unknown
```

## Purpose

Provides business-friendly category names suitable for reporting while preserving the original Portuguese category.

---

# 9.4 Customer RFM Segmentation

Customer segments are derived using Recency, Frequency, and Monetary metrics.

Only delivered orders are included in the calculation.

The current date reference is determined dynamically from the latest purchase date contained in the dataset.

The resulting customer segments are validated using a dbt `accepted_values` test.

Allowed segments are:

* Active Loyal
* New Customer
* Churning Loyal
* One-Off

---

# 9.5 Late Delivery Identification

Late deliveries are identified within the logistics mart.

## Rule

```sql
order_delivered_to_customer_at >
order_estimated_delivery_at
```

If the condition evaluates to TRUE, the order is classified as a late delivery.

## Purpose

Provides a consistent SLA indicator for logistics reporting.

---

# 10. Data Quality Summary

The project implements multiple layers of quality validation throughout the Medallion Architecture.

| Quality Area | Implementation |
|---------------|----------------|
| Source Profiling | Raw datasets profiled before transformation |
| Column Standardization | Implemented across all staging models |
| Null Handling | Implemented where required (`stg_products`) |
| Surrogate Key Generation | Implemented in `stg_order_items` |
| Geographic Deduplication | Implemented in `stg_geolocation` |
| Translation Standardization | Implemented in `dim_products` |
| Derived Business Flags | `is_delivered`, `is_late_delivery` |
| Primary Key Validation | dbt `unique` tests |
| Mandatory Field Validation | dbt `not_null` tests |
| Referential Integrity | dbt `relationships` tests |
| Business Domain Validation | dbt `accepted_values` tests |

Together, these controls establish a consistent and reliable analytical foundation while preserving the integrity of the original operational data.

---

# 11. Known Data Limitations

Some characteristics of the source data are intentionally preserved because they represent valid operational scenarios rather than data quality defects.

| Observation | Reason |
|-------------|--------|
| Missing delivery timestamps | Orders may be cancelled, unavailable, or not yet delivered. |
| Missing review titles and messages | Written reviews are optional. |
| Multiple payment records per order | A single order can be paid using multiple payment methods or installments. |
| Multiple historical geolocation records | Resolved through ZIP code aggregation in the staging layer. |
| Missing product categories | Standardized as `unknown` during staging. |

These behaviors are expected characteristics of the Olist dataset and are handled where appropriate without altering the underlying business meaning.

---

# 12. Conclusion

The Olist E Commerce Intelligence project applies data quality controls progressively throughout the Medallion Architecture rather than concentrating all validation in a single processing stage.

Raw datasets are preserved in their original form within the Bronze layer. The Staging layer introduces structural standardization, lightweight cleansing, and schema consistency. The Intermediate layer constructs conformed dimensions and fact tables while enforcing referential integrity. Finally, the Gold layer delivers trusted business marts for reporting and analytical consumption.

Automated dbt tests validate primary keys, mandatory fields, foreign key relationships, and business domains as part of every pipeline execution. These validations help ensure that downstream datasets remain reliable, internally consistent, and suitable for business intelligence.

The implemented quality framework reflects the project's design objective of producing reproducible, trustworthy analytical data while maintaining full traceability back to the original source datasets.