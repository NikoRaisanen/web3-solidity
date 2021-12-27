// SDPX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.9;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address[] public funders;
    address public owner;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() public {
        owner = msg.sender;  
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(answer);
        // has 8 decimals
    }

    function getConversionRate(uint256 ethAmt) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmtToUsd = (ethPrice * ethAmt) / (10 ** 8);
        return ethAmtToUsd;
    }
    function fund() public payable {
        uint256 minDonationUsd = 4200;
        require(msg.value >= minDonationUsd, "you need to donate at least $4200 of eth!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(address(msg.sender));
    }

    function funder_address (uint256 _index) public view returns(address) {
        return funders[_index];
    }

    function withdraw_funds() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        // empty funders array because withdraw occured
        funders = new address[](0);
    }

    function view_total_funds() public view returns(uint256) {
        uint256 totalEth = 0;
        for (uint256 i = 0; i < funders.length; i++) {
            totalEth += addressToAmountFunded[funders[i]];
        }
        return totalEth;
    }
}