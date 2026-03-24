from fastapi import FastAPI
import joblib
import pandas as pd

app = FastAPI()
model = joblib.load("model.pkl")

@app.post("/predict")
def predict(
    depth: float = 50,
    width: float = 80,
    height: float = 40,
    category: str = "Sofas & armchairs",
    other_colors: int = 1
):
    # create volume (IMPORTANT)
    volume = depth * width * height

    input_data = pd.DataFrame([{
        "depth": depth,
        "width": width,
        "height": height,
        "volume": volume,
        "category": category,
        "other_colors": other_colors
    }])

    prediction = model.predict(input_data)

    return {"predicted_price": float(prediction[0])}