const express = require("express");
const app = express();
const PORT = 3000;
const path = require("path");
const useRoute = require("./routes/User.js");
const { text } = require("stream/consumers");

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.use("/user", useRoute);

const assetsPath = path.join(__dirname, "public");
app.use(express.static(assetsPath));

const links = [
  { href: "/", text: "home" },
  { href: "about", text: "About" },
];

const users = ["Rose", "Cake", "Biff"];

app.get("/", (req, res) => {
  res.render("index.ejs", { links: links, users: users });
});

app.get("/about", (req, res) => {
  res.render("about.ejs", { name: "Farhan" });
});

app.use((req, res) => {
  res.status(404).send("404 Not Found");
});

app.listen(PORT, (req, res) => {
  console.log("App listen to port 3000");
});
