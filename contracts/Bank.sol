// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Bank{
    // mapping (address => uint)
    mapping(address => uint) public deposited;

    // static variable (immutable)
    address immutable token;

    constructor(address _token){
        token = _token;
    }

    // query my balance
    // view: 只是读取链上数据，但是不写入
    function myBalance() public view returns(uint balance){
        balance = deposited[msg.sender];
        // 需要做返回数据的处理
        balance = balance / (10 ** 18);
        // return deposited[msg.sender];
    }

    // deposit 因为要操作链上数据，所以不能用view | pure
    function deposit(uint amount) public {
        // amount目前是1 ETH，需要转换为最小单位wei进行交易
        amount = amount * 10 ** 18;
        // 转账，直接调用 IERC2接口的transferFrom(address _from, address _to, uint amount)
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transfer error!");
        // 原账户余额的基础上增加新转入的代币
        deposited[msg.sender] += amount;  
    }

        



}