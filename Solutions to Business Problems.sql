---- Business Problems from the Customer Churn datasets answered using SQL Queries.

---- 1: How many records are in each table?
SELECT  COUNT(*) AS Online_ActivityCount FROM Online_Activity
UNION ALL
SELECT COUNT(*) AS Customer_ServiceCount FROM Customer_Service
UNION ALL
SELECT COUNT(*) AS Churn_StatusCount FROM Churn_Status
UNION ALL
SELECT COUNT(*) AS Customer_DemoCount FROM Customer_Demo
UNION ALL
SELECT COUNT(*) AS Trans_HistoryCount FROM Trans_History;


---- 2: How many unique customers are there in total (based on the Customer_Demo table)?
SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM Customer_Demo;


---- 3: What is the overall churn rate?
SELECT
    SUM(ChurnStatus) AS TotalChurned,
    COUNT(CustomerID) AS TotalCustomers,
    (SUM(ChurnStatus) * 100.0 / COUNT(CustomerID)) AS ChurnRatePercentage
FROM Churn_Status;


---- 4: What are the distinct values and their counts for categorical columns in Customer_Demo?
SELECT Gender, COUNT(*) AS Count FROM Customer_Demo GROUP BY Gender;
SELECT MaritalStatus, COUNT(*) AS Count FROM Customer_Demo GROUP BY MaritalStatus;
SELECT IncomeLevel, COUNT(*) AS Count FROM Customer_Demo GROUP BY IncomeLevel;


---- 5: What are the distinct values and their counts for ServiceUsage in Online_Activity?
SELECT ServiceUsage, COUNT(*) AS Count
FROM Online_Activity
GROUP BY ServiceUsage;


---- 6: What are the distinct values and their counts for InteractionType and ResolutionStatus in Customer_Service?
SELECT InteractionType, COUNT(*) AS Count FROM Customer_Service GROUP BY InteractionType;
SELECT ResolutionStatus, COUNT(*) AS Count FROM Customer_Service GROUP BY ResolutionStatus;


---- 7: What are the distinct ProductCategory values and their counts in Trans_History?
SELECT ProductCategory, COUNT(*) AS Count
FROM Trans_History
GROUP BY ProductCategory;


---- 8: What is the date range for LastLoginDate, InteractionDate, and TransactionDate?
SELECT
    'Online_Activity' AS SourceTable,
    MIN(LastLoginDate) AS MinDate,
    MAX(LastLoginDate) AS MaxDate
FROM Online_Activity
UNION ALL
SELECT
    'Customer_Service' AS SourceTable,
    MIN(InteractionDate) AS MinDate,
    MAX(InteractionDate) AS MaxDate
FROM Customer_Service
UNION ALL
SELECT
    'Trans_History' AS SourceTable,
    MIN(TransactionDate) AS MinDate,
    MAX(TransactionDate) AS MaxDate
FROM Trans_History;


---- 9: What is the churn rate by Gender?
SELECT
    d.Gender,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Customer_Demo d
JOIN Churn_Status cs ON d.CustomerID = cs.CustomerID
GROUP BY d.Gender;


---- 10: What is the churn rate by MaritalStatus?
SELECT
    d.MaritalStatus,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Customer_Demo d
JOIN Churn_Status cs ON d.CustomerID = cs.CustomerID
GROUP BY d.MaritalStatus;


---- 11: What is the churn rate by IncomeLevel?
SELECT
    d.IncomeLevel,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Customer_Demo d
JOIN Churn_Status cs ON d.CustomerID = cs.CustomerID
GROUP BY d.IncomeLevel
ORDER BY ChurnRatePercentage DESC;


---- 12: What is the churn rate by Age group? 
SELECT
    CASE
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN d.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN d.Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN d.Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS AgeGroup,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Customer_Demo d
JOIN Churn_Status cs ON d.CustomerID = cs.CustomerID
GROUP BY AgeGroup
ORDER BY AgeGroup;


---- 13: What is the average LoginFrequency for churned vs. non-churned customers?
SELECT
    cs.ChurnStatus,
    AVG(oa.LoginFrequency) AS AvgLoginFrequency
FROM Online_Activity oa
JOIN Churn_Status cs ON oa.CustomerID = cs.CustomerID
GROUP BY cs.ChurnStatus;


---- 14: What is the churn rate by ServiceUsage?
SELECT
    oa.ServiceUsage,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Online_Activity oa
JOIN Churn_Status cs ON oa.CustomerID = cs.CustomerID
GROUP BY oa.ServiceUsage
ORDER BY ChurnRatePercentage DESC;


---- 15: How does LastLoginDate recency (days since last login, relative to a reference date like '2023-12-31') differ for churned vs. non-churned customers?
SELECT
    cs.ChurnStatus,
    AVG(JULIANDAY('2023-12-31') - JULIANDAY(oa.LastLoginDate)) AS AvgDaysSinceLastLogin
FROM Online_Activity oa
JOIN Churn_Status cs ON oa.CustomerID = cs.CustomerID
GROUP BY cs.ChurnStatus;


---- 16: What is the average total AmountSpent and average number of transactions for churned vs. non-churned customers (from Trans_History, which is 2022 data)?
WITH CustomerSpending AS (
    SELECT
        CustomerID,
        SUM(AmountSpent) AS TotalAmountSpent,
        COUNT(TransactionID) AS NumberOfTransactions
    FROM Trans_History
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(cst.TotalAmountSpent) AS AvgTotalSpent,
    AVG(cst.NumberOfTransactions) AS AvgNumberOfTransactions
FROM Churn_Status cs
LEFT JOIN CustomerSpending cst ON cs.CustomerID = cst.CustomerID
GROUP BY cs.ChurnStatus;


---- 17: What is the churn rate for customers based on their most frequently purchased ProductCategory in 2022?
WITH CustomerFavCategory AS (
    SELECT
        CustomerID,
        ProductCategory,
        COUNT(*) AS PurchaseCount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) as rn
    FROM Trans_History
    GROUP BY CustomerID, ProductCategory
)
SELECT
    cfc.ProductCategory AS FavoriteCategory,
    COUNT(DISTINCT cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(DISTINCT cs.CustomerID)) AS ChurnRatePercentage
FROM CustomerFavCategory cfc
JOIN Churn_Status cs ON cfc.CustomerID = cs.CustomerID
WHERE cfc.rn = 1 -- Only take the top category
GROUP BY cfc.ProductCategory
ORDER BY ChurnRatePercentage DESC;


---- 18: How does the average time since the last transaction (recency from Trans_History data, relative to '2022-12-31') differ for churned vs. non-churned customers?
WITH LastTransaction AS (
    SELECT
        CustomerID,
        MAX(TransactionDate) AS LastTransactionDate
    FROM Trans_History
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(JULIANDAY('2022-12-31') - JULIANDAY(lt.LastTransactionDate)) AS AvgDaysSinceLastTransaction
FROM Churn_Status cs
LEFT JOIN LastTransaction lt ON cs.CustomerID = lt.CustomerID
GROUP BY cs.ChurnStatus;


---- 19: What is the average number of customer service interactions for churned vs. non-churned customers (from Customer_Service data, which is 2022)?
WITH InteractionCounts AS (
    SELECT
        CustomerID,
        COUNT(InteractionID) AS NumberOfInteractions
    FROM Customer_Service
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(COALESCE(ic.NumberOfInteractions, 0)) AS AvgInteractions -- COALESCE for customers with no interactions
FROM Churn_Status cs
LEFT JOIN InteractionCounts ic ON cs.CustomerID = ic.CustomerID
GROUP BY cs.ChurnStatus;


---- 20: What is the churn rate by InteractionType (considering customers who had at least one interaction)?
-- Option 1: Churn rate for customers whose *latest* interaction was of a certain type
WITH LatestInteraction AS (
    SELECT
        CustomerID,
        InteractionType,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InteractionDate DESC) as rn
    FROM Customer_Service
)
SELECT
    li.InteractionType,
    COUNT(DISTINCT cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(DISTINCT cs.CustomerID)) AS ChurnRatePercentage
FROM LatestInteraction li
JOIN Churn_Status cs ON li.CustomerID = cs.CustomerID
WHERE li.rn = 1
GROUP BY li.InteractionType
ORDER BY ChurnRatePercentage DESC;


-- Option 2: Churn rate for customers who had *any* interaction of a certain type
SELECT
    cserv.InteractionType,
    COUNT(DISTINCT cs.CustomerID) AS TotalCustomersWithType,
    SUM(cs.ChurnStatus) AS ChurnedCustomersWithType,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(DISTINCT cs.CustomerID)) AS ChurnRateForType
FROM Customer_Service cserv
JOIN Churn_Status cs ON cserv.CustomerID = cs.CustomerID
GROUP BY cserv.InteractionType
ORDER BY ChurnRateForType DESC;


---- 21: What is the churn rate based on whether customers had any Unresolved service interactions?
WITH UnresolvedCustomers AS (
    SELECT DISTINCT CustomerID
    FROM Customer_Service
    WHERE ResolutionStatus = 'Unresolved'
)
SELECT
    CASE
        WHEN uc.CustomerID IS NOT NULL THEN 'Had Unresolved Interaction'
        ELSE 'No Unresolved Interaction / No Interaction'
    END AS UnresolvedStatusGroup,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Churn_Status cs
LEFT JOIN UnresolvedCustomers uc ON cs.CustomerID = uc.CustomerID
GROUP BY UnresolvedStatusGroup
ORDER BY ChurnRatePercentage DESC;


---- 22: For customers who had complaints, what is the churn rate based on whether their latest complaint was resolved or unresolved?
WITH LatestComplaintStatus AS (
    SELECT
        CustomerID,
        ResolutionStatus,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InteractionDate DESC) as rn
    FROM Customer_Service
    WHERE InteractionType = 'Complaint'
)
SELECT
    lcs.ResolutionStatus AS LatestComplaintResolution,
    COUNT(cs.CustomerID) AS TotalCustomersWithComplaints,
    SUM(cs.ChurnStatus) AS ChurnedCustomersWithComplaints,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM LatestComplaintStatus lcs
JOIN Churn_Status cs ON lcs.CustomerID = cs.CustomerID
WHERE lcs.rn = 1
GROUP BY lcs.ResolutionStatus
ORDER BY ChurnRatePercentage DESC;


---- 23: Identify high-value customers (e.g., top 25% by total AmountSpent in 2022) and their churn rate.
WITH CustomerTotalSpending AS (
    SELECT
        CustomerID,
        SUM(AmountSpent) AS TotalSpent
    FROM Trans_History
    GROUP BY CustomerID
),
RankedSpending AS (
    SELECT
        CustomerID,
        TotalSpent,
        NTILE(4) OVER (ORDER BY TotalSpent DESC) AS SpendingQuartile -- 1 is top 25%
    FROM CustomerTotalSpending
)
SELECT
    rs.SpendingQuartile,
    (CASE rs.SpendingQuartile
        WHEN 1 THEN 'Top 25%'
        WHEN 2 THEN '25-50%'
        WHEN 3 THEN '50-75%'
        ELSE 'Bottom 25%'
    END) AS SpendingSegment,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM RankedSpending rs
JOIN Churn_Status cs ON rs.CustomerID = cs.CustomerID
GROUP BY rs.SpendingQuartile
ORDER BY rs.SpendingQuartile;


---- 24: What is the profile (Age group, Gender, IncomeLevel) of customers who churned despite high login frequency (e.g., LoginFrequency > 30) in 2023?
SELECT
    CASE
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN d.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN d.Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN d.Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS AgeGroup,
    d.Gender,
    d.IncomeLevel,
    COUNT(*) AS CountOfHighlyActiveChurnedCustomers
FROM Customer_Demo d
JOIN Online_Activity oa ON d.CustomerID = oa.CustomerID
JOIN Churn_Status cs ON d.CustomerID = cs.CustomerID
WHERE cs.ChurnStatus = 1 AND oa.LoginFrequency > 30
GROUP BY AgeGroup, d.Gender, d.IncomeLevel
ORDER BY CountOfHighlyActiveChurnedCustomers DESC;


---- 25: Among customers who had unresolved complaints in 2022, what was their average AmountSpent in 2022, and what was their subsequent LoginFrequency in 2023 and churn status?
WITH UnresolvedComplaintCustomers AS (
    SELECT DISTINCT CustomerID
    FROM Customer_Service
    WHERE InteractionType = 'Complaint' AND ResolutionStatus = 'Unresolved'
)
SELECT
    ucc.CustomerID,
    SUM(th.AmountSpent) AS TotalSpent2022,
    COUNT(DISTINCT th.TransactionID) AS NumTransactions2022,
    oa.LoginFrequency AS LoginFrequency2023,
    oa.ServiceUsage AS ServiceUsage2023,
    STRFTIME('%Y-%m-%d', oa.LastLoginDate) AS LastLogin2023,
    cs.ChurnStatus
FROM UnresolvedComplaintCustomers ucc
LEFT JOIN Trans_History th ON ucc.CustomerID = th.CustomerID
LEFT JOIN Online_Activity oa ON ucc.CustomerID = oa.CustomerID
LEFT JOIN Churn_Status cs ON ucc.CustomerID = cs.CustomerID
GROUP BY ucc.CustomerID, oa.LoginFrequency, oa.ServiceUsage, oa.LastLoginDate, cs.ChurnStatus
ORDER BY cs.ChurnStatus DESC, TotalSpent2022 DESC;


---- 26: What is the average transaction value per customer for churned vs. non-churned customers in 2022?
WITH CustomerAvgTransactionValue AS (
    SELECT
        CustomerID,
        AVG(AmountSpent) AS AvgTransactionValue,
        SUM(AmountSpent) AS TotalSpent,
        COUNT(TransactionID) AS TransactionCount
    FROM Trans_History
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(catv.AvgTransactionValue) AS OverallAvgTransactionValuePerCustomer,
    AVG(catv.TotalSpent) AS OverallAvgTotalSpent,
    AVG(catv.TransactionCount) AS OverallAvgTransactionCount
FROM Churn_Status cs
LEFT JOIN CustomerAvgTransactionValue catv ON cs.CustomerID = catv.CustomerID
GROUP BY cs.ChurnStatus;


---- 27: For each ProductCategory, what is the total revenue generated, the number of unique customers purchasing from it, and the average amount spent per transaction in that category (2022 data)?
SELECT
    ProductCategory,
    SUM(AmountSpent) AS TotalRevenue,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    AVG(AmountSpent) AS AvgAmountPerTransaction
FROM Trans_History
GROUP BY ProductCategory
ORDER BY TotalRevenue DESC;


---- 28: What is the churn rate for customers whose average transaction value in 2022 was in the bottom 25%, middle 50%, and top 25%?
WITH CustomerAvgTransactionValue AS (
    SELECT
        CustomerID,
        AVG(AmountSpent) AS AvgTxnValue
    FROM Trans_History
    GROUP BY CustomerID
    HAVING COUNT(TransactionID) > 0 -- Ensure they made at least one transaction
),
RankedAvgTxnValue AS (
    SELECT
        CustomerID,
        AvgTxnValue,
        NTILE(4) OVER (ORDER BY AvgTxnValue) AS TxnValueQuartile -- 1 is bottom 25%, 4 is top 25%
    FROM CustomerAvgTransactionValue
)
SELECT
    rat.TxnValueQuartile,
    CASE rat.TxnValueQuartile
        WHEN 1 THEN 'Bottom 25%'
        WHEN 2 THEN '25-50%'
        WHEN 3 THEN '50-75%'
        ELSE 'Top 25%'
    END AS AvgTxnValueSegment,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM RankedAvgTxnValue rat
JOIN Churn_Status cs ON rat.CustomerID = cs.CustomerID
GROUP BY rat.TxnValueQuartile
ORDER BY rat.TxnValueQuartile;


---- 29: Identify customers who made purchases in multiple (e.g., 3 or more) distinct product categories in 2022. What is their churn rate?
WITH DiverseShoppers AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT ProductCategory) AS DistinctCategoriesPurchased
    FROM Trans_History
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT ProductCategory) >= 3
)
SELECT
    'Diverse Shoppers (3+ Categories)' AS CustomerSegment,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM DiverseShoppers ds
JOIN Churn_Status cs ON ds.CustomerID = cs.CustomerID;


---- 30: What is the average number of days between customer service interactions for customers who had multiple interactions in 2022? How does this differ for churned vs. non-churned customers?
WITH CustomerInteractionsRanked AS (
    SELECT
        CustomerID,
        InteractionDate,
        LAG(InteractionDate, 1) OVER (PARTITION BY CustomerID ORDER BY InteractionDate) AS PreviousInteractionDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InteractionDate) as rn,
        COUNT(*) OVER (PARTITION BY CustomerID) as total_interactions
    FROM Customer_Service
),
InteractionGaps AS (
    SELECT
        CustomerID,
        JULIANDAY(InteractionDate) - JULIANDAY(PreviousInteractionDate) AS DaysBetweenInteractions
    FROM CustomerInteractionsRanked
    WHERE PreviousInteractionDate IS NOT NULL AND total_interactions > 1
)
SELECT
    cs.ChurnStatus,
    AVG(ig.DaysBetweenInteractions) AS AvgDaysBetweenInteractions
FROM InteractionGaps ig
JOIN Churn_Status cs ON ig.CustomerID = cs.CustomerID
GROUP BY cs.ChurnStatus;


---- 31: For customers who had complaints in 2022, what percentage of their complaints were resolved? How does this relate to churn?
WITH ComplaintResolutionStats AS (
    SELECT
        CustomerID,
        SUM(CASE WHEN ResolutionStatus = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedComplaints,
        COUNT(InteractionID) AS TotalComplaints,
        (SUM(CASE WHEN ResolutionStatus = 'Resolved' THEN 1 ELSE 0 END) * 100.0 / COUNT(InteractionID)) AS PctComplaintsResolved
    FROM Customer_Service
    WHERE InteractionType = 'Complaint'
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(crs.PctComplaintsResolved) AS AvgPctComplaintsResolved
FROM ComplaintResolutionStats crs
JOIN Churn_Status cs ON crs.CustomerID = cs.CustomerID
GROUP BY cs.ChurnStatus;


---- 32: Identify customers who had interactions of different types (e.g., an Inquiry followed by a Complaint). What is their churn rate?
WITH InteractionSequence AS (
    SELECT
        CustomerID,
        InteractionType,
        LEAD(InteractionType, 1) OVER (PARTITION BY CustomerID ORDER BY InteractionDate) AS NextInteractionType
    FROM Customer_Service
),
CustomersWithSequence AS (
    SELECT DISTINCT CustomerID
    FROM InteractionSequence
    WHERE InteractionType = 'Inquiry' AND NextInteractionType = 'Complaint'
)
SELECT
    'Inquiry then Complaint' AS InteractionPattern,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM CustomersWithSequence cws
JOIN Churn_Status cs ON cws.CustomerID = cs.CustomerID;


---- 33: How many customers made their last transaction in 2022 in Q1, Q2, Q3, or Q4? What is the churn rate for each of these groups?
WITH LastTransactionQuarter AS (
    SELECT
        CustomerID,
        MAX(TransactionDate) AS LastTxnDate,
        CASE
            WHEN STRFTIME('%m', MAX(TransactionDate)) IN ('01', '02', '03') THEN 'Q1'
            WHEN STRFTIME('%m', MAX(TransactionDate)) IN ('04', '05', '06') THEN 'Q2'
            WHEN STRFTIME('%m', MAX(TransactionDate)) IN ('07', '08', '09') THEN 'Q3'
            ELSE 'Q4'
        END AS LastTransactionQuarter2022
    FROM Trans_History
    GROUP BY CustomerID
)
SELECT
    ltq.LastTransactionQuarter2022,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM LastTransactionQuarter ltq
JOIN Churn_Status cs ON ltq.CustomerID = cs.CustomerID
GROUP BY ltq.LastTransactionQuarter2022
ORDER BY ltq.LastTransactionQuarter2022;



---- 34: Compare the average LoginFrequency in 2023 for customers who had unresolved service issues in 2022 versus those who had all issues resolved or no issues.
WITH CustomerServiceSummary AS (
    SELECT
        CustomerID,
        MAX(CASE WHEN ResolutionStatus = 'Unresolved' THEN 1 ELSE 0 END) AS HadUnresolvedIssue
        -- MAX will be 1 if any interaction was unresolved, 0 otherwise (for customers with interactions)
    FROM Customer_Service
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN css.CustomerID IS NULL THEN 'No Service Interactions' -- Customer not in Customer_Service
        WHEN css.HadUnresolvedIssue = 1 THEN 'Had Unresolved Issue 2022'
        ELSE 'All Issues Resolved 2022'
    END AS ServiceHistoryGroup,
    AVG(oa.LoginFrequency) AS AvgLoginFrequency2023,
    COUNT(DISTINCT oa.CustomerID) as NumCustomersInGroup
FROM Online_Activity oa
LEFT JOIN CustomerServiceSummary css ON oa.CustomerID = css.CustomerID
GROUP BY ServiceHistoryGroup
ORDER BY AvgLoginFrequency2023 DESC;


---- 35: What is the average number of days between a customer's last transaction in 2022 and their last login in 2023, for churned vs. non-churned customers?
WITH LastTransaction2022 AS (
    SELECT
        CustomerID,
        MAX(TransactionDate) AS MaxTransactionDate
    FROM Trans_History
    GROUP BY CustomerID
)
SELECT
    cs.ChurnStatus,
    AVG(JULIANDAY(oa.LastLoginDate) - JULIANDAY(lt.MaxTransactionDate)) AS AvgDaysBetweenLastTxnAndLastLogin
FROM Churn_Status cs
JOIN Online_Activity oa ON cs.CustomerID = oa.CustomerID
JOIN LastTransaction2022 lt ON cs.CustomerID = lt.CustomerID
WHERE oa.LastLoginDate IS NOT NULL AND lt.MaxTransactionDate IS NOT NULL -- Ensure both dates exist
GROUP BY cs.ChurnStatus;



---- 36: Create a customer segment based on 2022 spending (High/Medium/Low) and 2023 Login Frequency (High/Medium/Low). What's the churn rate for each segment?
WITH CustomerSpendingTier AS (
    SELECT
        CustomerID,
        NTILE(3) OVER (ORDER BY SUM(AmountSpent) DESC) AS SpendingTier2022 -- 1=High, 2=Med, 3=Low
    FROM Trans_History
    GROUP BY CustomerID
),
CustomerLoginTier AS (
    SELECT
        CustomerID,
        NTILE(3) OVER (ORDER BY LoginFrequency DESC) AS LoginTier2023 -- 1=High, 2=Med, 3=Low
    FROM Online_Activity
)
SELECT
    CASE cst.SpendingTier2022
        WHEN 1 THEN 'High Spending'
        WHEN 2 THEN 'Medium Spending'
        ELSE 'Low Spending'
    END AS SpendingSegment,
    CASE clt.LoginTier2023
        WHEN 1 THEN 'High Login Freq'
        WHEN 2 THEN 'Medium Login Freq'
        ELSE 'Low Login Freq'
    END AS LoginSegment,
    COUNT(cs.CustomerID) AS TotalCustomers,
    SUM(cs.ChurnStatus) AS ChurnedCustomers,
    (SUM(cs.ChurnStatus) * 100.0 / COUNT(cs.CustomerID)) AS ChurnRatePercentage
FROM Churn_Status cs
LEFT JOIN CustomerSpendingTier cst ON cs.CustomerID = cst.CustomerID
LEFT JOIN CustomerLoginTier clt ON cs.CustomerID = clt.CustomerID
WHERE cst.SpendingTier2022 IS NOT NULL AND clt.LoginTier2023 IS NOT NULL -- Focus on customers with data in both
GROUP BY SpendingSegment, LoginSegment
ORDER BY ChurnRatePercentage DESC, SpendingSegment, LoginSegment;


---- 37: Who are the customers (list CustomerIDs) who churned, had a high login frequency (>30 in 2023), but also had an unresolved complaint in 2022? What are their demographics?
WITH ChurnedHighActivityUnresolved AS (
    SELECT DISTINCT cs.CustomerID
    FROM Churn_Status cs
    JOIN Online_Activity oa ON cs.CustomerID = oa.CustomerID
    JOIN Customer_Service cserv ON cs.CustomerID = cserv.CustomerID
    WHERE cs.ChurnStatus = 1
      AND oa.LoginFrequency > 30
      AND cserv.InteractionType = 'Complaint'
      AND cserv.ResolutionStatus = 'Unresolved'
)
SELECT
    chau.CustomerID,
    cd.Age,
    cd.Gender,
    cd.MaritalStatus,
    cd.IncomeLevel
FROM ChurnedHighActivityUnresolved chau
JOIN Customer_Demo cd ON chau.CustomerID = cd.CustomerID;


---- 38: What is the most common ServiceUsage (2023) for customers who spent the most on Electronics in 2022 and eventually churned?
WITH TopElectronicsSpenders2022 AS (
    SELECT
        CustomerID,
        SUM(AmountSpent) AS TotalElectronicsSpend
    FROM Trans_History
    WHERE ProductCategory = 'Electronics'
    GROUP BY CustomerID
    ORDER BY TotalElectronicsSpend DESC
    LIMIT (SELECT COUNT(DISTINCT CustomerID)/4 FROM Trans_History WHERE ProductCategory = 'Electronics') -- Top 25%
)
SELECT
    oa.ServiceUsage,
    COUNT(DISTINCT tes.CustomerID) AS CountOfChurnedTopElectronicsSpenders
FROM TopElectronicsSpenders2022 tes
JOIN Churn_Status cs ON tes.CustomerID = cs.CustomerID
JOIN Online_Activity oa ON tes.CustomerID = oa.CustomerID
WHERE cs.ChurnStatus = 1
GROUP BY oa.ServiceUsage
ORDER BY CountOfChurnedTopElectronicsSpenders DESC;