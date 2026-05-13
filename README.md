# 📊 End-to-End E-Commerce Sales Analytics Project

An end-to-end data analytics project built using the Olist Brazilian E-Commerce dataset (~100K orders). The project focuses on analyzing sales performance, customer behavior, delivery efficiency, and seller operations to generate actionable business insights.

The workflow includes:

* Loading raw CSV data into MySQL
* Performing data cleaning and SQL transformations
* Writing analytical SQL queries for business analysis
* Conducting exploratory data analysis (EDA) using Python
* Creating visualizations using Matplotlib and Seaborn
* Building an interactive Power BI dashboard with KPIs, slicers, and DAX measures

## 🔧 Technologies Used

* Python
* MySQL
* Pandas
* Matplotlib
* Seaborn
* SQLAlchemy
* Power BI

## 📈 Key Analysis Performed

* Revenue trend analysis
* Delivery performance tracking
* Customer satisfaction analysis
* Repeat customer analysis
* Seller efficiency evaluation
* Payment behavior analysis
* Region-wise sales insights

## 🎯 Project Outcome

Developed a complete analytics workflow that transforms raw e-commerce data into meaningful business insights through SQL analysis, Python-based EDA, and interactive dashboard reporting.


## EDA Analysis

1. Montly Revenue

df1 = pd.read_sql("""
    SELECT 
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        ROUND(SUM(p.payment_value), 0) AS total_revenue
    FROM orders_stage o
    JOIN order_payments_stage p ON o.order_id = p.order_id
    GROUP BY year, month
    ORDER BY year, month
""", engine)

# Combine Year-Month For Readability

df1['period'] = df1['year'].astype(str) + '-' + df1['month'].astype(str).str.zfill(2)     # zfill => jahan date single digit hogi wahan aage 0 lagayega

plt.figure(figsize=(14, 6))
sns.lineplot(data=df7, x='period', y='total_revenue', color='orange', marker='o')
plt.title('Monthly Revenue Trend', fontsize=14)
plt.xlabel('Month', fontsize=12)
plt.ylabel('Total Revenue', fontsize=12)
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()
del df1

<img width="1389" height="590" alt="Monthly Revenue Trend" src="https://github.com/user-attachments/assets/0a796f64-5086-4892-9a91-88b045be021b" />

