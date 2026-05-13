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

# Insight: Revenue grew consistently from 2016 to Nov 2017 — peaking at ~4.8M. Then a sudden crash after Aug 2018.
# Action: Investigate the Aug 2018 crash — did a competitor enter, was there a policy change, or is the data incomplete? 


2. Delivery delay vs Review Score

df2 = pd.read_sql("""
    SELECT 
        r.review_score,
        ROUND(AVG(DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        )), 0) AS avg_delay_days
    FROM orders_stage o
    JOIN order_reviews_stage r ON o.order_id = r.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY r.review_score
    ORDER BY r.review_score
""", engine)

df2['avg_delay_days'] = df2['avg_delay_days'].abs()
df2.columns = ['review_score', 'days_before_estimate']

plt.figure(figsize=(10, 5))
sns.barplot(x='review_score', y='days_before_estimate',
            data=df1, palette='RdYlGn')
plt.title('Days Delivered Before Estimate vs Review Score', 
          fontsize=14)
plt.xlabel('Review Score (1-5)')
plt.ylabel('Days Before Estimated Date')
plt.tight_layout()
plt.show()

del df2

<img width="989" height="490" alt="image" src="https://github.com/user-attachments/assets/e0b59dbb-902c-4994-bb9e-dbd2cda4f342" />

# Insight: Customers who received their orders before 12 days gives 5 star and those customers who received their orders before 4 days they give only 1 star 
# Action: Focus on reducing delivery delays and maintaining consistent delivery timelines, as faster and reliable deliveries are strongly associated with higher customer satisfaction and better review scores.


3. Top 10 Categories By Revenue

df3 = pd.read_sql("""
    SELECT 
        t.product_category_name_english,
        ROUND(SUM(p.payment_value), 2) AS revenue
    FROM order_items_stage oi  
    JOIN products_stage pr ON oi.product_id = pr.product_id
    JOIN product_category_translation_stage t ON pr.product_category_name = t.product_category_name
    JOIN order_payments_stage p ON oi.order_id = p.order_id
    GROUP BY t.product_category_name_english
    ORDER BY revenue DESC
    LIMIT 10
""", engine)

plt.figure(figsize=(10, 7))
ax = sns.barplot(data=df3, y='product_category_name_english', x='revenue',
                 palette='RdYlGn', orient='h',
                 order=df3.sort_values('revenue', ascending=True)['product_category_name_english'])
plt.title('Top 10 Categories by Revenue', fontsize=14)
plt.xlabel('Revenue', fontsize=12)
plt.ylabel('Category', fontsize=12)
plt.tight_layout()
plt.show()
del df3

<img width="990" height="690" alt="image" src="https://github.com/user-attachments/assets/b0e0e0c3-b5ed-40ca-adea-3bfb8a278d44" />

# Insight: Bed Bath Table (#1), Health Beauty (#2), Computers Accessories (#3) — these three categories are driving revenue.
# Action: Increase inventory and marketing investment in these three categories. Cool Stuff and Garden Tools are at the bottom — either
# improve or phase them out.


4. Payment Distribution by Type

df4 = pd.read_sql("""
    SELECT 
        payment_type,
        COUNT(*) AS total_orders,
        ROUND(AVG(payment_installments), 0) AS avg_installments,
        ROUND(SUM(payment_value), 0) AS total_revenue
    FROM order_payments_stage
    GROUP BY payment_type
""", engine)

fig, axes = plt.subplots(1, 3, figsize=(15, 5))
metrics = ['total_orders', 'avg_installments', 'total_revenue']
titles  = ['Total Orders', 'Avg Installments', 'Total Revenue']
colors  = ['#00e5b0', '#ff6b6b', '#4a90d9']

for ax, metric, title, color in zip(axes, metrics, titles, colors):
    sns.barplot(data=df4, x='payment_type', y=metric, color=color, ax=ax)
    ax.set_title(title, fontsize=12)
    ax.set_xlabel('')
    ax.set_ylabel('')
    ax.set_xticklabels(df4['payment_type'], rotation=30, ha='right')

plt.suptitle('Payment Distribution by Type', fontsize=14, y=1.02)
plt.tight_layout()
plt.show()
del df4

<img width="1489" height="515" alt="image" src="https://github.com/user-attachments/assets/95227ec0-ba40-4a7f-8533-76cae06ee222" />

# Insight: Credit card dominates — 150,000+ orders, avg 4x installments, 25M+ revenue. Boleto is second. Debit card usage is very low.
# Action: Offer EMI deals to credit card users — they already use 4 installments, increasing this will raise average order value.
# Incentivize Boleto users to migrate to credit cards.

5. Top 10 Fastest Sellers by Average Delivery Days

df5 = pd.read_sql("""
    SELECT 
        oi.seller_id,
        ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0) AS avg_delivery_days,
        COUNT(*) AS total_orders
    FROM orders_stage o
    JOIN order_items_stage oi ON o.order_id = oi.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id
    HAVING COUNT(*) > 50
    ORDER BY avg_delivery_days
""", engine)

df5_top = df5.head(10)

plt.figure(figsize=(10, 8))
ax = sns.barplot(data=df5_top, y='seller_id', x='avg_delivery_days', palette='RdYlGn' ,orient='h')
plt.title('Top 10 Fastest Sellers by Avg Delivery Days', fontsize=14)
plt.xlabel('Avg Delivery Days', fontsize=12)
plt.ylabel('Seller ID', fontsize=12)
plt.tight_layout()
plt.show()
del df5, df5_top

<img width="989" height="790" alt="image" src="https://github.com/user-attachments/assets/f601ae44-27f2-4d54-b8d1-8e2423080bdd" />

# Insight: Best sellers deliver in just 4-5 days
# Action: Have slow sellers adopt practices from these fast sellers. Give fast sellers a "Preferred Seller" badge — customers will choose them.


