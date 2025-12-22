const express = require('express');

const app = express();
const PORT = 3000;

// Trust proxy headers (important for ALB / Nginx / Ingress)
app.set('trust proxy', true);

app.get('/', (req, res) => {
  const response = {
    timestamp: new Date().toISOString(),
    ip: req.ip
  };

  console.log(JSON.stringify({
    event: "request",
    ip: req.ip,
    timestamp: response.timestamp
  }));

  res.json(response);
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
