// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
// after 0.8.17, the selfdestruct is warning us about deprecation

contract TimeAuction {
    address highest_bidder;
    uint256 highest_bid;

    mapping(address => uint256) old_bids;
    uint256 total_withdrable_bids;

    address owner;
    uint256 start_time;

    event Bid(address indexed sender, uint256 amount, uint256 timestamp);
    event GetCurrentHighest(address bidder, uint256 bid);

    constructor() {
        owner  = msg.sender;
        start_time = block.timestamp;
    }

    function bid() external payable {
        require(block.timestamp - start_time < 5 minutes, "Auction is over");
        require(msg.value > highest_bid, "Bid is too low");

        old_bids[highest_bidder] += highest_bid;
        total_withdrable_bids += highest_bid;

        highest_bidder = msg.sender;
        highest_bid = msg.value;
        emit Bid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        uint256 amount = old_bids[msg.sender];
        old_bids[msg.sender] = 0;
        total_withdrable_bids -= amount;

        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "transfer failed");
    }

    function claim() public {
        require(msg.sender == owner, "You are not the owner");
        require(block.timestamp - start_time >= 5 minutes, "Action has not completed yet");
        require(total_withdrable_bids == 0, "Not all users have claimed thier bids yet");
        selfdestruct(payable(owner));
    }

    function getHeighestBid() public view returns (uint256) {
        return highest_bid;
    }

    function getHighestBidder() public view returns (address) {
        return highest_bidder;
    }

    function getCurrentHightest() public {
        address _bidder = getHighestBidder();
        uint256 _bid = getHeighestBid();
        emit GetCurrentHighest(_bidder, _bid);
    }

}