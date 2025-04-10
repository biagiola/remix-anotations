// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract RestrictedCount {
    int count;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner(address addr) {
        require(owner == addr, "You're not the owner");
        _;
    }

    modifier maximun(int value) {
        require(value <= 100, "You reach the max value");
        _;
    }

    modifier minimun(int value) {
        require(value >= -100, "You reach the min value");
        _;
    }

    function getCount() public view returns(int) {
        return count;
    }

    function add(int _value) public
        isOwner(msg.sender)
    {
        count += _value;
    }

    function substract(int _value) public
        isOwner(msg.sender)
        maximun(count + _value)
        minimun(count + _value)
    {
        count -= _value;
    }
}