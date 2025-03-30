const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from Microservice');
});

app.listen(port, () => {
  console.log(`Microservice listening at http://localhost:${port}`);
}); 