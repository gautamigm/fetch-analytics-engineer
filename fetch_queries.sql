-- What are the top 5 brands by receipts scanned for most recent month?
select
    brands.name as brand_name,
    count(receipts.id) as receipt_scanned -- I would rename _id to id in a previous cte/model

from receipts
join brands on receipts.rewardsReceiptItemList_brandcode = brands.brandcode 
-- would either create a field from the brandcode that is nested inside of rewardsReceiptItemList
-- or would have the other table created as shown in my diagram
where dateadd(month, -1, current_date()) -- using last completed month 
group by brands.name
order by receipt_scanned desc
limit 5;

-- When considering average spend from receipts with 'rewardsReceiptStatus' of 'Accepted' or 'Rejected', which is greater?
-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus' of 'Accepted' or 'Rejected', which is greater?

select
    rewardsReceiptStatus,
    avg(totalSpent) as avg_spend,
    sum(purchasedItemCount) as total_items

from receipts
where rewardsReceiptStatus in ('Accepted', 'Rejected')
group by rewardsReceiptStatus;

-- Which brand has the most spend among users who were created within the past 6 months?

select
    brands.name as brand_name,
    sum(receipts.totalSpent) as total_spend

from receipts
join users on receipts.user_id = users.id -- would have renamed in previous cte/model
join brands on receipts.rewardsReceiptItemList_brandcode = brands.brandcode
where users.createdDate >= current_date() - interval '6' month
group by brand_name
order by total_spend desc
limit 1;
