// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// Note current best practice naming convention for errors
error FundMe__NotOwner();

/** @title A contract for crowd funding
 *   @author Ben Bright
 *   @notice This contract is to demo a sample funding contract
 *   @dev This implements price feeds as our library
 */
contract FundMe {
    // Type Declarations
    using PriceConverter for uint256;

    // State Variables
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // Create a variable and modular price feed address to use different chains
    AggregatorV3Interface public s_priceFeed;

    // Events
    event Funded(address indexed from, uint256 amount);

    // Modifiers
    modifier onlyOwner() {
        // require (msg.sender == owner)
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    // Functions
    constructor(address priceFeedAddress) {
        // make priceFeedAddress a parameter and pass to constructor
        i_owner = msg.sender;
        // priceFeed - Saved as global variable of type AggregatorV3Interface
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     *   @notice This function funds this contract
     *   @dev This implements price feeds as our library
     */
    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough!"
        );
        s_addressToAmountFunded[msg.sender] = msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset the array
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");

        // msg.sender = address
        // payable(msg.sender) = payable address
    }

    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        // mappings can't be in memory
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    // View / Pure functions
    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funder)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}

// Initial contract deployed
// 0xfbC1eFB98e48f9a5611DE0C7fB2d6993b465Cc0b

// Second instance with receive / fallback functions
// 0x6cEB9076b85E0D78f43e2139c1Eb04c82dA6BcEB

// function getVersion() public view returns (uint256) {
//     AggregatorV3Interface priceFeed = AggregatorV3Interface(
//         0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
//     );
//     return priceFeed.version();
// }

// transfer
// payable(msg.sender).transfer(address(this).balance);
// send
// bool sendSuccess = payable(msg.sender).send(address(this).balance);
// require(sendSuccess, "Send failed");
// call - lower level function - recommended method to use
