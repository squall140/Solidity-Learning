// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SimpleERC20{
    mapping (address => uint) balance;

    string name; // Bit coin

    string symbol; // BTC

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        // 10000枚 乘以 10的18次方
        _mint(msg.sender, 10000 * 10 ** 18); // 2100w
    }

    function _mint(address owner, uint amount) private {

    }

    function transfer(address to, uint amount) public returns(bool) {

    }

    
}