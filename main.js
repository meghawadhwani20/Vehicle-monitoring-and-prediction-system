document.getElementById('predictionForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    // UI Elements
    const loading = document.getElementById('loading');
    const errorMsg = document.getElementById('errorMessage');
    const resultDiv = document.getElementById('predictionResult');
    
    // Show loading, hide others
    loading.classList.add('active');
    errorMsg.classList.remove('active');
    resultDiv.classList.remove('active');
    
    try {
        const response = await fetch('http://localhost:5000/predict', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                location: document.getElementById('location').value,
                date: document.getElementById('date').value,
                time: document.getElementById('time').value
            })
        });

        // Handle HTTP errors (like 404, 500)
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            throw new Error(errorData.error || `Server error: ${response.status}`);
        }

        const data = await response.json();

        // Update UI
        document.getElementById('averageSpeed').textContent = `${data.averageSpeed} km/h`;
        document.getElementById('averageDelay').textContent = `${data.averageDelay} seconds`;
        
        const statusElement = document.getElementById('trafficStatus');
        statusElement.textContent = data.trafficStatus;
        statusElement.className = `traffic-level ${data.trafficStatus.toLowerCase()}`;
        
        resultDiv.classList.add('active');
        
    } catch (error) {
        errorMsg.textContent = error.message || "Failed to get prediction. Is the server running?";
        errorMsg.classList.add('active');
        console.error("Prediction error:", error);
    } finally {
        loading.classList.remove('active');
    }
});