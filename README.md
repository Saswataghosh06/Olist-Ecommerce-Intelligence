<div align="center">
 <img width="1584" height="396" alt="Image" src="https://github.com/user-attachments/assets/5d2737f2-435d-44b8-9c10-d954e2085e79" />
</div>

<h1 align="center">Olist E-Commerce Intelligence Platform</h1>
<h3 align="center">Diagnostic Report — Why 80% of O-List's Customers Never Come Back</h3>

<p align="center">
  <img alt="status" src="https://img.shields.io/badge/status-portfolio_case_study-1E56C7">
  <img alt="data" src="https://img.shields.io/badge/data-real_%E2%80%94_olist_brazilian_ecommerce-8B98AE">
  <img alt="stack" src="https://img.shields.io/badge/stack-databricks_%7C_dbt_%7C_airflow_%7C_power_bi-1E56C7">
  <img alt="scale" src="https://img.shields.io/badge/orders-99441_%7C_sellers-3095-12A879">
</p>

<p align="center"><b>Saswata Ghosh</b>
<a href="https://github.com/Saswataghosh06/Olist-Ecommerce-Intelligence">GitHub Repo</a> · <a href="https://www.linkedin.com/in/saswata-ghosh06/">LinkedIn</a> · <a href="saswataghosh2022@gmail.com">Email</a></p>

---

## 1. Problem

O-List looks like an acquisition success on paper — nearly 100,000 orders, over $15.8M in platform revenue, a real seller network. But 8 out of every 10 customers who buy once never buy again, and platform-wide, zero customers currently qualify as repeat or VIP buyers under standard RFM segmentation.

That's not a top-of-funnel problem. Something after checkout — delivery, seller quality, or both — is breaking the relationship before it starts.

## 2. Background & Overview

I treated this the way I'd treat a first week on a new client engagement: don't trust any existing summary of the business, rebuild the data model from raw CSVs, validate every join, and only then start forming opinions.

Olist is a real Brazilian marketplace connecting small sellers to major retail channels. The public dataset covers orders across 2016–2018 — customers, sellers, products, payments, reviews, and geolocation, spread across nine source tables.

I ingested the raw CSVs into a Databricks Bronze layer, modeled them into a Silver star schema and Gold business marts using dbt Core, orchestrated the pipeline with Apache Airflow, and ran the business EDA directly in a Databricks notebook before opening any BI tool. The dashboard came last, once the numbers already told a story.

## 3. Objective

**The question this project answers:**

> *If O-List is good enough at getting a first order, why can't it get a second one — and which part of the operation is actually responsible?*

That question touches product, logistics, seller quality, and finance at once, so the analysis was built to hold up under any of those lenses, not just one.

## 4. Data Structure & Initial Checks

Medallion Architecture (Bronze → Silver → Gold) with a star schema in Silver: 4 conformed dimensions, 3 fact tables, feeding 3 Gold marts.

<div align="center">
<img width="2816" height="793" alt="Image" src="https://github.com/user-attachments/assets/8267a1e6-7660-4475-b400-3f97b081de61" />
<br><sub>CSV → Databricks Volumes (Bronze) → dbt staging → Silver star schema → Gold marts → Power BI</sub>
</div>

**Source layer (Bronze):**

| Dataset | Rows | Columns |
|---|---:|---:|
| olist_geolocation_dataset | 1,000,163 | 5 |
| olist_order_items_dataset | 112,650 | 7 |
| olist_order_payments_dataset | 103,886 | 5 |
| olist_customers_dataset | 99,441 | 5 |
| olist_orders_dataset | 99,441 | 8 |
| olist_order_reviews_dataset | 99,224 | 7 |
| olist_products_dataset | 32,951 | 9 |
| olist_sellers_dataset | 3,095 | 4 |
| product_category_name_translation | 71 | 2 |

**Gold-layer entity counts (verified directly from mart exports, de-duplicated to one row per unique order):**

| Entity | Count |
|---|---:|
| Unique orders (`fct_orders`) | 99,441 |
| Order-line rows (`fct_order_items`, multi-seller orders create extra rows) | 100,785 |
| Unique sellers (`mart_seller_performance`) | 3,095 |
| Customers segmented in RFM (`mart_customer_rfm`) | 96,478 |
| Delivered orders | 96,478 (97.02%) |
| Orders with a missing review score | 768 |

**Data quality resolutions applied in staging** (full detail in `docs/data_audit.md`):

| Check | Result |
|---|---|
| Schema validation across all 9 raw tables | Passed — no unsupported types, no corrupted files |
| Customer, seller, payment, translation tables | 0% null |
| Product category nulls | 1.85%, resolved via `COALESCE(..., 'unknown')` in staging |
| Order Items — no single-column PK | Resolved with an MD5 surrogate key (`order_item_key`) |
| Geolocation — duplicate ZIP rows | Resolved via `AVG(lat/lng)` grouped by ZIP |
| Review text sparsity | 88.34% null on title/message; numeric scores 100% complete |

## 5. Interactive Dashboard

<div align="center">
<img width="1306" height="643" alt="Image" src="https://github.com/user-attachments/assets/3e27862a-c1c2-4765-b273-b3b42a5b6d30" />

</div>
<div align="center">
<img width="1308" height="644" alt="Image" src="https://github.com/user-attachments/assets/6c9cbfdc-4867-4a2c-b16c-904d04a9c989" />


</div>
<div align="center">
<img width="1306" height="644" alt="Image" src="https://github.com/user-attachments/assets/5b9e3ae1-98c8-449e-9cb6-a4cc95f1712f" />

</div>

A 3-page interactive dashboard built directly on the Gold marts — Overview, Logistics & Delivery, and Seller & Retention — with cross-filtering by customer state, order status, and customer segment, plus an independent seller-state filter on the retention page. Every KPI on it traces back to the exact numbers in Section 6 below; nothing on the dashboard is a separately-sourced or re-estimated figure.

## 6. Executive Summary

| Metric | Value |
|---|---:|
| Total platform revenue (seller mart) | $15,843,553.24 |
| Total order payments (logistics mart, order-level) | $16,008,872.12 |
| Total freight collected | $2,251,909.54 |
| Total product revenue | $13,591,643.70 |
| Average order value | $160.99 |
| One-off customers (never returned) | 77,737 (80.57%) |
| Repeat / VIP customers | 0 (0%) |
| Platform-wide SLA breach rate | 7.87% |
| Review score — on-time deliveries | 4.21 ★ (avg. of 91,011 reviewed orders) |
| Review score — late deliveries | 2.57 ★ (avg. of 7,662 reviewed orders) |
| Revenue ↔ review-score correlation (seller level) | 0.0206 (effectively none) |
| Freight ↔ review-score correlation (seller level) | -0.0759 (weak) |

*Revenue reconciliation: the seller mart's total revenue ($15,843,553.24) and the logistics mart's total order payments ($16,008,872.12) differ by ~1.03%. Both are correctly computed from their respective source tables — the gap likely reflects the payments table (which includes installments/vouchers) computing revenue on a slightly different basis than the order-items table (price + freight). Neither figure has been adjusted to match the other.*

**Headline finding:** O-List doesn't have a demand problem, it has a delivery problem. When a delivery arrives on time, customers leave a 4.21-star review on average. When it's late, that collapses to 2.57. Late deliveries hit 7.87% of all orders platform-wide — and 8 in 10 customers never place a second order. Revenue and seller quality are statistically almost unrelated (0.0206 correlation), which means the platform's leaderboard is structurally blind to sellers who generate real revenue while quietly destroying retention.

## 7. Insights Deep Dive

### 7.1 The Retention Cliff (RFM Segmentation)

<div align="center">
<img width="50%" alt="Image" src="https://github.com/user-attachments/assets/6121e957-714c-4642-9983-09cde3fe65c9" />
</div>

| Segment | Customers | Share |
|---|---:|---:|
| One-Off (single purchase, never returned) | 77,737 | 80.57% |
| New Customer (too recent to classify) | 18,741 | 19.43% |
| Repeat / VIP | 0 | 0.00% |

Out of 96,478 segmented customers, none currently qualify as repeat buyers. O-List's acquisition engine works; nothing downstream of the first order is bringing anyone back.

### 7.2 Delivery Timing Is the Single Clearest Driver of Satisfaction

<div align="center">
<img width="50%" alt="Image" src="https://github.com/user-attachments/assets/a20c237c-f101-44ff-9606-501e270b7631" />
</div>

| Delivery status | Orders | Avg. review score |
|---|---:|---:|
| On-time | 91,614 | 4.21 ★ |
| Late | 7,827 | 2.57 ★ |

A late delivery costs the platform 1.64 stars on average — nearly two full points on a 5-point scale. Platform-wide, **7.87%** of all orders breach their estimated delivery date (8.11% measured against delivered orders only — see Section 9 for which denominator is used where).

### 7.3 SLA Breach Rate by Customer State — Where Delivery Actually Fails

<div align="center">
<img width="70%" alt="Image" src="https://github.com/user-attachments/assets/803b2b27-e3eb-4cbb-b04d-1142a254e304" />
</div>

**Worst 5 states:**

| State | Orders | SLA Breach Rate | Avg. Review Score |
|---|---:|---:|---:|
| AL — Alagoas | 413 | 23.00% | 3.76 |
| MA — Maranhão | 747 | 18.88% | 3.76 |
| PI — Piauí | 495 | 15.35% | 3.92 |
| CE — Ceará | 1,336 | 14.67% | 3.85 |
| SE — Sergipe | 350 | 14.57% | 3.81 |

**Best 5 states:**

| State | Orders | SLA Breach Rate | Avg. Review Score |
|---|---:|---:|---:|
| RO — Rondônia | 253 | 2.77% | 4.05 |
| AC — Acre | 81 | 3.70% | 4.05 |
| AM — Amazonas | 148 | 4.05% | 4.21 |
| AP — Amapá | 68 | 4.41% | 4.19 |
| PR — Paraná | 5,045 | 4.88% | 4.18 |

All five worst-performing states sit in Brazil's North/Northeast, and their SLA breach rates run 4–8× higher than the best-performing states. This lines up directly with Section 7.2 — states with the worst delivery reliability also carry visibly lower average review scores.

### 7.4 Seller Concentration Risk — Revenue Says Nothing About Quality

<div align="center">
<img width="70%" alt="Image" src="https://github.com/user-attachments/assets/527c58ef-b27d-4824-b774-0cb21726d7c1" />
</div>


| Metric | Seller #1 (4869f7a5…) | Seller #2 (7c67e144…) |
|---|---:|---:|
| Revenue | $249,640.70 | $239,536.44 |
| Orders fulfilled | 1,132 | 982 |
| Avg. review score | 4.12 ★ | 3.34 ★ |
| Freight per order | $17.82 | $52.56 |

O-List's #2 seller by revenue is nearly tied with #1 in dollar terms but carries a review score almost a full star lower, and charges roughly **3× the freight per order** of the #1 seller. Across all 3,095 sellers, the correlation between revenue and review score is **0.0206** — essentially zero. A seller's dollar volume tells you nothing about whether they're a retention risk.

*Freight comparison note: Seller #1's freight/order ($17.82) is the closest "typical top-seller" figure in this dataset — treat it as an approximate benchmark, not a formal average across the full top-5 cohort, since freight per order varies by product category and weight.*

### 7.5 Freight and Dissatisfaction Are Weakly Linked at the Portfolio Level, Strongly Linked at the Outlier Level

Portfolio-wide, the correlation between a seller's freight-per-order and their average review score is **-0.0759** — weak, on its own not a strong signal. But Seller #2 sits at the extreme end of both axes simultaneously: 3× the freight of comparable top sellers, and the lowest review score in the top-5 revenue cohort. The weak aggregate correlation doesn't rule out concentrated damage from specific outlier sellers — it just means the effect doesn't show up until you segment.

## 8. Recommendations

Prioritized the way a real budget cycle would triage them.

| Priority | Recommendation | Why |
|---|---|---|
| Do first | Flag and review any high-volume seller whose average review score drops below 3.5, regardless of revenue rank | Directly catches sellers like Seller #2 (Section 7.4) |
| Do first | Launch a post-purchase retention flow (second-order discount, loyalty nudge) targeted at the 77,737 One-Off segment | Addresses the 80.57% retention cliff (Section 7.1) |
| Do first | Audit freight pricing on outlier sellers whose freight/order sits multiples above comparable peers | Seller #2 charges 3× the benchmark freight/order (Section 7.4) |
| Next | Investigate root cause of delivery failure in AL, MA, PI, CE, and SE specifically — carrier assignment, warehouse distance, last-mile coverage | These 5 states run 4–8× the best-performing states' breach rate (Section 7.3) |
| Next | Build a seller scorecard combining review score, SLA performance, and freight ratio — not revenue alone — into internal seller rankings | Revenue tells you nothing about seller quality (0.0206 correlation, Section 7.4) |
| Next | Track RFM segmentation as a rolling monthly metric so retention becomes a visible, owned KPI | Currently a one-time snapshot (Section 9) |
| Longer horizon | Pilot regional carrier partnerships for the Northeast | National-flat-rate logistics is clearly underperforming there |
| Longer horizon | Re-run freight-by-geography analysis once order-item-level freight data (split by customer state) is available | Confirms or refutes the cost side of the Northeast pattern with full precision |
| Longer horizon | Build automated seller probation triggers tied to the review/revenue divergence in 7.4 | Turns a manual audit into a standing process |

**The through-line:** the biggest lever isn't more acquisition spend — it's fixing a delivery-reliability gap concentrated in five states and a small number of outlier sellers, both of which are currently invisible to any dashboard that stops at revenue.

## 9. Tech Stack, Architecture & Code

<div align="center">
<img width="1297" height="596" alt="Image" src="https://github.com/user-attachments/assets/25cfcf53-d7c4-4358-baa6-eb592638968f" />
</div>

| Layer | Tool | Notes |
|---|---|---|
| Raw storage | Databricks Volumes (Bronze) | Immutable CSV ingestion |
| Warehouse | Databricks Lakehouse (Unity Catalog) | Delta tables across bronze/silver/gold schemas |
| Transformation | dbt Core | Staging → intermediate (star schema) → marts, with YAML-based tests |
| Orchestration | Apache Airflow | `dbt_debug` → `dbt_build` DAG |
| Governance | dbt schema tests | `unique`, `not_null`, `accepted_values`, `relationships` |
| Business EDA | Databricks notebook (SQL/Python) | RFM, correlation analysis, and SLA breakdowns run before any dashboard was built |
| Reporting | Interactive HTML/JS dashboard + Power BI | Built on top of the Gold marts; see Section 5 |

**Repository structure:**

```
Olist-Ecommerce-Intelligence/
├── airflow_orchestration/
│   ├── dags/dbt_pipeline.py
│   ├── Dockerfile
│   └── requirements.txt
├── dbt_transformation/olist_analytics/
│   ├── models/{staging, intermediate, marts}
│   ├── seeds/
│   ├── snapshots/
│   ├── tests/
│   └── dbt_project.yml
├── docs/
├── notebooks/01_raw_data_profiling.ipynb
├── images/
└── README.md
```

**Full technical documentation:**

| Document | What's in it |
|---|---|
| [`docs/data_dictionary.md`](./docs/data_dictionary.md) | Column-level lineage from raw source to every staging, dimension, and fact model |
| [`docs/data_audit.md`](./docs/data_audit.md) | Full data quality audit — nulls, schema validation, resolution logic per table |
| [`docs/project_structure.md`](./docs/project_structure.md) | Repository layout and folder responsibilities |
| [`docs/project_architecture.md`](./docs/project_architecture.md) | Pipeline architecture and Airflow DAG design |

## 10. Caveats & Assumptions

- **The logistics mart is at the order-line grain, not the order grain** (100,785 rows for 99,441 unique orders — multi-seller orders repeat). Every figure in this README is computed after de-duplicating to one row per unique `order_id`; a naive sum/mean on the raw export would overstate revenue by ~2.2% and understate the SLA breach rate by roughly 0.1 percentage point.
- **The RFM denominator (96,478) is smaller than total unique customers in the order fact (99,441).** This is expected — RFM segmentation excludes customers whose only orders were canceled or unavailable, per the mart's own logic — but it's worth stating plainly rather than treating the two counts as interchangeable. Note this also happens to match the corrected delivered-order count (96,478) exactly; this is coincidental, not the same underlying figure.
- **State-level freight-only figures are not included in this version.** The available exports split freight by seller, not by customer state, so a per-state freight table couldn't be verified against the source data. The SLA-breach-by-state table (Section 7.3) is fully verified and carries the geographic argument in its place.
- **Correlation is not causation.** The revenue-review (0.0206) and freight-review (-0.0759) figures are weak at the full-portfolio level; the outlier pattern in Section 7.5 is a segmented finding, not a platform-wide statistical relationship.
- **SLA breach rate (7.87%) is computed across all orders**, including non-delivered ones (canceled, unavailable, etc.), which are not flagged late. Measured only against delivered orders, the rate is 8.11% — both are defensible; this README uses the all-orders figure for consistency with the original notebook analysis.
- **Two valid, differently-sourced revenue totals exist** ($15,843,553.24 from the seller mart vs. $16,008,872.12 from the logistics mart) — see the reconciliation note under Section 6. Neither has been forced to match the other.
- **This reflects one analysis pass on a static dataset.** A production version would track SLA breach and RFM segmentation as rolling metrics, not a single snapshot.

---

<p align="center"><sub>Questions about any specific number, modeling decision, or the EDA behind a claim above — happy to walk through it.</sub></p>
