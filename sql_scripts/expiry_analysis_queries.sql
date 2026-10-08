-- ==========================================================
-- Project: Supply Chain Expiry Risk & Inventory Analysis
-- Database: pharma_drugs
-- Table: supply_chain_expiry_10k_10columns1
-- ==========================================================

use pharma_drugs;

-- 1. Data Cleaning & Preparation: Fixing data types and column names
select * from supply_chain_expiry_10k_10columns1;

alter table supply_chain_expiry_10k_10columns1
modify `Receipt_Date` date;

alter table supply_chain_expiry_10k_10columns1
modify `Expiry_Date` date;

alter table supply_chain_expiry_10k_10columns1
change column ï»¿Batch_ID Batch_ID varchar(50);


-- ==========================================================
-- 2. Waste Audit & Expiry Risk Period Analysis
-- Categorizing inventory based on remaining shelf-life days
-- ==========================================================
select 
case
	when DATEDIFF(Expiry_Date, CURDATE()) < 0 then 'Expired (past expiry)'
    when DATEDIFF(Expiry_Date, CURDATE()) <= 30 then 'Within 30 days'
    when DATEDIFF(Expiry_Date, CURDATE()) <= 90 then 'Within 90 days'
    when DATEDIFF(Expiry_Date, CURDATE()) <= 180 then 'within 180 days'
    else 'safe (> 180 days)'
end as Expired_Risk_Period,
sum(Qty_Remaining) as Total_Remaining_Quantity,
count(distinct Batch_ID) as Batch_Count
from supply_chain_expiry_10k_10columns1
group by Expired_Risk_Period
order by  
	case Expired_Risk_Period
		when 'Expired (past expiry)' then 1
        when 'Within 30 days' then 2
        when 'Within 90 days' then 3
        when 'within 180 days' then 4
        else 5
	end;


-- ==========================================================
-- 3. Geographic & Warehouse Risk Analysis
-- Identifying top high-risk warehouses and products (Risk Ratio <= 90 days)
-- ==========================================================
select
Warehouse,
Product_Name,
SKU,
Supplier,
sum(case when datediff(Expiry_Date, curdate()) <= 90 then Qty_Remaining else 0 end) AS At_Risk_Quantity,
sum(Qty_Remaining) as Total_Remaining_Quantity,
ROUND((SUM(CASE WHEN DATEDIFF(Expiry_Date, curdate()) <= 90 THEN Qty_Remaining else 0 end) / SUM(Qty_Remaining)) * 100, 2) AS Risk_Percentage
from supply_chain_expiry_10k_10columns1
group by Warehouse, Product_Name, SKU, Supplier
having At_Risk_Quantity > 0		
order by At_Risk_Quantity desc
limit 10;


-- ==========================================================
-- 4. Root Cause Analysis (RCA): Supplier Evaluation
-- Evaluating initial shelf-life delivered by suppliers to rule out supplier error
-- ==========================================================
select
Supplier,
count(distinct Batch_ID) as Total_Batches_Supplied,
round(avg(datediff(Expiry_Date, Receipt_Date)), 0) as Avg_Shelf_Life_Days,
sum(Qty_Remaining) as Total_Remaining_Quantity
from supply_chain_expiry_10k_10columns1
group by Supplier
order by Avg_Shelf_Life_Days Asc;


-- ==========================================================
-- 5. Category-wise Risk Analysis
-- Measuring risk distribution across different product categories
-- ==========================================================
select 
Category,
count(distinct SKU) as Total_Products,
sum(case when datediff(Expiry_Date, curdate()) <= 90 then Qty_Remaining else 0 end) as Risk_Quantity,
SUM(Qty_Remaining) AS Total_Remaining_Quantity,
ROUND((SUM(CASE WHEN DATEDIFF(Expiry_Date, CURDATE()) <= 90 THEN Qty_Remaining ELSE 0 END) / SUM(Qty_Remaining)) * 100, 2) AS Risk_Percentage
from supply_chain_expiry_10k_10columns1
group by Category
order by Risk_Percentage asc;
