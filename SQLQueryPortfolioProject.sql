Select *
From portfolio_projectCleaned;

--checking the unique data
Select distinct ProductName
From portfolio_projectCleaned;

Select distinct CustomerName
From portfolio_projectCleaned;

Select distinct Cities
From portfolio_projectCleaned;

Select distinct state
From portfolio_projectCleaned;

--looking at highest sales by product

Select ProductName, sum(Quantity) TotalQuantityPurchase, sum(price) TotalPriceSold
From portfolio_projectCleaned
group by ProductName
order by 3 desc;

--looking at hoghest sales by customer

Select CustomerName, sum(price) TotalPurchase
From portfolio_projectCleaned
Group by CustomerName;

--looking at city with highest sales

Select Cities, sum(price) TotalSales
From portfolio_projectCleaned
group by Cities
order by 2 desc;


--looking at the avg sales per year and total sales per year of each product

Select ProductID, OrderDate, Price, Sum(price) over (partition by productid order by orderdate) RunningTotal, Avg(Price) over (order by productid)AvgPrice
From portfolio_projectCleaned
group by ProductID, OrderDate, Price


--placing customers to categories

Drop table if exists #cus
;with cus as 
(
	Select CustomerName,
			max(OrderDate) LastPurchase,
			(select max(OrderDate) from portfolio_projectCleaned) CurrentSalesDate,
			DATEDIFF(DD, max(OrderDate), (select max(OrderDate) from portfolio_projectCleaned)) Recency,
			sum(Quantity) Frequency,
			sum(price) MonetaryValue
	From portfolio_projectCleaned
	Group by CustomerName
),
cus_calc as
(
	Select CustomerName, LastPurchase, CurrentSalesDate, Recency, Frequency, MonetaryValue,
			Ntile(3) over (order by Recency) REC,
			Ntile(3) over (order by Frequency) FREQ,
			Ntile(3) over (order by MonetaryValue) MV
	From cus
)
Select CustomerName, LastPurchase, CurrentSalesDate, Recency, Frequency, MonetaryValue, REC, FREQ, MV,
		cast( REC as varchar) + cast (FREQ as Varchar) + cast (MV as varchar) CusString
into #cus
From cus_calc

Select *,
CASE	
	When CusString in (133,132,123,122, 233) Then 'FrequentBuyers'
	When CusString in (221, 313) Then 'BuyersNeedFollowup'
	When CusString in (311, 211) Then 'PasserBys'
end as Category
From #cus