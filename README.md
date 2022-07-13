# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

## Learning notes and key timestamps

- in `.solhint.json`

```
{
  "extends": "solhint:default"
}
```
- change compiler version from ```pragma solidity ^0.8.9;``` to ```^0.5.8```

- Adding ethers.js for hardhat deploy
- ```@nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers```

10:40 Chainlink repo
- contracts/src/v0.6/tests
- https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/tests/MockV3Aggregator.sol

10:42 Dealing with compiler version issues 
- Add multiple versions of solidity in the ```hardhat.config.js``` file

- Only run deploy scripts with special tag (all or mocks )
- ```yarn hardhat deploy --tags mocks```

10:50 Run ```yarn hardhat deploy``` to deploy all contracts 

10:52 Run ```yarn hardhat node``` 
- Note that using hardhat deploy the local node comes with the contracts already deployed

10:53 Utils folder

10:55 Testnet demo
- ```yarn hardhat deploy --network rinkeby```

- Don't forget to add .env file, but also run ```yarn add dotenv``` to ```package.json```
- Then need to add ```require("dotenv").config()``` to ```hardhat.config.js```

- Initial contract deployed at address 0x8225B8Fd970eb6e9F1F77429bdd85D13D21C2B70

11:00 Solidity style guide

- Reference the docs at: https://docs.soliditylang.org/en/latest/style-guide.html
- Use ```/** {insert} */``` to add Natspec comments
- Can use this to automatically generate documentation

11:08 Testing FundMe
- To run a single test ```yarn hardhat test --grep "amount funded"```
- To check coverage - run ```yarh hardhat coverage```
- Use the Arrange - Act - Assert model to think about structuring tests

11:30 Breakpoints and debugging
- select a breakpoint (red dot)
- Select 'Run and Debug' from left menu bar - 'Javascript Debug Terminal'
- opens a new terminal window
- run ```yarn hardhat test``` in debug terminal window - 'debugger attached'
- Can then pull items out of the ```transactionReceipt``` object

11:36 console.log and debugging

11:52 Gas optimisation
- Can look at the ```opcodes``` in the compiled bytecode - gas costs vary for each
- Saving and accessing storage costs a lot of gas!
- Convention is to append ```s_``` on any ```storage``` variable
- Conventions 
  ```i_``` immutable variable
  ```CAPS``` constant variable
  ```s_``` storage variable

12:08 Add ```getter``` functions to make clear for users and avoid having to use ```s_```, etc

12:11 Staging tests - write tests for a contract deployed on a test network 
- to deploy ```yarn hardhat deploy --network rinkeby```
- think of this as the last step before deployment to a main network
- ensure the contract is working correctly on a testnet
- ```yarn hardhat test --network rinkeby``` to run test on rinkeby test network

12:20 Running scripts on a local node
- ```yarn hardhat node```
- open a new terminal - ```yarn hardhat run scripts/fund.js --network localhost```
- Second script ```yarn hardhat run scripts/withdraw.js --network localhost```

12:22 Adding scripts
- ```yarn test```


