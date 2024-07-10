// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract Item {
    string internal _name;
    uint internal _price;

    constructor(string memory name, uint price) {
        _name = name;
        _price = price;
    }

    function getName() public view returns(string memory) { return _name; }
    function getPrice() public view virtual returns(uint) { return _price; }
}

contract TaxedItem is Item {
    uint _tax;
    constructor(string memory name, uint price, uint tax) Item(name, price) {
        _tax = tax;
    }

    function getPrice() public view override returns(uint) {
        return super.getPrice() + _tax;
    }
}