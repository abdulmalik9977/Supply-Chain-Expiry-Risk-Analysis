# 💊 Supply Chain Expiry Risk & Inventory Analysis

An end-to-end data analytics project investigating a 10,000-row pharmaceutical supply chain dataset to identify financial leakage, inventory expiration risks, and internal operational bottlenecks using **MySQL**.

---

## 📌 Project Overview
Pharmaceutical supply chains require strict inventory rotation to prevent massive financial losses due to expired goods. This project analyzes a dataset of 10,000 pharmaceutical records using advanced SQL queries to uncover high-risk regions, quantify waste, perform root-cause analysis (RCA) on delivery vs. internal turnover, and recommend actionable supply chain optimizations.

---

## 🛠️ Tech Stack & Tools
- **Database & Advanced Analytics:** MySQL (CTEs, Window Functions, `DATEDIFF`, Staging & Aggregations)
- **Reporting & Documentation:** GitHub & Markdown

---

## 🔍 Key Findings & Insights

1. **Waste Audit:**
   - Uncovered and quantified **~880,000 units** of expired pharmaceutical inventory, representing critical financial leakage.
2. **Geographic Hotspots:**
   - Identified **Baghdad warehouses** as the primary risk hub, with expiry risk ratios reaching up to **69.45%** for essential drug lines.
3. **Root Cause Analysis (RCA):**
   - Proved through SQL date calculations (`DATEDIFF`) that all suppliers consistently deliver fresh stock (average initial shelf-life >430 days).
   - Successfully ruled out supplier error, pinning the bottleneck entirely on **internal warehouse turnover delays** and non-compliance with **FEFO (First-Expired, First-Out)** protocols.

---

## 💡 Strategic Recommendations

- **Inter-Warehouse Transfers:** Proactively relocate near-expiry stock from high-risk hubs (like Baghdad) to regional branches with faster consumption rates.
- **FEFO Enforcement:** Automate Warehouse Management Systems (WMS) to strictly dispatch older batches first, eliminating manual picking errors.

---

## 📂 Repository Structure
