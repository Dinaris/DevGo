const express = require("express");
const app = express();
const port = 3000;

const { mintNFT } = require("./services/mintNFT");
const { getHistory } = require("./services/DB");

app.get("/ping", (req, res) => {
  res.send("Pong");
});

app.get("/mint/:id", async (req, res) => {
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

app.listen(port, () => {
  console.log(`DevGo app listening on port ${port}`);
});
