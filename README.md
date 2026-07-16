<div align="center">

<img src="images/logo.png" width="140"/>

# Olist E-Commerce Intelligence Platform

### End-to-End Analytics Engineering Case Study

Designing a modern Medallion data warehouse using Databricks, dbt, Spark SQL, Apache Airflow (Astronomer), Docker, and Power BI to transform operational e-commerce data into business-ready analytical models.

<br>

![Status](https://img.shields.io/badge/Status-Completed-success)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-blue)
![Warehouse](https://img.shields.io/badge/Warehouse-Star%20Schema-orange)
![Transformation](https://img.shields.io/badge/dbt-Core-FF694B)
![Platform](https://img.shields.io/badge/Platform-Databricks-EF3E42)
![SQL](https://img.shields.io/badge/SQL-Spark_SQL-blue)
![Orchestration](https://img.shields.io/badge/Orchestration-Apache_Airflow-017CEE)
![Container](https://img.shields.io/badge/Container-Docker-2496ED)
![Visualization](https://img.shields.io/badge/Visualization-Power_BI-F2C811)

<br>

[Project Documentation](docs/) •
[Architecture](docs/project_architecture.md) •
[Data Model](docs/data_model.md) •
[Data Dictionary](docs/data_dictionary.md) •
[Data Quality](docs/data_quality.md) •
[Setup Guide](SETUP.md)

</div>

---

# Executive Summary

Modern analytics teams require more than dashboards. They require reliable data pipelines, governed transformation logic, validated analytical models, and business focused reporting that stakeholders can trust.

This project demonstrates an end-to-end Analytics Engineering workflow using the publicly available Olist Brazilian E-Commerce dataset. The objective was to transform raw operational data into a governed analytical warehouse following modern data engineering practices.

The solution implements a Medallion Architecture using Databricks as the development platform, dbt Core for SQL transformations, Spark SQL for model development, Apache Airflow (Astronomer Runtime) for orchestration, Docker for local execution, and Power BI for business reporting.

Rather than treating the dataset as a visualization exercise, the project focuses on designing reusable data models, enforcing data quality, documenting transformation logic, and delivering analytical marts that support business decision making.

---

# Business Context

E-commerce organizations generate large volumes of operational data across customers, orders, products, payments, logistics, sellers, and customer reviews.

Although these datasets contain valuable business information, they are optimized for transactional processing rather than analytical reporting.

Typical challenges include:

* Data spread across multiple operational tables.
* Inconsistent naming conventions.
* Limited business friendly structures.
* Complex joins required for reporting.
* Repeated transformation logic across dashboards.
* Lack of centralized data quality validation.

These issues increase development effort while reducing confidence in analytical outputs.

The objective of this project is to solve those challenges by designing a modern analytics warehouse that provides clean, reusable, and business-oriented datasets.

---

# Project Objectives

The project was designed around four primary objectives.

## 1. Build a Modern Analytics Warehouse

Develop a layered Medallion Architecture that separates raw ingestion, standardized transformations, dimensional modeling, and business reporting.

## 2. Implement Analytics Engineering Best Practices

Use dbt to create modular SQL models, reusable transformations, lineage documentation, and automated testing.

## 3. Deliver Business Ready Data Models

Create conformed dimensions, fact tables, and analytical marts that support reporting across multiple business domains.

## 4. Produce Actionable Business Insights

Use Power BI to analyze customer behavior, seller performance, logistics operations, and overall marketplace performance.

---

# Project Scope

This project covers the complete analytical workflow from raw source data to executive reporting.

The implementation includes:

* Bronze data ingestion
* Medallion Architecture
* dbt transformation framework
* Star Schema dimensional modeling
* Data quality validation
* Data auditing
* Business marts
* Apache Airflow orchestration
* Power BI dashboards
* Complete technical documentation

---

# Business Questions

The analytical models were designed to answer business questions across multiple operational domains.

## Customer Analytics

* Which customers generate the highest long-term value?
* Which customers are becoming inactive?
* How can customers be segmented using RFM analysis?

## Sales Performance

* How do order volumes change over time?
* Which product categories generate the highest revenue?
* How do payment methods vary across purchases?

## Seller Analytics

* Which sellers generate the highest revenue?
* Which sellers fulfill the largest number of orders?
* How do customer review scores differ across sellers?

## Logistics Analytics

* What is the actual delivery time compared to the estimated delivery time?
* Which states experience the largest delivery delays?
* How frequently are deliveries completed after the promised date?

---

# Repository Highlights

| Capability | Status |
|------------|--------|
| Medallion Architecture | ✓ |
| Star Schema Modeling | ✓ |
| dbt Modular Transformations | ✓ |
| Spark SQL Models | ✓ |
| Automated Data Quality Tests | ✓ |
| Apache Airflow Orchestration | ✓ |
| Docker Deployment | ✓ |
| Power BI Reporting | ✓ |
| Technical Documentation | ✓ |

---

# Solution Architecture

The project follows a layered Medallion Architecture that separates raw ingestion from business-ready analytical models. Each layer has a single responsibility, making the pipeline easier to maintain, test, document, and extend.

```
                                Olist Public Dataset
                                        │
                                        ▼
                         Databricks Community Edition
                                        │
                                        ▼
                          Bronze Layer (Raw Source Tables)
                                        │
                                        ▼
                    dbt Staging Models (Standardization Layer)
                                        │
                                        ▼
               Silver Layer (Dimensions & Fact Tables)
                                        │
                                        ▼
                     Gold Layer (Business Data Marts)
                                        │
                                        ▼
                              Power BI Dashboards
```

---

# Technology Stack

| Layer | Technology | Purpose |
|--------|------------|---------|
| Data Source | Olist Brazilian E-Commerce Dataset | Raw operational data |
| Development Platform | Databricks Community Edition | Data engineering workspace |
| Storage | Delta Lake | Bronze data storage |
| Transformation | dbt Core | SQL transformation framework |
| SQL Engine | Spark SQL | Data modeling and transformations |
| Workflow Orchestration | Apache Airflow (Astronomer Runtime) | Pipeline scheduling and orchestration |
| Containerization | Docker | Local Airflow execution |
| Version Control | Git & GitHub | Source code management |
| Business Intelligence | Power BI | Interactive reporting and analytics |

---

# Engineering Design Decisions

This project intentionally follows modern Analytics Engineering practices rather than building SQL scripts directly against raw tables.

| Decision | Reason |
|----------|--------|
| Medallion Architecture | Separates ingestion, transformation, and reporting responsibilities. |
| Star Schema | Simplifies analytical queries and improves reporting performance. |
| dbt Core | Provides modular SQL development, lineage, documentation, and testing. |
| Spark SQL | Native SQL execution within Databricks. |
| Apache Airflow | Automates pipeline execution and manages task dependencies. |
| Docker | Creates a reproducible execution environment for Airflow. |
| Power BI | Enables interactive business reporting using curated analytical models. |

---

# Data Pipeline

The analytical workflow transforms operational datasets into reusable business assets through several processing stages.

## Step 1. Raw Data Ingestion

The original Olist datasets are loaded into Databricks without modification.

This layer preserves the source data exactly as received and acts as the immutable foundation for all downstream processing.

Output:

```
Bronze Tables
```

---

## Step 2. Data Standardization

dbt staging models standardize the raw datasets by applying lightweight transformations.

These include:

* Standardized naming conventions
* Data type standardization
* Basic null handling
* Derived helper columns
* Geographic standardization
* Translation lookup preparation

Business logic is intentionally kept minimal within this layer.

Output:

```
Staging Views
```

---

## Step 3. Dimensional Modeling

The standardized staging models are transformed into reusable analytical models following a Star Schema.

Dimensions contain descriptive business entities.

Facts capture measurable business events.

Output:

```
Dimensions

• dim_customers
• dim_date
• dim_products
• dim_sellers

Facts

• fct_orders
• fct_order_items
• fct_payments
```

---

## Step 4. Business Marts

Business marts aggregate the dimensional models into subject-specific analytical datasets.

Each mart is designed to answer a specific business domain.

Current marts include:

* Customer RFM Analysis
* Logistics Performance
* Seller Performance

These marts provide optimized datasets for Power BI reporting.

---

# dbt Project Structure

The dbt project follows a modular architecture that separates staging models from reusable analytical models.

```
models/

├── staging/
│
├── dimensions/
│
├── facts/
│
└── marts/
```

Each layer depends only on the previous layer, producing a clear and traceable transformation lineage.

---

# Data Model

The analytical warehouse follows a Star Schema.

Dimensions describe business entities.

Fact tables capture business events.

Business marts aggregate those facts into reporting-ready datasets.

<div align="center">

**[PLACEHOLDER FOR ENTITY RELATIONSHIP DIAGRAM]**

</div>

The complete schema documentation is available in:

```
docs/data_model.md
```

---

# dbt Lineage

One of the primary advantages of dbt is automatic dependency tracking.

Every model explicitly references upstream models using `ref()` or `source()`, allowing dbt to generate a complete transformation lineage.

This makes model dependencies transparent while simplifying impact analysis and maintenance.

<div align="center">

**[PLACEHOLDER FOR dbt LINEAGE GRAPH]**

</div>

---

# Apache Airflow Orchestration

The transformation workflow is orchestrated using Apache Airflow running on the Astronomer Runtime inside Docker.

The pipeline executes tasks in dependency order, ensuring that downstream models are built only after prerequisite transformations complete successfully.

Typical pipeline flow:

```
Initialize Environment

        │

        ▼

Run dbt Models

        │

        ▼

Execute dbt Tests

        │

        ▼

Pipeline Complete
```

<div align="center">

**[PLACEHOLDER FOR AIRFLOW DAG SCREENSHOT]**

</div>

---

# Repository Structure

The repository is organized to separate source code, documentation, transformation logic, orchestration, and reporting assets.

```
project-root/

├── airflow/
├── dbt/
├── docs/
├── images/
├── powerbi/
├── README.md
├── SETUP.md
├── CONTRIBUTING.md
└── LICENSE
```

A detailed explanation of every directory is available in:

```
docs/project_structure.md
```

---

# Technical Documentation

Complete project documentation is maintained separately from this README to keep the overview concise.

| Document | Description |
|----------|-------------|
| Project Overview | Business context and project scope |
| Project Architecture | Pipeline architecture and engineering decisions |
| Project Structure | Repository organization |
| Data Model | Star schema and relationships |
| Data Dictionary | Model and column definitions |
| Data Audit | Raw versus transformed data validation |
| Data Quality | Data quality framework and validation checks |
| Setup Guide | Local project installation instructions |

Each document can be found inside the `docs` directory.

# Data Quality & Validation

Reliable business insights depend on reliable data. Before building analytical models, the data pipeline applies validation checks to ensure the transformed datasets are structurally consistent and suitable for reporting.

The project uses multiple validation layers throughout the Medallion Architecture.

* Source level validation
* Transformation level validation
* Model level validation
* Business rule validation

The complete validation methodology is documented in:

```
docs/data_quality.md
```

A detailed comparison between the raw source data and transformed analytical models is available in:

```
docs/data_audit.md
```

---

# Business Data Marts

The Gold layer contains subject-oriented analytical marts designed for reporting and business decision making.

Unlike fact tables, these marts contain business-ready metrics that minimize transformation logic inside Power BI.

---

## Customer RFM Mart

### Purpose

Provides customer segmentation using the RFM (Recency, Frequency, Monetary) methodology.

### Business Questions

* Which customers purchase most frequently?
* Which customers generate the highest revenue?
* Which customers are becoming inactive?
* How should customers be segmented for retention strategies?

### Primary Metrics

* Recency
* Frequency
* Monetary Value
* Customer Segment

---

## Logistics Performance Mart

### Purpose

Provides operational delivery performance across customers, sellers, and logistics operations.

### Business Questions

* How long does delivery actually take?
* How accurate are estimated delivery dates?
* Which deliveries arrive late?
* How do delivery delays influence customer reviews?

### Primary Metrics

* Actual Delivery Days
* Estimated Delivery Days
* Late Delivery Flag
* Order Value
* Average Review Score

---

## Seller Performance Mart

### Purpose

Measures seller operational performance and commercial contribution.

### Business Questions

* Which sellers generate the highest revenue?
* Which sellers fulfill the largest number of orders?
* Which sellers receive the highest customer ratings?

### Primary Metrics

* Orders Fulfilled
* Items Sold
* Product Revenue
* Freight Revenue
* Total Revenue
* Average Review Score

---

# Power BI Dashboard

The analytical marts are consumed by Power BI to provide interactive business reporting.

The dashboard is organized into multiple business domains to support operational and commercial decision making.

Current report pages include:

* Executive Overview
* Customer Analytics
* Seller Performance
* Logistics Performance

<div align="center">

**[PLACEHOLDER FOR POWER BI OVERVIEW DASHBOARD]**

</div>

---

<div align="center">

**[PLACEHOLDER FOR CUSTOMER ANALYTICS DASHBOARD]**

</div>

---

<div align="center">

**[PLACEHOLDER FOR SELLER PERFORMANCE DASHBOARD]**

</div>

---

<div align="center">

**[PLACEHOLDER FOR LOGISTICS PERFORMANCE DASHBOARD]**

</div>

---

# Project Documentation

The repository contains comprehensive technical documentation describing every stage of the project.

| Document | Description |
|----------|-------------|
| `project_overview.md` | Business context, objectives, and project scope |
| `project_architecture.md` | End-to-end pipeline architecture |
| `project_structure.md` | Repository organization |
| `data_model.md` | Star schema and model relationships |
| `data_dictionary.md` | Detailed model and column definitions |
| `data_audit.md` | Raw versus transformed data comparison |
| `data_quality.md` | Validation framework and quality checks |
| `SETUP.md` | Local installation and execution guide |

---

# Skills Demonstrated

This project demonstrates practical experience across the Analytics Engineering lifecycle.

### Data Engineering

* Data ingestion
* Data transformation
* Medallion Architecture
* ETL pipeline design
* Workflow orchestration

### Analytics Engineering

* dbt Core
* Modular SQL development
* Star Schema design
* Dimensional modeling
* Data lineage
* Documentation
* Data quality validation

### Analytics

* Customer segmentation
* Seller performance analysis
* Logistics analytics
* KPI development
* Executive reporting

### Business Intelligence

* Power BI
* Interactive dashboards
* Executive reporting
* Business KPI design

---

# Repository Highlights

✔ End-to-end analytics engineering project

✔ Medallion Architecture implementation

✔ Star Schema dimensional warehouse

✔ Modular dbt project

✔ Spark SQL transformations

✔ Apache Airflow orchestration

✔ Dockerized execution environment

✔ Automated data quality validation

✔ Comprehensive technical documentation

✔ Business-ready Power BI reporting

---
# Business Impact

The objective of this project extends beyond building a modern analytics stack. The warehouse is designed to transform raw operational data into trusted analytical assets that support informed business decisions.

By combining dimensional modeling, governed transformations, and interactive reporting, the platform enables stakeholders to monitor marketplace performance across customers, sellers, logistics operations, payments, and products from a single analytical source.

The resulting warehouse reduces repetitive reporting logic, improves data consistency, and provides reusable datasets for future analytical initiatives.

---

# Key Learnings

Developing this project provided practical experience across multiple areas of Analytics Engineering.

### Data Engineering

* Designing a Medallion Architecture using Databricks.
* Working with Delta Lake tables.
* Managing layered data transformations.

### Analytics Engineering

* Building modular dbt projects.
* Creating reusable staging, dimension, fact, and mart models.
* Applying dimensional modeling principles.
* Documenting models through comprehensive technical documentation.
* Developing reusable SQL transformations.

### Workflow Orchestration

* Building Apache Airflow DAGs using the Astronomer Runtime.
* Running Airflow locally through Docker.
* Managing task dependencies and execution order.
* Automating dbt model execution and testing.

### Business Intelligence

* Designing business-focused analytical marts.
* Developing interactive Power BI dashboards.
* Creating reusable KPIs and executive reporting.

---

# Future Enhancements

The current implementation establishes a strong analytical foundation while leaving opportunities for future improvements.

Potential enhancements include:

* Incremental dbt models for faster pipeline execution.
* dbt snapshots for Slowly Changing Dimensions.
* CI/CD integration using GitHub Actions.
* Automated documentation deployment.
* Cloud deployment on Azure, AWS, or GCP.
* Data observability and monitoring.
* Semantic layer implementation.
* Real-time ingestion using streaming pipelines.
* Automated alerting for failed pipeline executions.

---

# How to Run This Project

Detailed setup instructions are available in:

```
SETUP.md
```

The guide includes:

* Environment setup
* Databricks configuration
* dbt installation
* Docker installation
* Astronomer Runtime setup
* Apache Airflow execution
* Power BI connection
* Pipeline execution

---

# Repository Documentation

The project contains detailed technical documentation for every major component.

| Document | Purpose |
|----------|---------|
| `README.md` | Project overview |
| `SETUP.md` | Installation and execution guide |
| `docs/project_overview.md` | Business context and objectives |
| `docs/project_architecture.md` | Pipeline architecture |
| `docs/project_structure.md` | Repository organization |
| `docs/data_model.md` | Dimensional model documentation |
| `docs/data_dictionary.md` | Detailed model reference |
| `docs/data_audit.md` | Raw versus transformed data audit |
| `docs/data_quality.md` | Data quality framework |

---

# About This Project

This repository was developed as an end-to-end Analytics Engineering case study to demonstrate modern data warehousing practices using publicly available e-commerce data.

The project focuses on designing maintainable data models, implementing modular SQL transformations, orchestrating workflows, validating data quality, and delivering business-ready analytical datasets for reporting.

While the source data originates from the publicly available Olist Brazilian E-Commerce dataset, the architecture, transformation framework, analytical models, documentation, orchestration pipeline, and reporting solution were designed and implemented as part of this project.

---

# Connect

**Saswata Ghosh**

Analytics Engineer • Data Analyst

GitHub

```
https://github.com/Saswataghosh06
```

LinkedIn

```
[Add LinkedIn URL]
```

Portfolio

```
[Add Portfolio URL]
```

Email

```
[Add Email Address]
```

---

# License

This project is licensed under the MIT License.

See the `LICENSE` file for additional information.

---

<div align="center">

### Thank you for taking the time to explore this project.

If you have questions, feedback, or would like to discuss the implementation, feel free to connect.

</div>