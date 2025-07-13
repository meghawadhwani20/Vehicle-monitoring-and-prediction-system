from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np
from datetime import datetime
import joblib
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load your trained model (replace with your actual model path)
# model = joblib.load('traffic_model.pkl')

# Load your traffic data
df = pd.read_csv('data/new_vehicle_data.csv')

def predict_traffic(location, date, time):
    try:
        # Convert inputs to datetime
        input_datetime = datetime.strptime(f"{date} {time}", "%Y-%m-%d %H:%M")
        
        # Filter data for the given location
        location_data = df[df['location'] == location]
        
        if location_data.empty:
            return {
                "error": "No data available for this location"
            }
        
        # Calculate average speed for similar times
        similar_times = location_data[
            (location_data['time'].str[:2] == time[:2])  # Same hour
        ]
        
        if similar_times.empty:
            return {
                "error": "No historical data for this time"
            }
        
        avg_speed = similar_times['currentSpeed'].mean()
        avg_free_flow = similar_times['freeFlowSpeed'].mean()
        
        # Calculate traffic status
        if avg_speed >= avg_free_flow * 0.8:
            status = "LOW"
        elif avg_speed >= avg_free_flow * 0.5:
            status = "MEDIUM"
        else:
            status = "HIGH"
        
        return {
            "averageSpeed": round(avg_speed, 2),
            "averageDelay": round(avg_free_flow - avg_speed, 2),
            "trafficStatus": status
        }
        
    except Exception as e:
        return {
            "error": str(e)
        }

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    location = data.get('location')
    date = data.get('date')
    time = data.get('time')
    
    if not all([location, date, time]):
        return jsonify({"error": "Missing required parameters"}), 400
    
    result = predict_traffic(location, date, time)
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True, port=5000) 