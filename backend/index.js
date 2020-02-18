const express = require("express");
const cors = require("cors");
const app = express();
const port = 4000;
const Pool = require("pg").Pool;
const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT
});

app.use(cors());
app.get("/version", (req, res) => res.json({ version: "0.1.3" }));
app.get("/", (req, res) => res.sendStatus(200));
app.get("/dbtest", (req, res) => {
  pool.query("SELECT * FROM test", (error, results) => {
    if (error) {
      res.status(500).json(error);
    } else res.status(200).json(results.rows);
  });
});

app.listen(port, () => console.log(`Application listening on port ${port}`));
