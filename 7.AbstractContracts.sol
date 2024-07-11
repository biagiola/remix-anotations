// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

abstract contract SignUpBonus {
    function getBonusAmount() internal virtual pure returns(uint);
    function getBonusRequirements() internal virtual pure returns(uint);
    function deposit() public virtual payable returns(uint);
}

contract Bank is SignUpBonus {
    mapping(address => uint) public bonus;
    mapping(address => uint) public balance;
    mapping(address => bool) public firstDeposit;

    function getBonusAmount() internal override pure returns(uint) {
        return 150 wei;
    }

    function getBonusRequirements() internal override pure returns(uint) {
        return 1000 wei;
    }

    function deposit() public override payable returns(uint) {
        balance[msg.sender] += msg.value;

        if (firstDeposit[msg.sender] == false) {
            firstDeposit[msg.sender] = true;

            if (msg.value >= getBonusRequirements()) {
                balance[msg.sender] += getBonusAmount();
            }
        }

        return balance[msg.sender];
    }

    function withdraw(uint amount) public payable {
        require(amount <= balance[msg.sender], "You don't have enough money");

        balance[msg.sender] -= amount;
        (bool sent, ) = payable(msg.sender).call{ value: amount }("");
        assert(sent == true);
    }

    function getBalance() public view returns(uint) {
        return balance[msg.sender];
    }
}