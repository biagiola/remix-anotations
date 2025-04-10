// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract ShoppingList {
    struct Item {
        string name;
        uint256 quantity;
    }

    struct List {
        string name;
        Item[] items;
    }

    struct User {
        mapping(string => List) lists;
        string[] list_names;
    }
    mapping(address => User) users;

    function listExists(string memory _name) internal view returns (bool) {
        // if name of accessed list is empty, then list has not been created
        return bytes(users[msg.sender].lists[_name].name).length != 0; // ???
    }

    function getListNames() public view returns (string[] memory) {
        return users[msg.sender].list_names;
    }

    function getItemNames(string memory _list_name) public view returns (string[] memory) {
        require(listExists(_list_name), "No list with this name exists");
        // set size 
        string[] memory names = new string[] (
            users[msg.sender].lists[_list_name].items.length
        );
        // set names
        for (uint256 i; i < names.length; i++) {
            names[i] = users[msg.sender].lists[_list_name].items[i].name;
        }

        return names;
    }

    function addItem(string memory _list_name, string memory _item_name, uint256 quantity) public {
        require(listExists(_list_name), "No list with this name exists");
        users[msg.sender].lists[_item_name].items.push(Item(_item_name, quantity));
    }
}