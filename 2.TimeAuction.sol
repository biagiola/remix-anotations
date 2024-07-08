// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract TimeAuction {
    address highestBidder;
    uint256 highestBid;
    
    mapping(address => uint256) oldBids;
    uint256 totalWithdrableBids;
    
    address owner;
    uint256 startTime;

    event Bid(address indexed sender, uint256 amount, uint256 timestamp);

    constructor() {
        owner = msg.sender;
        startTime = block.timestamp;
    }

    function bid() external payable {
        require(block.timestamp - startTime < 5 minutes, "auction is over");
        require(msg.value > highestBid, "bid is too low");

        oldBids[highestBidder] += highestBid;
        totalWithdrableBids += highestBid;

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit Bid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        uint256 amount = oldBids[msg.sender];
        oldBids[msg.sender] = 0;
        totalWithdrableBids -= amount;

        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "transfer failed");
    }

    function claim() public {
        require(msg.sender == owner, "you are not the onwer");
        require(block.timestamp - startTime >= 5 minutes, "auction has not completed yet");
        require(totalWithdrableBids == 0, "not all users have claimed their bids yet");
        selfdestruct(payable(owner));
    }

    function getHighestBid() public view returns (uint256) {
        return highestBid;
    }

    function getHighestBidder() public view returns (address) {
        return highestBidder;
    }

    event GetCurrentHighest(address bidder, uint256 bid);

    function getCurrentHightest() public {
        address _highestBidder = getHighestBidder();
        uint256 _highestBid = getHighestBid();

        emit GetCurrentHighest(_highestBidder, _highestBid);
    }
}