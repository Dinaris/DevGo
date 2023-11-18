const express = require("express");
const app = express();
const port = 3000;

const { mintNFT } = require("./services/mintNFT");
const {
  getHistory,
  getLocations,
  getLocationById,
  getUsers,
  getUserByEmail,
} = require("./services/DB");

app.get("/ping", (req, res) => {
  res.send("Pong");
});

app.get("/mint/:email/:location_id", async (req, res) => {
  try {
    const location_id = req.params.location_id;
    const email = req.params.email;

    if (email && location_id) {
      const response = await mintNFT(email, location_id);
      res.send(response);
    } else {
      res.status(400).send("Provide location_id and email");
    }
  } catch (e) {
    res.status(400).send(e);
  }
});

app.get("/history/:email", async (req, res) => {
  try {
    const email = req.params.email;
    const result = await getHistory(email);
    res.send(result);
  } catch (e) {
    res.status(400).send(e);
  }
});

app.get("/locations", async (req, res) => {
  try {
    const result = await getLocations();
    res.send(result);
  } catch (e) {
    res.status(400).send(e);
  }
});

app.get("/location/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const result = await getLocationById(id);
    res.send(result);
  } catch (e) {
    res.status(400).send(e);
  }
});

app.get("/users", async (req, res) => {
  try {
    const result = await getUsers();
    res.send(result);
  } catch (e) {
    res.status(400).send(e);
  }
});

app.get("/user/:email", async (req, res) => {
  try {
    const email = req.params.email;
    const result = await getUserByEmail(email);
    res.send(result);
  } catch (e) {
    res.status(400).send(e);
  }
});

app.listen(port, () => {
  console.log(`DevGo app listening on port ${port}`);
});
