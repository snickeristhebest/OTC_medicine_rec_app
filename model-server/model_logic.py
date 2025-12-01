# model_logic.py
import os
import numpy as np
import pandas as pd
from transformers import BertTokenizer, TFBertModel
import tensorflow as tf
from sklearn.metrics.pairwise import cosine_similarity
import re

CATEGORY_KEYWORDS = {
    'pain_fever': ['pain', 'fever', 'ache', 'headache', 'relief'],
    'cold_flu': ['cold', 'flu', 'cough', 'congestion', 'sore throat'],
    'allergy': ['allergy', 'sneeze', 'itchy', 'loratadine'],
    'skin': ['rash', 'irritation', 'cream', 'eczema'],
    'acne': ['acne', 'pimple', 'salicylic acid'],
    'digestive': ['stomach', 'nausea', 'heartburn'],
    'sunscreen': ['sunscreen', 'sunburn', 'spf', 'uv'],
}

SYMPTOM_TO_CATEGORY = {
    'headache': ['pain_fever', 'cold_flu'],
    'fever': ['pain_fever', 'cold_flu'],
    'pain': ['pain_fever'],
    'ache': ['pain_fever'],
    'migraine': ['pain_fever'],
    'cold': ['cold_flu'],
    'flu': ['cold_flu'],
    'cough': ['cold_flu'],
    'congestion': ['cold_flu'],
    'sore throat': ['cold_flu'],
    'runny nose': ['cold_flu'],
    'allergy': ['allergy'],
    'sneeze': ['allergy'],
    'itchy eyes': ['allergy'],
    'watery eyes': ['allergy'],
    'hay fever': ['allergy'],
    'rash': ['skin'],
    'itch': ['skin', 'allergy'],
    'eczema': ['skin'],
    'acne': ['acne'],
    'nausea': ['digestive'],
    'stomach': ['digestive'],
    'heartburn': ['digestive'],
    'diarrhea': ['digestive'],
    'indigestion': ['digestive'],
    'constipation': ['digestive'],
    'sunburn': ['sunscreen'],
}

def get_relevant_categories(symptoms):
    s = symptoms.lower()
    cats = set()
    for symptom, mapped in SYMPTOM_TO_CATEGORY.items():
        if symptom in s:
            cats.update(mapped)
    return list(cats) if cats else ['unknown']

def parse_warning_reasons(row, age=None, pregnant=False, breastfeeding=False):
    warnings = str(row.get('warnings', '')).lower()
    reasons = []
    age_matches = re.findall(r'children under (\d+)', warnings)
    if age_matches and age is not None:
        min_age = int(age_matches[0])
        if age < min_age:
            reasons.append(f"Not suitable for children under {min_age}")
    if pregnant and ('pregnancy' in warnings or 'pregnant' in warnings):
        reasons.append("Contraindicated during pregnancy")
    if breastfeeding and ('breastfeeding' in warnings or 'nursing' in warnings):
        reasons.append("Contraindicated during breastfeeding")
    return reasons

class Recommender:
    def __init__(self, df, embeddings, bert_name="bert-base-uncased"):
        self.df = df.reset_index(drop=True)
        self.embeddings = embeddings
        self.tokenizer = BertTokenizer.from_pretrained(bert_name)
        self.model = TFBertModel.from_pretrained(bert_name)


    def embed_user(self, text):
        inputs = self.tokenizer([text], max_length=128, truncation=True, padding=True, return_tensors='tf')
        outputs = self.model(inputs)
        return outputs.last_hidden_state[:, 0, :].numpy()

    def filter_warnings(self, df, age, preg, breast):
        rec, not_rec = [], []
        for _, row in df.iterrows():
            reasons = parse_warning_reasons(row, age, preg, breast)
            data = row.to_dict()
            if reasons:
                data["warning_reasons"] = "; ".join(reasons)
                not_rec.append(data)
            else:
                rec.append(data)
        return pd.DataFrame(rec), pd.DataFrame(not_rec)

    def recommend(self, symptoms, age=None, pregnant=False, breastfeeding=False, top_k=5):
        cats = get_relevant_categories(symptoms)
        df = self.df[self.df['rule_category'].isin(cats)] if 'unknown' not in cats else self.df
        if df.empty:
            df = self.df

        user_emb = self.embed_user(symptoms)
        idx = df.index.tolist()
        sims = cosine_similarity(user_emb, self.embeddings[idx])[0]
        df = df.copy()
        df["similarity"] = sims
        df = df.sort_values(by="similarity", ascending=False)

        rec, not_rec = self.filter_warnings(df, age, pregnant, breastfeeding)
        return rec.head(top_k), not_rec.head(top_k)
