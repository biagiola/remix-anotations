// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract FancyShirts {
    enum Size {
        Small,
        Medium,
        Large
    }

    enum Color {
        Red,
        Green,
        Blue
    }

    struct Shirt {
        Size size;
        Color color;
    }

    mapping(address => Shirt[]) shirts;

    modifier correctAmount(Size size, Color color) {
        require(
            getShirtPrice(size, color) == msg.value,
            "Incorrect amount set"
        );
        _;
    }

    function getShirtPrice(Size size, Color color) public pure returns(uint256) {
        uint256 price;

        if (size == Size.Small) {
            price +=  10;
        } else if (size == Size.Medium) {
            price += 15;
        } else {
            price += 20;
        }

        if (color != Color.Red) {
            price += 5;
        }

        return price;
    }

    function buyShirt(Size size, Color color) public payable correctAmount(size, color) {
        Shirt memory shirt = Shirt(size, color);
        shirts[msg.sender].push(shirt);
    }

    function getShirts(Size size, Color color) public view returns (uint256) {
        uint256 count;

        for (uint256 i; i < shirts[msg.sender].length; i++) {
            if (
                shirts[msg.sender][i].size == size &&
                shirts[msg.sender][i].color == color
            ) {
                count++;
            }
        }
        return count;
    }
}