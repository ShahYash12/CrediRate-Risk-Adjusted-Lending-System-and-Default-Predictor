# 🏦 CrediRiskIQ – Credit Risk Prediction & ROI Engine

This repository contains an end-to-end predictive analytics solution tailored for the banking and financial lending sector. It predicts an applicant’s **credit risk**, assigns a **personalized interest rate** based on risk/reward principles, and recommends an **optimal loan approval amount**. This tool enables financial institutions to make accurate, real-time lending decisions.

---

## 🚀 Project Overview

**CrediRiskIQ** is an automated credit scoring system built in **R** and integrated with a **web application** that serves as a live data source. The system automatically performs **data cleaning, transformation, analysis**, and **model inference** in real-time—providing financial decision-makers with instant insights and recommendations.

It predicts:
- Probability of loan default
- Risk-adjusted interest rate
- Suggested loan sanction amount

Final model: **Random Forest**, with **94% accuracy** and **98% defaulter precision**.

---

## 🔧 Features

- ✅ Real-time loan risk prediction via web input
- 🔄 Automated ETL pipeline from user input to model scoring
- 📈 Personalized rate of interest
- 🏦 Optimal loan amount recommendation
- 📊 Visual analytics for interpretability

---

## 📁 Repository Structure

```
CrediRiskIQ/
│
├── data/                     # Sample input data
├── notebooks/                # R scripts & model development
├── src/                      # Data processing & prediction scripts
├── visualizations/           # Risk and feature importance plots
├── requirements.txt          # Required R packages
└── README.md
```

---

## 📊 Modeling Approach

We experimented with various models in R:
- Linear Regression
- Logistic Regression
- Decision Tree Classifier
- Best Subset Selection
- ✅ **Random Forest Classifier** (final choice)

**Metrics:**
- Accuracy: **94%**
- Precision (defaulter flagging): **98%**

---

## 📈 Visual Insights

Created using `ggplot2`, these include:
- Feature Importance
- Risk Distribution
- Correlation Heatmaps

---

## 🔄 Workflow

1. User enters data via web app
2. Data is validated, cleaned, and transformed
3. Features are passed into ML model for prediction
4. Output: Risk %, Interest Rate, Loan Amount
5. Real-time visual feedback and flags

---

## 🛠 Tools Used

- R (tidyverse, caret, randomForest)
- RMarkdown / RStudio
- ggplot2
- Web integration for input (e.g., Shiny or API)
- Git & GitHub

---

## 📌 How to Use

1. Clone the repository
2. Install dependencies via R or `renv`
3. Run R scripts or deploy via connected web application
4. Input user data → Get risk prediction and loan recommendation

---

## 🌐 Live Data Integration

Yes – CrediRiskIQ connects to live data via:
- Web interface (e.g., Shiny or REST API)
Where we used the following prompt


library(httr)
library(jsonlite)

response <- GET("https://api.example.com/data")
data <- fromJSON(content(response, "text"))



---

## 💡 Future Enhancements

- Expand input features with behavioral data
- Add explainability via SHAP or DALEX
- Deploy as full-scale Shiny dashboard

---

## 📫 Contact

Created by **[Your Name]**  
For inquiries or feedback, connect via [LinkedIn/GitHub].

---
