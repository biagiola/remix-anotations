// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

library Array {
    // Write your code here
    function indexOf(int256[] memory numbers, int256 target)
        public
        pure
        returns(int256)
    {
        for(uint256 i; i < numbers.length; i++) {
            if(numbers[i] == target) {
                return int256(i);
            }
        }
        return -1;
    }

    function count(int256[] memory numbers, int target)
        public
        pure
        returns(uint256)
    {
        uint256 counter;
        for(uint256 i; i < numbers.length; i++) {
            if(numbers[i] == target) {
                counter++;
            }
        }
        return counter;
    }

    function sum(int256[] memory numbers)
        public
        pure
        returns(int256)
    {
        if(numbers.length == 0) {
            return 0;
        }
    
        int256 adder;
        for(uint256 i; i < numbers.length; i++) {
            adder += numbers[i];
        }
        
        return adder;
    }
}
