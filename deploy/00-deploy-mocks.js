const { network } = require("hardhat")
const {
    developmentChains,
    DECIMALS,
    INITIAL_ANSWER
} = require("../helper-hardhat-config")

// use our own contracts instead of already established contracts
// If on a network that doesn't have any price feed contracts
// E.g. hardhat or localhost node
// Need to add a mock or 'fake' contract - in a separate folder 'test'

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    // const chainId = network.config.chainId

    if (developmentChains.includes(network.name)) {
        // helper.config is using names and not chainId's
        // Or can use if(chainId == "31337")
        // get log from deployments - essentially console.log()
        log("Local network detected! Deploying mocks...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            // log: true - logs out tx details
            log: true,
            // Need to include the parameters from the constructor function
            // Can look in the docs or in node_modules
            args: [DECIMALS, INITIAL_ANSWER]
        })
        log("Mocks deployed!")
        log("---------------------")
    }
}

module.exports.tags = ["all", "mocks"]
