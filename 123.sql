drop table if exists zepto;
create table zepto(
	sku_id serial primary key,
	category varchar(100),
	name varchar(100) not null,
	mrp numeric(8,2),
	discount_percent numeric (5,2),
	availableQuantity integer,
	discountedSellingPrice numeric (8,2),
	weightInGms integer,
	outOfStock boolean,
	quantity integer
		
);

select * from zepto;
--sample data
select * from zepto limit 10;

--checking missing values
select * from zepto 
where name is null
or
category is null
or 
mrp is null
or
discount_percent is null
or
availablequantity is null
or
weightingms is null
or 
outofstock is null
or 
quantity is null;

--different product categories
select distinct category from zepto;

--product in stock vs out of stock
select outofstock, count(sku_id) from zepto 
group by outofstock
order by count(sku_id) ;

--product name present multiple times
select name, count(sku_id) as total_productPurcahse from zepto 
group by name
having count(sku_id) > 1
order by total_productPurcahse desc;

--data cleaning
select * from zepto
where mrp = 0;

--delete mrp =0
delete from zepto 
where mrp = 0;

--convert paise to rupees
update zepto
set mrp =mrp/100,
discountedsellingprice=discountedsellingprice/100;

select mrp,discountedsellingprice from zepto;

--Q1 find the top 10 best value product based on the discounted percentage
select distict name, mrp,discount_percent from zepto
 order by discount_percent desc limit 10;

--Q2 what are the prodcut with high mrp but out of stock
select distinct name, availablequantity,mrp, outofstock from zepto
where outofstock is True
order by mrp desc limit 5;
--Q3 calculated estimated revenue for each category
select distinct category , sum(discountedsellingprice * availablequantity ) as revenue  from zepto
group by category 
order by sum(discountedsellingprice * availablequantity );
--Q4 find all product where mrp is greater than 500 and discount is less than 10%
select distinct name,mrp, availablequantity,discount_percent from zepto
where mrp >500 and discount_percent < 10 
order by mrp desc,discount_percent desc;
--Q5 identify the top 5 categories offering the highest average discount percentage
select distinct category , round(avg(discount_percent) ,2)from zepto
group  by distinct category
order by round(avg(discount_percent),2) desc limit 5;
--Q6 find the price per gram for products above 100 gm and sort by best value.
select distinct name, weightingms, mrp,discountedsellingprice/weightingms as price_per_gram  from zepto 
where weightingms>100 
order by price_per_gram desc;

--Q7 group the product into category like low, medium ,bulk.
select distinct name, weightingms,
case when weightingms < 1000 then 'low'
	when weightingms <5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;


--Q8 what is the total inventory weight per category
select * from zepto;
select distinct category, sum(weightingms*availablequantity) as total_inventory from zepto
group by category 
order by total_inventory ;
