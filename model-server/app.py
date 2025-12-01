# app.py
import os
import numpy as np
import pandas as pd
from flask import Flask, request, jsonify
from google.cloud import storage
from model_logic import Recommender

BUCKET = "otc_data"
PREFIX = "artifacts/otc"

app = Flask(__name__)

def download_file(blob_name, local_path):
    client = storage.Client()
    bucket = client.bucket(BUCKET)
    blob = bucket.blob(blob_name)
    blob.download_to_filename(local_path)
    print("Downloaded:", blob_name)

print("Starting up — downloading artifacts...")

os.makedirs("/tmp/artifacts", exist_ok=True)
emb_local = "/tmp/artifacts/embeddings.npy"
df_local = "/tmp/artifacts/df_cleaned.csv"

download_file(f"{PREFIX}/embeddings.npy", emb_local)
download_file(f"{PREFIX}/df_cleaned.csv", df_local)

embeddings = np.load(emb_local)
df = pd.read_csv(df_local)

print("Initializing recommender...")
recommender = Recommender(df, embeddings)
print("Recommender ready!")

@app.route("/")
def home():
    return "OTC Recommender API is running."

@app.route("/recommend", methods=["POST"])
def recommend():
    data = request.json
    symptoms = data.get("query") or data.get("symptoms")
    age = data.get("age")
    pregnant = data.get("pregnant", False)
    breastfeeding = data.get("breastfeeding", False)
    top_k = data.get("top_k", 5)

    if not symptoms:
        return jsonify({"error": "query (symptoms) missing"}), 400

    rec, not_rec = recommender.recommend(symptoms, age, pregnant, breastfeeding, top_k)

    return jsonify({
        "recommended": rec.to_dict(orient="records"),
        "not_recommended": not_rec.to_dict(orient="records")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
