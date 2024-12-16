const express = require("express");
const app = express();
const PORT = 3000;
const useRoute = require("./routes/User.js");

app.use("/user", useRoute);

app.get("/", (req, res) => {
  res.send("Home page");
});

app.use((req, res) => {
  res.status(404).send("404 Not Found");
});

app.listen(PORT, (req, res) => {
  console.log("App listen to port 3000");
});
