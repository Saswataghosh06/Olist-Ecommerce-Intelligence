# Data Dictionary

## Olist E Commerce Intelligence Platform

---

# Document Information

| Attribute | Value |
|------------|---------|
| Document Name | Data Dictionary |
| Project | Olist E Commerce Intelligence |
| Architecture | Medallion Architecture |
| Platform | Databricks |
| Transformation Framework | dbt Core |
| Data Source | Olist Brazilian E Commerce Public Dataset |
| Version | 1.0 |
| Last Updated | Project Version 1.0 |

---

# 1. Purpose

This document provides a complete technical reference for every dataset used throughout the Analytics Engineering pipeline.

It documents the business purpose, grain, relationships, keys, transformations, and column level definitions for every source, staging, intermediate, and mart model implemented in the project.

The objective is to provide a single reference that enables Analytics Engineers, Data Engineers, Data Analysts, BI Developers, and technical stakeholders to understand how information flows from raw operational datasets into business ready analytical models.

This document reflects the implemented dbt models and project architecture.

---

# 2. Data Architecture

The project follows a three layer Medallion Architecture.

| Layer | Purpose | Materialization |
|---------|----------|----------------|
| Bronze | Raw operational datasets and standardized staging models | Views |
| Silver | Conformed dimensions and fact tables | Views |
| Gold | Business ready analytical marts | Tables |

---

# 3. Naming Standards

## Source Tables

Raw datasets follow the original Olist dataset naming convention.

Example

```
olist_orders_dataset
```

---

## Staging Models

All staging models begin with the prefix

```
stg_
```

Example

```
stg_orders
```

Purpose

* Standardize naming
* Rename attributes
* Cast data types
* Apply lightweight cleaning

---

## Dimension Models

Dimension tables begin with

```
dim_
```

Example

```
dim_customers
```

Purpose

Provide descriptive business entities for analytical reporting.

---

## Fact Models

Fact tables begin with

```
fct_
```

Example

```
fct_orders
```

Purpose

Store transactional business events together with quantitative measures.

---

## Business Marts

Business marts begin with

```
mart_
```

Example

```
mart_logistics_performance
```

Purpose

Deliver business ready datasets optimized for dashboards and reporting.

---

# 4. Entity Mapping: Source (Bronze) to Staging (Silver)

The following dictionary traces the exact column lineage from the raw operational source to the standardized dbt staging layer. By enforcing these rules at the beginning of the pipeline, the downstream `fct_` and `dim_` tables remain completely insulated from operational drift.

## 4.1 Customers Entity
* **Grain:** One row per customer.
* **Primary Key:** `customer_id`

| Raw Source Column (`olist_customers_dataset`) | Staging Column (`stg_customers`) | Description |
|:---|:---|:---|
| `customer_id` | `customer_id` | Unique customer identifier. |
| `customer_unique_id` | `customer_unique_id` | Stable identifier across multiple repeat purchases. |
| `customer_zip_code_prefix` | `zip_code` | Customer ZIP code prefix. |
| `customer_city` | `city` | Customer city. |
| `customer_state` | `state` | Customer state abbreviation. |

## 4.2 Orders Entity
* **Grain:** One row per order header.
* **Primary Key:** `order_id`

| Raw Source Column (`olist_orders_dataset`) | Staging Column (`stg_orders`) | Description |
|:---|:---|:---|
| `order_id` | `order_id` | Unique order identifier. |
| `customer_id` | `customer_id` | Customer that placed the order. |
| `order_status` | `order_status` | Current lifecycle status. |
| *(Derived)* | `is_delivered` | Boolean flag evaluating if status = 'delivered'. |
| `order_purchase_timestamp` | `order_purchase_at` | Timestamp of purchase completion. |
| `order_approved_at` | `order_approved_at` | Timestamp of payment approval. |
| `order_delivered_carrier_date` | `order_shipped_to_carrier_at` | Timestamp carrier received shipment. |
| `order_delivered_customer_date`| `order_delivered_to_customer_at`| Timestamp customer received order. |
| `order_estimated_delivery_date`| `order_estimated_delivery_at` | SLA delivery deadline. |

## 4.3 Order Items Entity
* **Grain:** One row per purchased item line.
* **Primary Key:** `order_item_key` *(Surrogate Hash)*

| Raw Source Column (`olist_order_items_dataset`) | Staging Column (`stg_order_items`) | Description |
|:---|:---|:---|
| *(Generated)* | `order_item_key` | MD5 surrogate key built from order_id + order_item_id. |
| `order_id` | `order_id` | Associated order identifier. |
| `order_item_id` | `item_sequence_number` | Position of the item within the order. |
| `product_id` | `product_id` | Purchased product. |
| `seller_id` | `seller_id` | Seller responsible for fulfillment. |
| `shipping_limit_date` | `shipping_limit_at` | Latest shipment deadline. |
| `price` | `item_price` | Product selling price. |
| `freight_value` | `item_freight` | Shipping charge. |
| *(Derived)* | `total_item_value` | Sum of `item_price` and `item_freight`. |

## 4.4 Order Payments Entity
* **Grain:** One row per payment transaction (Multiple may exist per order).
* **Foreign Key:** `order_id`

| Raw Source Column (`olist_order_payments_dataset`) | Staging Column (`stg_order_payments`) | Description |
|:---|:---|:---|
| `order_id` | `order_id` | Associated order identifier. |
| `payment_sequential` | `payment_sequential` | Payment sequence within an order. |
| `payment_type` | `payment_type` | Payment method used (Credit, Boleto, etc). |
| `payment_installments` | `payment_installments` | Number of installments. |
| `payment_value` | `payment_value` | Monetary amount of the transaction. |

## 4.5 Order Reviews Entity
* **Grain:** One row per customer review.
* **Primary Key:** `review_id`

| Raw Source Column (`olist_order_reviews_dataset`) | Staging Column (`stg_order_reviews`) | Description |
|:---|:---|:---|
| `review_id` | `review_id` | Unique review identifier. |
| `order_id` | `order_id` | Reviewed order. |
| `review_score` | `review_score` | Numeric customer rating (1-5). |
| `review_comment_title` | `review_comment_title` | Optional review title (High null %). |
| `review_comment_message` | `review_comment_message` | Optional written review (High null %). |
| `review_creation_date` | `review_created_at` | Review creation timestamp. |
| `review_answer_timestamp` | `review_answered_at` | Review publication timestamp. |

## 4.6 Products & Translation Entity
* **Grain:** One row per product.
* **Primary Key:** `product_id`

| Raw Source Column (`olist_products_dataset`) | Staging Column (`stg_products` & `stg_translations`) | Description |
|:---|:---|:---|
| `product_id` | `product_id` | Unique product identifier. |
| `product_category_name` | `category_name` | COALESCE handled; nulls replaced with 'unknown'. |
| *(From translation table)* | `category_name_english` | English translation of the product category. |
| `product_weight_g` | `product_weight_g` | Product weight in grams. |
| `product_length_cm` | `product_length_cm` | Product length in centimeters. |
| `product_height_cm` | `product_height_cm` | Product height in centimeters. |
| `product_width_cm` | `product_width_cm` | Product width in centimeters. |

## 4.7 Sellers Entity
* **Grain:** One row per seller.
* **Primary Key:** `seller_id`

| Raw Source Column (`olist_sellers_dataset`) | Staging Column (`stg_sellers`) | Description |
|:---|:---|:---|
| `seller_id` | `seller_id` | Unique seller identifier. |
| `seller_zip_code_prefix` | `zip_code` | Seller ZIP code prefix. |
| `seller_city` | `city` | Seller city. |
| `seller_state` | `state` | Seller state abbreviation. |

## 4.8 Geolocation Entity
* **Grain:** Aggregated to ONE row per ZIP (Staging).
* **Primary Key:** `zip_code`

| Raw Source Column (`olist_geolocation_dataset`) | Staging Column (`stg_geolocation`) | Description |
|:---|:---|:---|
| `geolocation_zip_code_prefix` | `zip_code` | Brazilian ZIP code prefix. |
| `geolocation_lat` | `latitude` | Deduplicated via `AVG(latitude)`. |
| `geolocation_lng` | `longitude` | Deduplicated via `AVG(longitude)`. |
| `geolocation_city` | `city` | City associated with the ZIP code. |
| `geolocation_state` | `state` | State associated with the ZIP code. |