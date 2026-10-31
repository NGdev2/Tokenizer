import { configVariable, defineConfig } from "hardhat/config";
import hardhatIgnition from "@nomicfoundation/hardhat-ignition";
import hardhatKeystore from "@nomicfoundation/hardhat-keystore";

export default defineConfig({
  plugins: [hardhatIgnition, hardhatKeystore],
  solidity: "0.8.28",
  paths: {
    sources: "./code",
    ignition: "./deployment",
  },
  networks: {
    // Ethereum Sepolia testnet, chain id 11155111. The private key is read from the
    // encrypted Hardhat keystore (or the env var of the same name), never from this file.
    sepolia: {
      type: "http",
      chainType: "l1",
      url: "https://ethereum-sepolia-rpc.publicnode.com",
      chainId: 11155111,
      accounts: [configVariable("SEPOLIA_PRIVATE_KEY")],
    },
  },
});
