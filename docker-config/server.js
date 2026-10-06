const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.send("RJ AWS CI/CD Lab is running!");
});

app.get("/health", (req, res) => {
  res.status(200).send("healthy");
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on port ${PORT}`);
});