# Project Structure

## Olist E-Commerce Intelligence Platform

### Document Information

| Attribute | Value |
|------------|---------|
| Project Name | Olist-Ecommerce-Intelligence |
| Repository Type | Analytics Engineering Project |
| Architecture | Medallion Architecture |
| Version | 1.0 |
| Primary Technologies | Databricks, dbt Core, Apache Airflow |

---

# 1. Repository Overview

The repository is organized around the principles of modularity, separation of concerns, and reproducibility.

Each directory represents a distinct stage of the Analytics Engineering lifecycle, from orchestration and transformation to documentation and exploratory analysis.

The repository is intentionally structured to separate infrastructure code, transformation logic, documentation, and analysis artifacts, making the project easier to maintain and extend.

---

# 2. Repository Structure

```text
Olist-Ecommerce-Intelligence/
│
├── airflow_orchestration/
│   ├── dags/
│   │   └── dbt_pipeline.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── dbt_transformation/
│   └── olist_analytics/
│       ├── analyses/
│       ├── docs/
│       ├── macros/
│       ├── models/
│       │   ├── staging/
│       │   ├── intermediate/
│       │   └── marts/
│       ├── seeds/
│       ├── snapshots/
│       ├── tests/
│       ├── dbt_project.yml
│       └── profiles.yml.example
│
├── docs/
│
├── notebooks/
│   └── 01_raw_data_profiling.ipynb
│
├── .gitignore
│
└── README.md
```

---

# 3. Repository Organization

The repository consists of five major components.

| Component | Responsibility |
|------------|----------------|
| Airflow | Pipeline orchestration |
| dbt | Data transformation |
| Documentation | Technical documentation |
| Notebooks | Data exploration and profiling |
| Repository Configuration | Version control and project metadata |

Each component operates independently while contributing to the overall analytical pipeline.

---

# 4. Directory Documentation

## airflow_orchestration/

Purpose

Contains all orchestration logic responsible for executing the Analytics Engineering pipeline.

Primary Responsibilities

* Pipeline scheduling
* Workflow orchestration
* dbt execution
* Dependency management

Contents

```text
airflow_orchestration/
│
├── dags/
├── Dockerfile
└── requirements.txt
```

---

### dags/

Purpose

Stores all Apache Airflow Directed Acyclic Graphs (DAGs).

Current DAG

```
olist_medallion_pipeline
```

Responsibilities

* Validate dbt configuration.
* Execute transformation pipeline.
* Control execution order.

Pipeline

```
dbt_debug
      │
      ▼
dbt_build
```

---

### Dockerfile

Purpose

Defines the runtime environment used by Apache Airflow.

Responsibilities

* Build Airflow container.
* Install required dependencies.
* Configure runtime environment.

---

### requirements.txt

Purpose

Defines Python dependencies required for Airflow execution.

Responsibilities

* Dependency management.
* Environment reproducibility.

---

# 5. dbt_transformation/

Purpose

Contains the complete Analytics Engineering transformation layer.

This directory is responsible for converting raw operational data into business-ready analytical datasets.

Contents

```text
dbt_transformation/
│
└── olist_analytics/
```

---

## olist_analytics/

Purpose

Represents the complete dbt project.

Responsibilities

* Source registration
* SQL transformations
* Testing
* Documentation
* Materialization
* Data modeling

---

### analyses/

Purpose

Reserved for ad hoc SQL analysis.

Current Status

No analytical SQL files have been implemented.

---

### docs/

Purpose

Stores project documentation generated or maintained within the dbt project.

---

### macros/

Purpose

Reserved for reusable Jinja macros.

Current Status

No custom macros have been implemented.

---

### models/

Purpose

Contains every transformation model executed by dbt.

This directory represents the core of the Analytics Engineering project.

Structure

```text
models/

├── staging/
├── intermediate/
└── marts/
```

---

## staging/

Purpose

Implements the Bronze to Silver transformation boundary.

Responsibilities

* Source abstraction
* Naming standardization
* Datatype casting
* Basic cleaning
* Initial validation

Materialization

```
View
```

Current Models

* stg_customers
* stg_geolocation
* stg_order_items
* stg_order_payments
* stg_order_reviews
* stg_orders
* stg_products
* stg_sellers
* stg_translations

---

## intermediate/

Purpose

Builds the analytical Star Schema.

Responsibilities

* Dimension construction
* Fact table construction
* Translation logic
* Business calculations
* Referential integrity

Materialization

```
View
```

Current Models

Dimensions

* dim_customers
* dim_products
* dim_sellers
* dim_date

Facts

* fct_orders
* fct_order_items
* fct_payments

---

## marts/

Purpose

Contains business-ready analytical models.

Responsibilities

* KPI calculations
* Customer segmentation
* Logistics reporting
* Seller performance reporting

Materialization

```
Table
```

Current Models

* mart_customer_rfm
* mart_logistics_performance
* mart_seller_performance

---

### tests/

Purpose

Contains project-level testing assets.

Testing Strategy

The project primarily implements model-based YAML tests including:

* unique
* not_null
* accepted_values
* relationships

---

### dbt_project.yml

Purpose

Central configuration file for the dbt project.

Responsibilities

* Model configuration
* Materialization strategy
* Schema mapping
* Project metadata
* Path configuration

---

### profiles.yml.example

Purpose

Provides a reusable profile template for connecting to Databricks.

The production `profiles.yml` file is intentionally excluded from version control to prevent credential exposure.

---

# 6. docs/

Purpose

Contains project documentation intended for repository users.

This directory provides architectural, business, and technical documentation describing the implementation and design decisions behind the platform.

---

# 7. notebooks/

Purpose

Contains exploratory notebooks used during the initial data understanding phase.

Current Notebook

```
01_raw_data_profiling.ipynb
```

Responsibilities

* Raw data profiling
* Null analysis
* Cardinality analysis
* Data quality assessment

These notebooks are exploratory in nature and are not part of the production transformation pipeline.

---

# 8. Root-Level Files

## README.md

Provides a high-level overview of the project including:

* Business problem
* Solution architecture
* Technology stack
* Project highlights
* Business insights
* Repository navigation

---

## .gitignore

Controls which files are excluded from version control.

Examples include:

* profiles.yml
* Raw datasets
* Database files
* Environment-specific artifacts

This prevents accidental exposure of credentials and unnecessary repository growth.

---

# 9. Repository Design Principles

The repository has been organized according to the following engineering principles.

## Separation of Concerns

Infrastructure, transformations, documentation, and analysis are isolated into dedicated directories.

---

## Modularity

Each project component can evolve independently without affecting unrelated parts of the repository.

---

## Reproducibility

Configuration files and dependency management allow the project to be recreated consistently across development environments.

---

## Maintainability

The directory hierarchy follows standard dbt and Airflow project conventions, making the repository easy for new contributors to understand.

---

## Scalability

The repository structure supports future expansion through additional dbt models, Airflow DAGs, documentation, and analytical assets without requiring structural changes.