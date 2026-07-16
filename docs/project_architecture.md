# Project Architecture

## Olist E-Commerce Intelligence Platform

### Document Information

| Attribute | Value |
|------------|---------|
| Project Name | Olist-Ecommerce-Intelligence |
| Architecture Pattern | Medallion Architecture |
| Data Modeling Approach | Dimensional Modeling (Star Schema) |
| Orchestration Tool | Apache Airflow |
| Transformation Framework | dbt Core |
| Data Platform | Databricks |
| Storage Layer | Databricks Volumes |
| Processing Engine | Spark SQL |
| Version | 1.0 |
| Author | Saswata Ghosh |

---

# 1. Executive Summary

The Olist E-Commerce Intelligence Platform is a cloud-native Analytics Engineering solution designed to transform fragmented operational marketplace data into a trusted analytical warehouse.

The platform ingests raw Brazilian e-commerce datasets, applies standardized transformation logic through dbt, and delivers business-ready analytical marts for logistics performance monitoring, seller performance evaluation, and customer segmentation.

The architecture follows a Medallion Architecture pattern consisting of Bronze, Silver, and Gold layers. This approach establishes clear separation between raw data ingestion, business logic implementation, and analytical consumption.

The solution addresses critical marketplace business challenges including:

* Logistics SLA monitoring
* Delivery delay analysis
* Customer retention measurement
* Seller performance evaluation
* Revenue analysis
* Customer satisfaction monitoring

The final output serves as a centralized semantic layer for downstream business intelligence reporting and executive decision making.

---

# 2. Business Context

## Company Overview

Olist is one of the largest department store marketplaces operating within Brazil.

The organization connects thousands of independent sellers with customers through a centralized marketplace ecosystem that manages:

* Order processing
* Payment collection
* Logistics operations
* Customer reviews
* Marketplace transactions

As transaction volume increases, operational data becomes fragmented across multiple source systems, making enterprise-wide analysis difficult.

---

# 3. Business Problem

The business faced several analytical challenges:

### Fragmented Data Landscape

Operational information exists across multiple independent datasets including:

* Orders
* Payments
* Products
* Customers
* Sellers
* Reviews
* Geolocation

This fragmentation prevents efficient reporting and creates inconsistencies across analytical outputs.

### Logistics Visibility Challenges

Business stakeholders lack visibility into:

* Delivery delays
* Geographic shipping bottlenecks
* SLA breach trends
* Customer delivery experience

### Seller Performance Monitoring

The organization cannot easily identify:

* High-performing sellers
* Underperforming sellers
* Revenue concentration risks
* Customer satisfaction issues

### Customer Retention Blind Spots

The business lacks a reliable mechanism for:

* Customer lifecycle analysis
* Customer segmentation
* Retention measurement
* Loyalty analysis

---

# 4. Solution Objectives

The platform was designed to achieve the following objectives.

## Technical Objectives

### Objective 1

Create a centralized analytical warehouse using Databricks.

### Objective 2

Implement repeatable and version-controlled transformations using dbt.

### Objective 3

Automate execution using Apache Airflow.

### Objective 4

Enforce data quality standards through dbt testing.

### Objective 5

Deliver optimized business marts for BI consumption.

---

## Business Objectives

### Objective 1

Measure logistics SLA performance.

### Objective 2

Identify geographic delivery bottlenecks.

### Objective 3

Analyze seller revenue contribution.

### Objective 4

Measure customer satisfaction trends.

### Objective 5

Segment customers using RFM methodology.

---

# 5. High-Level Architecture

The platform follows a modern Analytics Engineering architecture.

```text
                RAW DATA SOURCES
                         │
                         ▼
            Databricks Volumes (Bronze)
                         │
                         ▼
                 dbt Staging Layer
                         │
                         ▼
               dbt Intermediate Layer
                         │
                         ▼
                  Star Schema Layer
                         │
                         ▼
                   Gold Business Marts
                         │
                         ▼
                  BI & Analytics Layer
```

The architecture separates data processing into distinct layers, ensuring maintainability, scalability, and data quality throughout the pipeline.

---

# 6. Core Architecture Components

The platform is composed of five primary architectural components, each with a clearly defined responsibility within the data lifecycle.

| Component | Primary Responsibility | Technology |
|-----------|------------------------|------------|
| Data Storage | Stores raw operational datasets | Databricks Volumes |
| Transformation Layer | Cleans, standardizes, and models data | dbt Core |
| Compute Engine | Executes SQL transformations | Databricks SQL Warehouse |
| Orchestration | Automates pipeline execution | Apache Airflow |
| Analytics Layer | Serves business-ready datasets | Gold Mart Tables |

Each component is intentionally decoupled to improve maintainability, simplify debugging, and enable independent development.

---

# 7. Technology Architecture

```
                    GitHub Repository
                            │
                            │
                            ▼
                    Apache Airflow DAG
                            │
                            ▼
                    dbt Build Command
                            │
                            ▼
                Databricks SQL Warehouse
                            │
                            ▼
                  Databricks Unity Catalog
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
     Bronze              Silver              Gold
                            │
                            ▼
                    Business Intelligence
```

Each technology performs a dedicated responsibility rather than overlapping responsibilities.

---

# 8. Databricks Architecture

Databricks acts as the centralized cloud platform responsible for data storage, SQL execution, and warehouse management.

## Components

### Unity Catalog

The Unity Catalog provides centralized metadata management for every table used throughout the project.

Current Catalog

```
olist_analytics
```

---

### Schemas

The project separates data into three logical schemas.

| Schema | Purpose |
|---------|----------|
| bronze | Raw operational data |
| silver | Conformed analytical models |
| gold | Business marts |

This schema separation mirrors the Medallion Architecture and provides clear ownership boundaries between ingestion, transformation, and analytics.

---

### Databricks Volumes

Raw CSV files are stored inside Databricks Volumes before any transformation begins.

Responsibilities include

* Centralized storage
* Persistent raw data
* Source registration
* Separation from transformed data

No business logic is applied within this layer.

---

### SQL Warehouse

A Serverless SQL Warehouse executes every dbt model.

Responsibilities include

* SQL execution
* Query optimization
* Table materialization
* View creation
* Business mart generation

The warehouse serves as the compute engine rather than the storage layer.

---

# 9. Apache Airflow Architecture

Apache Airflow orchestrates the complete transformation workflow.

The project currently consists of a lightweight orchestration strategy designed to automate dbt execution while keeping orchestration independent from transformation logic.

## DAG

```
olist_medallion_pipeline
```

---

## Execution Schedule

```
Daily
```

---

## Retry Policy

| Setting | Value |
|----------|-------|
| Retries | 1 |
| Retry Delay | 5 Minutes |
| Catchup | Disabled |

---

## Pipeline Flow

```
dbt_debug
      │
      ▼
dbt_build
```

### dbt_debug

Purpose

Verifies

* Connection configuration
* Databricks authentication
* Profile configuration
* Source accessibility

Only after a successful validation does the transformation process continue.

---

### dbt_build

Responsible for executing

* Source freshness checks
* dbt tests
* View creation
* Table creation
* Documentation metadata generation

This single command orchestrates the complete Medallion transformation pipeline.

---

# 10. dbt Transformation Architecture

dbt is responsible for implementing every transformation inside the analytical warehouse.

Transformation logic is organized into three logical layers.

```
models/

├── staging/
├── intermediate/
└── marts/
```

Each layer has a dedicated responsibility.

---

## Staging Layer

Schema

```
bronze
```

Materialization

```
View
```

Responsibilities

* Source abstraction
* Naming standardization
* Datatype casting
* Basic cleaning
* Surrogate key generation
* Initial validation

This layer intentionally contains minimal business logic.

Its primary purpose is to convert raw operational data into standardized analytical inputs.

---

## Intermediate Layer

Schema

```
silver
```

Materialization

```
View
```

Responsibilities

* Star Schema construction
* Dimension creation
* Fact table creation
* Relationship enforcement
* Translation mapping
* Deduplication
* Business calculations

This layer represents the analytical foundation of the warehouse.

All downstream analytical models depend upon these conformed dimensions and fact tables.

---

## Mart Layer

Schema

```
gold
```

Materialization

```
Table
```

Responsibilities

* KPI calculations
* Executive reporting
* Aggregations
* Customer segmentation
* Seller performance
* Logistics analytics

Unlike previous layers, Gold models are materialized as physical tables to optimize analytical query performance.

---

# 11. Medallion Architecture

The Olist E-Commerce Intelligence Platform follows the Medallion Architecture pattern to progressively improve data quality, enforce business rules, and prepare analytical datasets for business intelligence.

Rather than transforming raw operational data directly into reporting tables, the architecture separates responsibilities into three logical layers:

* Bronze
* Silver
* Gold

Each layer has a single responsibility and builds upon the previous layer.

---

# 12. Bronze Layer Architecture

## Purpose

The Bronze layer serves as the system's ingestion layer.

Its primary responsibility is preserving the original source data while providing standardized access for downstream transformations.

No business decisions are made at this stage.

---

## Data Source

The project ingests nine operational datasets originating from the Olist Brazilian E-Commerce Dataset.

These datasets are uploaded into Databricks Volumes before transformation begins.

Source Format

```
CSV
```

Storage Location

```
Databricks Volumes
```

---

## Bronze Schema

```
olist_analytics.bronze
```

---

## Bronze Models

The staging layer references the following source tables.

| Source Table | Purpose |
|--------------|----------|
| olist_customers_dataset | Customer master data |
| olist_orders_dataset | Order lifecycle information |
| olist_order_items_dataset | Order line items |
| olist_order_payments_dataset | Payment transactions |
| olist_order_reviews_dataset | Customer feedback |
| olist_products_dataset | Product catalog |
| olist_sellers_dataset | Seller master data |
| olist_geolocation_dataset | Geographic reference data |
| product_category_name_translation | Portuguese to English category mapping |

---

## Bronze Responsibilities

The Bronze layer is responsible for:

* Registering raw datasets within Unity Catalog
* Preserving source fidelity
* Providing standardized source references for dbt
* Serving as the foundation for downstream transformations

No aggregations, joins, or business calculations are performed in this layer.

---

# 13. Staging Architecture

The staging layer provides the first transformation boundary between operational data and analytical models.

Every raw dataset is transformed into a standardized staging model.

---

## Primary Responsibilities

The staging layer performs lightweight transformations including:

* Column renaming
* Datatype standardization
* Surrogate key generation
* Basic null handling
* Source abstraction
* Initial validation

Business logic is intentionally minimized.

---

## Materialization Strategy

```
View
```

---

## Why Views?

Views were selected because the staging layer performs lightweight transformations that do not justify physical storage.

Advantages include:

* Reduced storage costs
* Elimination of duplicate datasets
* Single source of truth
* Automatic propagation of source updates
* Faster development iterations

---

## Staging Models

| Model | Responsibility |
|--------|----------------|
| stg_customers | Customer standardization |
| stg_orders | Order standardization |
| stg_order_items | Line item standardization |
| stg_order_payments | Payment standardization |
| stg_order_reviews | Review standardization |
| stg_products | Product standardization |
| stg_sellers | Seller standardization |
| stg_geolocation | Geolocation deduplication |
| stg_translations | Product category translation |

---

# 14. Silver Layer Architecture

The Silver layer represents the analytical foundation of the warehouse.

Unlike the staging layer, this layer introduces business relationships between datasets.

---

## Objectives

The Silver layer is responsible for transforming isolated operational datasets into a conformed analytical model.

Responsibilities include:

* Building dimensions
* Building fact tables
* Translating business terminology
* Removing duplication
* Enforcing relationships
* Applying business calculations

---

## Silver Schema

```
olist_analytics.silver
```

---

## Dimensional Modeling

The project adopts a Star Schema to optimize analytical query performance.

Dimensions provide descriptive business attributes.

Facts capture measurable business events.

---

## Dimension Models

| Model | Description |
|--------|-------------|
| dim_customers | Customer dimension |
| dim_products | Product dimension |
| dim_sellers | Seller dimension |
| dim_date | Calendar dimension |

---

## Fact Models

| Model | Description |
|--------|-------------|
| fct_orders | Order level business events |
| fct_order_items | Product level transaction events |
| fct_payments | Payment transactions |

---

## Why a Star Schema?

A Star Schema was selected because it offers several advantages for analytical workloads.

### Simpler Query Design

Business users can build reports using straightforward joins between dimensions and fact tables.

---

### Better BI Performance

Star Schemas reduce query complexity and improve dashboard responsiveness.

---

### Consistent Business Definitions

Metrics such as revenue, review score, freight cost, and delivery time are defined once and reused consistently across downstream marts.

---

### Scalability

Additional dimensions and facts can be introduced without redesigning the warehouse architecture.

---

# 15. Gold Layer Architecture

The Gold layer represents the business presentation layer.

This layer contains curated analytical datasets optimized specifically for reporting and dashboard consumption.

Unlike previous layers, the Gold layer contains business-specific logic and KPI calculations.

---

## Gold Schema

```
olist_analytics.gold
```

---

## Materialization Strategy

```
Table
```

---

## Why Tables?

Gold models are materialized as physical tables because they contain:

* Aggregations
* KPI calculations
* Customer segmentation
* Business metrics
* Reporting logic

Materializing these datasets reduces query execution time for downstream BI tools and prevents repeated computation of expensive aggregations.

---

## Gold Models

| Model | Business Purpose |
|--------|------------------|
| mart_customer_rfm | Customer lifecycle segmentation |
| mart_logistics_performance | Logistics SLA reporting |
| mart_seller_performance | Seller commercial performance |

Each mart represents a business-ready semantic layer designed for direct consumption by analytical dashboards.

# 16. End-to-End Data Flow

The platform follows a deterministic transformation pipeline where each layer consumes validated outputs from the previous layer.

```

                Raw CSV Files
                       │
                       ▼
           Databricks Volumes (Bronze)
                       │
                       ▼
              dbt Source Definitions
                       │
                       ▼
              Staging Models (Views)
                       │
                       ▼
        Intermediate Models (Star Schema)
                       │
                       ▼
         Gold Business Marts (Tables)
                       │
                       ▼
          Business Intelligence Platform

```

The architecture ensures that every analytical dataset can be traced back to its originating operational source, providing transparency and simplifying troubleshooting.

---

# 17. Model Dependency Flow

The transformation pipeline follows a hierarchical dependency structure.

```

Raw Sources
      │
      ▼
Staging Models
      │
      ▼
Dimensions & Facts
      │
      ▼
Business Marts

```

The dependency hierarchy ensures that:

* Source standardization occurs before business modeling.
* Business entities are conformed before KPI calculations.
* Reporting models consume only validated analytical datasets.

This layered dependency minimizes duplication of business logic and improves maintainability.

---

# 18. Materialization Strategy

Different model layers use different materialization strategies based on their purpose.

| Layer | Materialization | Reason |
|--------|----------------|--------|
| Staging | View | Lightweight transformations with minimal storage overhead |
| Intermediate | View | Conformed analytical models reused across multiple marts |
| Gold | Table | Optimized for dashboard performance and repeated analytical queries |

This approach balances compute efficiency, storage utilization, and query performance.

---

# 19. Design Decisions

Several architectural decisions were made to improve maintainability, scalability, and analytical consistency.

## Separation of Concerns

Each architectural layer performs a single responsibility.

| Layer | Responsibility |
|---------|---------------|
| Bronze | Data ingestion and preservation |
| Staging | Data standardization |
| Silver | Business modeling |
| Gold | Business analytics |

This separation reduces coupling between transformations and makes debugging significantly easier.

---

## View-Based Development

The Staging and Intermediate layers are materialized as views.

Benefits include:

* Reduced storage consumption.
* Single source of truth.
* Simplified maintenance.
* Immediate propagation of upstream changes.
* Faster iterative development.

---

## Table-Based Business Marts

The Gold layer is materialized as physical tables.

Benefits include:

* Faster dashboard performance.
* Reduced execution time for aggregated queries.
* Consistent KPI calculations.
* Optimized analytical workloads.

---

## Centralized Business Logic

Business rules are implemented once within dbt models rather than repeatedly inside reporting tools.

Examples include:

* RFM customer segmentation.
* Late delivery calculation.
* Revenue aggregation.
* Review score aggregation.
* Delivery duration calculation.

This ensures that all downstream consumers use consistent business definitions.

---

# 20. Data Quality Integration

Data quality validation is embedded throughout the transformation process using native dbt tests.

Implemented validations include:

* Primary key uniqueness.
* Non-null constraints.
* Referential integrity.
* Accepted value validation.

Examples include:

* Unique customer identifiers.
* Unique seller identifiers.
* Relationship validation between fact and dimension tables.
* Accepted customer segment values.
* Valid order status values.

These automated tests help identify data quality issues during pipeline execution before data reaches analytical consumers.

---

# 21. Security Considerations

Sensitive configuration is separated from source code.

Current security practices include:

* Databricks credentials referenced using environment variables.
* `profiles.yml` excluded from version control.
* Raw datasets excluded from Git.
* Environment-specific configuration separated from project code.
* Repository managed through `.gitignore`.

This approach supports secure collaboration while preventing accidental exposure of credentials.

---

# 22. Scalability Considerations

The project architecture is designed to accommodate future expansion without requiring significant redesign.

Examples include:

* Additional source datasets can be introduced by extending dbt source definitions.
* New dimensions and fact tables can be added within the Intermediate layer.
* Additional business marts can be created independently without modifying existing analytical models.
* Airflow orchestration can be extended with additional tasks as pipeline complexity increases.

The layered architecture minimizes dependencies between components, allowing each layer to evolve independently.

---

# 23. Architectural Strengths

The implemented architecture provides several engineering advantages.

## Modular Design

Each transformation layer has a clearly defined responsibility, improving readability and simplifying maintenance.

---

## Reusable Data Models

Conformed dimensions and fact tables serve as reusable analytical assets for multiple downstream business marts.

---

## Consistent Business Logic

Business rules are centralized within dbt models, ensuring that KPIs and analytical calculations remain consistent across all reporting use cases.

---

## Automated Pipeline Execution

Apache Airflow orchestrates the complete transformation workflow, enabling repeatable and production-style execution.

---

## Business-Oriented Data Products

The Gold layer exposes curated analytical marts focused on specific business domains:

* Customer analytics.
* Logistics performance.
* Seller performance.

These marts provide business-ready datasets that can be consumed directly by BI tools without requiring additional transformation.

---

# 24. Architecture Summary

The Olist E-Commerce Intelligence Platform implements a modern Analytics Engineering architecture built on Databricks, dbt Core, and Apache Airflow.

By adopting a Medallion Architecture, the platform separates raw ingestion, business modeling, and analytical reporting into distinct layers, improving maintainability, data quality, and scalability.

The resulting Star Schema establishes a trusted analytical foundation that supports executive reporting across logistics operations, commercial performance, and customer analytics.

This architecture enables reproducible, version-controlled data transformations while providing business users with reliable, high-performance datasets for downstream reporting and decision-making.