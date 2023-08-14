const express = require("express");
const app = express();

app.use(express.json());
app.get("/", (req, res) => {
  res.json("hello world");
});

app.listen("3001", () => console.log("server connected"));
