pragma solidity ^0.8.0;

contract SecureBank {
    address private owner;
    mapping (address => uint) private balances;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function transfer(address recipient, uint amount) public {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    function kill() public {
        require(msg.sender == owner, "Only owner can kill the contract");
        selfdestruct(payable(owner));
    }
}
