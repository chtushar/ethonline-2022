require("dotenv").config({ path: "./.env" });
import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import './tasks';

const mnemonic = process.env.MNEMONIC || "test test test test test test test test test test test junk";

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_RPC || "https://rpc-mumbai.maticvigil.com",
      accounts: [mnemonic],
    },
  },
  etherscan: {
    apiKey: {
      mumbai: process.env.MUMBAISCAN_API_KEY || "",
    }
  }
};

export default config;
