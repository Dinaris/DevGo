const { ethers, Signer } = require("ethers");
const fs = require("fs");
const path = require("path");
const DB = require("../DB");

const QUICKNODE_HTTP_ENDPOINT = "https://sepolia-rpc.scroll.io/";
const contractAddress = "0xe141aAE338eC439af115ae86925CaDb46b53CC5B";
const walletAddress = "0x393a85ecaA4D45AA90869EF27E15c256EF6D1E78";
const NFT_ID_URI_MAP = new Map([
  [
    "1",
    "https://crimson-given-kangaroo-552.mypinata.cloud/ipfs/QmUtMNYGsznRpm6VMePuj7GHmjCuGh34xJKD3mfK9ULoK2?_gl=1*kuld6s*_ga*MTkzOTQ3MTQ1OS4xNzAwMjk4MDAw*_ga_5RMPXG14TE*MTcwMDI5ODAwMC4xLjEuMTcwMDI5OTc0Mi4zNi4wLjA.",
  ],
  [
    "2",
    "https://crimson-given-kangaroo-552.mypinata.cloud/ipfs/QmVYcYeX3XY2swT4obB24465M9kfJo3uSY2U9o1ABYT2RW?_gl=1*bmten6*_ga*MTkzOTQ3MTQ1OS4xNzAwMjk4MDAw*_ga_5RMPXG14TE*MTcwMDI5ODAwMC4xLjEuMTcwMDMwMDUyOC40LjAuMA..",
  ],
  [
    "3",
    "https://crimson-given-kangaroo-552.mypinata.cloud/ipfs/QmNs9rnHuLwN19JQRRnm7BsEhkMQivQbso8e62vhkJmGC6?_gl=1*7kn6ml*_ga*MTkzOTQ3MTQ1OS4xNzAwMjk4MDAw*_ga_5RMPXG14TE*MTcwMDMyMjE5NC40LjEuMTcwMDMyMjU0OC4yLjAuMA..",
  ],
]);

const privateKey = fs
  .readFileSync(path.resolve(__dirname, "./.privatekey"))
  .toString()
  .trim();

const contractAbi = fs
  .readFileSync(path.resolve(__dirname, "./abi.json"))
  .toString();

const provider = new ethers.providers.JsonRpcProvider(QUICKNODE_HTTP_ENDPOINT);

const contractInstance = new ethers.Contract(
  contractAddress,
  contractAbi,
  provider
);

const wallet = new ethers.Wallet(privateKey, provider);

async function getGasPrice() {
  let feeData = (await provider.getGasPrice()).toNumber();
  return feeData;
}

async function getNonce(signer) {
  let nonce = await provider.getTransactionCount(wallet.address);
  return nonce;
}

async function mintNFT(NFT_id) {
  return new Promise(async (resolve, reject) => {
    try {
      const nonce = await getNonce(wallet);
      const gasFee = await getGasPrice();
      console.log(typeof NFT_id);
      console.log(NFT_id);

      const NFT_URI = NFT_ID_URI_MAP.get(NFT_id);

      if (!NFT_URI) {
        reject(`NFT token with id = ${NFT_id} not found`);
        return;
      }

      let rawTxn = await contractInstance.populateTransaction.mintNFT(
        walletAddress,
        NFT_ID_URI_MAP.get(NFT_id),
        {
          gasPrice: gasFee,
          nonce: nonce,
        }
      );
      console.log(
        "...Submitting transaction with gas price of:",
        ethers.utils.formatUnits(gasFee, "gwei"),
        " - & nonce:",
        nonce
      );
      let signedTxn = (await wallet).sendTransaction(rawTxn);
      let reciept = (await signedTxn).wait();
      if (reciept) {
        const hash = (await signedTxn).hash;
        const blockNumber = (await reciept).blockNumber;

        console.log(
          "Transaction is successful!!!" + "\n" + "Transaction Hash:",
          hash + "\n" + "Block Number: " + blockNumber
        );
        await DB.putToHistory(e);
        resolve({
          hash,
          blockNumber,
        });
      } else {
        reject("Error submitting transaction");
        console.log("Error submitting transaction");
      }
    } catch (e) {
      console.log("Error Caught in Catch Statement: ", e);
      reject(`Error Caught in Catch Statement: ${e}`);
    }
  });
}

module.exports = {
  mintNFT,
};
