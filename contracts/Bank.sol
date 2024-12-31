// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Bank{
    // mapping (address => uint)
    mapping(address => uint) public deposited;

    // static variable (immutable)
    address immutable token;

    constructor(address _token){
        token = _token;
    }
    
    // 封装校验模块
    modifier requireBalance(uint amount){
        amount = amount * 10 ** 18;
        uint balance = deposited[msg.sender];
        require(amount <= deposited[msg.sender], "withdraw amount should not greater than deposit amount");
        // 插入占位符_; 继续执行后续代码 
        _;
    }

    // query my balance
    // view: 只是读取链上数据，但是不写入
    function myBalance() public view returns(uint balance){
        balance = deposited[msg.sender];
        // 需要做返回数据的处理
        balance = balance / (10 ** 18);
        // return deposited[msg.sender];
    }

    // deposit 存款， 因为要操作链上数据，所以不能用view | pure
    function deposit(uint amount) public {
        // amount目前是1 ETH，需要转换为最小单位wei进行交易
        amount = amount * 10 ** 18;
        // 转账，直接调用 IERC2接口的transferFrom(address _from, address _to, uint amount)
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "deposit error!");
        // 原账户余额的基础上增加新转入的代币
        deposited[msg.sender] += amount;  
    }

    /**
     * withdraw 取款
     * 这里使用了SafeERC20.safeTransfer()方法，因为直接使用transfer方法的时候，
     * 有些代币的协议不支持bool类型的返回值，无法遵循(bool)IERC20.transfer() ，
     * 使用safeTransfer可以直接调用底层的ABI来查询transfer的情况（类似Java中的反射机制），
     * 更加有保障，同时其方法本身实现了异常处理机制，不用require了
     */
    function withdraw(uint amount) external requireBalance(amount){
        // 余额校验（取款金额是否超出余额）
        // require(amount <= deposited[msg.sender], "withdraw amount should not greater than deposit amount");
        // to wei
        amount = amount * 10 ** 18;
        // function safeTrasfer(address token, address to, uint value) internal{}
        SafeERC20.safeTransfer(IERC20(token), msg.sender, amount); 
        deposited[msg.sender] -= amount;
    }

    // transfer
    function transfer(address to, uint amount) public requireBalance(amount) {
        amount = amount * 10 ** 18;
        // require(amount <= deposited[msg.sender], "withdraw amount should not greater than deposit amount");
        deposited[msg.sender] -= amount;
        deposited[to] += amount;
    }



}