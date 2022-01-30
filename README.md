# GodOfWarBattle_onChain
A NFT based game in a PvC fashion. Will be deployed on testnet soon.

```shell
npx hardhat node
npx hardhat run scripts/run.js
node scripts/deploy.js

npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write

```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
