/*
Return values (return and returns)
There are two keywords related to function output: return and returns:

- returns is added after the function name to declare variable type and variable name;
- return is used in the function body and returns desired variables.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FunctionTypes{
    // returning multiple variables
    function returnMultiple() public pure returns(uint256, bool, uint256[3] memory){
        return(1, true, [uint256(1),2,5]);
    }

 

}

