const express = require("express");
const cors = require("cors");
const app = express();
const port = 4000;

app.use(cors());
app.get("/version", (req, res) => res.json({ version: "0.1.2" }));
app.get("/", (req, res) => res.sendStatus(200));

app.listen(port, () => console.log(`Application listening on port ${port}`));
