const { ethers, Signer } = require("ethers");
const fs = require("fs");
const path = require("path");
const DB = require("../DB");

const QUICKNODE_HTTP_ENDPOINT = "https://sepolia-rpc.scroll.io/";
const contractAddress = "0xe141aAE338eC439af115ae86925CaDb46b53CC5B";
const walletAddress = "0x393a85ecaA4D45AA90869EF27E15c256EF6D1E78";

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

async function mintNFT(email, location_id) {
  return new Promise(async (resolve, reject) => {
    try {
      const nonce = await getNonce(wallet);
      const gasFee = await getGasPrice();

      const location = await DB.getLocationById(location_id);
      const user = await DB.getUserByEmail(email);

      const NFT_URI = location && location[0] ? location[0].NFT_URI : null;
      const user_id = user && user[0] ? user[0].id : null;

      if (!NFT_URI) {
        reject(`NFT_URI not found for location id ${location_id}`);
        return;
      }

      if (!user_id) {
        reject(`User with email ${email} does not exists`);
        return;
      }

      let rawTxn = await contractInstance.populateTransaction.mintNFT(
        walletAddress,
        NFT_URI,
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
        await DB.putToHistory(email, location_id, hash);
        let response = await DB.getHistory(email);
        resolve(response);
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
