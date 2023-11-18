## TokenGo App

### Backend Installation

#### Steps for Setup:

1. **Create Necessary Files:**
   - Run the following commands to create the required files:
     ```
     touch ./services/mintNFT/.privatekey
     touch ./conf.json
     ```
2. **Configure Wallet Private Key:**

   - Add your wallet's private key, which is used for minting NFTs, to the `.privatekey` file.

3. **Setting up Configuration:**
   - Modify `conf.json` with your database configuration. Here is an example:
     ```json
     {
       "DB": {
         "host": "127.0.0.1",
         "user": "root",
         "password": "password",
         "database": "tokengo"
       }
     }
     ```

#### Running the Application:

- Navigate to the backend directory and start the application:

cd backend && npm install && npm start
