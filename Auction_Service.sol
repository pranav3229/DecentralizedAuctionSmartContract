// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ServiceReverseAuction {
    struct Bid {
        address bidder;
        uint256 amount; // Stored in Wei
    }

    // Auction details
    address public driver;
    string public serviceDetails;
    uint256 public maxCap; // In Wei
    uint256 public auctionEndTime;
    bool public isAuctionActive;
    address public winner;
    uint256 public lowestBid;

    uint256 public constant rupeeToWeiConversionRate = 1; // 1 Rupee = 1000000000000 Wei (hard-coded)

    mapping(address => uint256) public refunds;

    event AuctionCreated(string serviceDetails, uint256 maxCap, uint256 auctionEndTime);
    event BidPlaced(address indexed bidder, uint256 amountInRupees, uint256 amountInWei);
    event AuctionFinalized(address winner, uint256 amount);
    event RefundIssued(address indexed bidder, uint256 amount);

    // Constructor: Initialize auction details
    constructor(string memory _serviceDetails, uint256 _maxCap, uint256 _auctionDuration) payable {
        driver = msg.sender;
        serviceDetails = _serviceDetails;
        maxCap = _maxCap * rupeeToWeiConversionRate; // Convert maxCap from Rupees to Wei
        auctionEndTime = block.timestamp + _auctionDuration;
        isAuctionActive = true;
        lowestBid = type(uint256).max; // Initialize to max value

        emit AuctionCreated(_serviceDetails, maxCap, auctionEndTime);
    }

    // Maintenance providers place bids in Rupees
    function placeBid(uint256 amountInRupees) external payable {
        require(isAuctionActive, "Auction is not active");
        require(block.timestamp <= auctionEndTime, "Auction has ended");

        // Convert Rupees to Wei
        uint256 amountInWei = amountInRupees * rupeeToWeiConversionRate;
        require(amountInWei > 0, "Bid must be greater than 0");
        require(amountInWei <= maxCap, "Bid exceeds max cap");
        require(amountInWei < lowestBid, "Bid is not lower than the current lowest bid");

        // Refund the previous lowest bidder if replaced
        if (lowestBid != type(uint256).max) {
            refunds[winner] += lowestBid;
        }

        lowestBid = amountInWei;
        winner = msg.sender;

        emit BidPlaced(msg.sender, amountInRupees, amountInWei);
    }
    function depositFunds(uint256 amountInWei) external payable {
    require(amountInWei > 0, "Must specify a positive amount");
    // require(msg.value == amountInWei, "Sent value must match the specified amount");
}


    // Finalize the auction
    function finalizeAuction() external {
        require(msg.sender == driver, "Only driver can finalize the auction");
        require(block.timestamp > auctionEndTime, "Auction is still ongoing");
        require(isAuctionActive, "Auction already finalized");

        isAuctionActive = false;

        emit AuctionFinalized(winner, lowestBid);
    }

event DebugCompletion(address caller, address winner, uint256 lowestBid, uint256 contractBalance);

function confirmCompletion() external payable{
    require(msg.sender == driver, "Only driver can confirm completion");
    require(!isAuctionActive, "Auction is still active");
    require(winner != address(0), "No winner to pay");
    require(address(this).balance >= lowestBid, "Insufficient contract balance to pay the winner");

    emit DebugCompletion(msg.sender, winner, lowestBid, address(this).balance);

    (bool success, ) = payable(winner).call{value: lowestBid}("");
    require(success, "Transfer to the winner failed");

    emit AuctionFinalized(winner, lowestBid);
}


    // Allow non-winning bidders to withdraw their refunds
    function withdrawRefund() external {
        uint256 amount = refunds[msg.sender];
        require(amount > 0, "No funds to refund");

        refunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RefundIssued(msg.sender, amount);
    }
    function debugConfirmCompletion()
        external
        view
        returns (
            address currentDriver,
            address currentWinner,
            uint256 currentLowestBid,
            bool auctionActive,
            uint256 contractBalance,
            address caller
        )
    {
        return (
            driver,
            winner,
            lowestBid,
            isAuctionActive,
            address(this).balance,
            msg.sender
        );
    }

    // Allow the driver to withdraw funds if no valid bids were placed
    function withdrawFunds() external {
        require(msg.sender == driver, "Only driver can withdraw funds");
        require(!isAuctionActive, "Auction is still active");
        require(winner == address(0), "Winner exists, cannot withdraw");

        payable(driver).transfer(address(this).balance);
    }
}
