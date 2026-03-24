# Ikea Furniture Price Prediction

## Project Overview

This project analyzes factors influencing furniture prices and builds a machine learning model to predict product prices using the IKEA dataset.

The solution combines data analysis, statistical validation, and a production-ready ML pipeline exposed via an API.


## Project Structure

- `ikea_price_prediction.ipynb` — data analysis and model training
- `app.py` — FastAPI application for serving predictions
- `model.pkl` — trained model pipeline
- `data/ikea.csv` — dataset

## How to Run

Install dependencies:
```bash
pip install -r requirements.txt
```
Run API:
```bash
uvicorn app:app --reload
```
Open interactive docs:
```
http://127.0.0.1:8000/docs
```

## Key Objective
The goal is to understand what drives furniture pricing and build a model capable of estimating product prices based on product characteristics.

## Data Preparation
- Removed duplicates and irrelevant columns (`item_id`, `link`)
- Handled missing values (simple removal for EDA, imputation in pipeline for modeling)
- Converted categorical feature `other_colors` to numeric
- Created feature: **volume (depth × height × width)** for analysis

## Exploratory Data Analysis
* Analyzed distributions of price and product dimensions
* Identified imbalance across 17 product categories
* Explored relationships between features using mutual information
* Visualized data using histograms and distribution plots

## Statistical Analysis
Tested whether product color variation affects price:

* Test used: Mann–Whitney U (non-parametric)
* Reason: price distribution is not normal
* Result: statistically significant difference between groups (p < 0.05)

## Machine Learning

The final solution uses a RandomForestRegressor combined with a preprocessing pipeline.

### Pipeline Design
* Numerical features:
   * missing value imputation (median)
   * scaling (StandardScaler)
* Categorical features:
   * missing value imputation (most frequent)
   * encoding (OneHotEncoder)

All transformations are encapsulated in a single Pipeline, ensuring consistency between training and inference.

## Key Insights
- Furniture dimensions strongly influence price
- Category plays a significant role in pricing
- Products with multiple colors show statistically different price distribution

## API

The trained pipeline was saved and exposed via a FastAPI endpoint, allowing real-time price prediction based on user input.

The API returns predicted price based on the trained pipeline.

This setup demonstrates how the model can be integrated into a real-world application.

Run API:
```bash
uvicorn app:app --reload
```
Open interactive docs:
```
http://127.0.0.1:8000/docs
```

## Tech Stack
- Python
- Pandas, NumPy
- Matplotlib, Seaborn
- Scikit-learn
- SciPy
- FastAPI