// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract RestrictedCount {
    int count;
    address owner;

    constructor() { owner = msg.sender ; }

    modifier isOwner(address addr) {
        require(owner == addr, "You're not the owner");
        _;
    }
    
    modifier maximun(int value) {
        require(value <= 100, "You reach max value");
        _;
    }

    modifier minimun(int value) {
        require(value >= -100, "You reach the min value");
        _;
    }

    function getCount() public view returns(int) {
        return count;
    }

    function add(int value) public
        isOwner(msg.sender)
        maximun(count + value)
        minimun(count + value)
    {
        count += value;
    }

    function subtract(int value) public
        isOwner(msg.sender)
        maximun(count + value)
        minimun(count + value)
    {
        count -= value;
    }
}