const express = require("express");
const app = express();
const port = 3000;

const { mintNFT } = require("./services/mintNFT");
const { getHistory, getLocations, getLocationById } = require("./services/DB");

app.get("/ping", (req, res) => {
  res.send("Pong");
});

app.get("/mint/:user_id/:location_id", async (req, res) => {
  try {
    const NFT_id = req.params.id;
    if (NFT_id) {
      const response = await mintNFT(NFT_id);
      res.send(response);
    } else {
      res.status(400).send("Provide NFT ID");
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

app.listen(port, () => {
  console.log(`DevGo app listening on port ${port}`);
});
