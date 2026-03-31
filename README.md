# Ikea Furniture Price Prediction

## Project Overview

This project analyzes factors influencing furniture prices and builds a machine learning model to predict product prices using the IKEA dataset.

End-to-end machine learning project that predicts furniture prices based on product features.

**The project covers:**

- End-to-end ML pipeline from data analysis to deployment
- Reproducible infrastructure using Terraform
- Containerized API with Docker
- Reverse proxy setup using Nginx
- HTTPS secured with Let's Encrypt
- Public deployment accessible via custom domain

## Live Access
API is publicly available via a custom domain with HTTPS enabled:
[https://annastr.com/docs](https://annastr.com/docs)

## Architecture
The trained ML pipeline is served via a FastAPI application running inside a Docker container.

Infrastructure is provisioned using Terraform on AWS EC2. Nginx is used as a reverse proxy, and HTTPS is enabled using Certbot.

The API returns a predicted price based on input features using the trained pipeline.
```
User → Domain → nginx → FastAPI (Docker) → ML model
```
#### ML Model Details
- **Features:** dimensions, category, color availability
- **Feature engineering:** volume calculation
- **Pipeline:** preprocessing + model
- **Output:** predicted price in EUR

## Project Structure

- `ikea_price_prediction.ipynb` — data analysis and model training
- `app.py` — FastAPI application for serving predictions
- `model.pkl` — trained model pipeline
- `data/ikea.csv` — dataset
- `Dockerfile`
- `terraform/` - infrastructure (AWS EC2, security groups)
  - `main.tf` — infrastructure definition
  - `user_data.sh` — EC2 initialization script (Docker install, API container run, Nginx install and configuration, certbot install)

## Local Run

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
## Deployment

The infrastructure is provisioned on AWS EC2 using Terraform.

Deployment steps:
- Infrastructure provisioning with Terraform
- Docker container runs FastAPI application
- Nginx configured as reverse proxy
- Domain connected via Route 53
- HTTPS enabled using Certbot

The setup is fully reproducible and can be recreated with:

```bash
terraform apply
```
Due to the use of a dynamic public IP (no Elastic IP), DNS configuration and SSL issuance are performed manually after deployment.
## API Example
```json
POST /predict

{
  "depth": 50,
  "width": 80,
  "height": 40,
  "category": "Sofas & armchairs",
  "other_colors": 1
}
```
Response:
```json
{
  "predicted_price_eur": 70.46,
  "currency": "EUR (€)",
  "units": "cm"
}
```
# ML Model Description

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

## Tech Stack
- Python
- Pandas, NumPy
- Matplotlib, Seaborn
- Scikit-learn
- SciPy
- FastAPI
- Docker
- Terraform, AWS EC2, Route 53
- Nginx
- Certbot