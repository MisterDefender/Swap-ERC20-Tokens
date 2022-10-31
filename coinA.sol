// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "./erc20Interface.sol";
import "hardhat/console.sol";

contract coinA is IERC20{
    string private _name = "Token-A";
    string private _symbol = "A";
    address public owner;
    uint private _totalSupply = 10000;
    mapping(address=>uint) balance;
    mapping(address=>mapping(address=>uint)) public approved;
    constructor() {
        owner = msg.sender;
        balance[owner] = _totalSupply;
    }
    function name() external view returns(string memory){
        return _name;
    }
    function symbol() external view returns(string memory){
        return _symbol;
    }
    function totalSupply() external view override returns(uint){
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) external view override returns(uint){
        return balance[tokenOwner];
    }
    function transfer(address to, uint tokens) external override returns (bool){
    require(balance[msg.sender]>=tokens,"Not enough tokens to transfer");
    balance[msg.sender]-=tokens;
    balance[to]+=tokens;
    emit Transfer(msg.sender, to, tokens);
    return true;
    }
    function approve(address spender, uint tokens) external override returns (bool){
        approved[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    function allowance(address tokenOwner, address spender) external view override returns (uint){
        return approved[tokenOwner][spender];
    }
    function transferFrom(address from, address to, uint tokens) external  override returns (bool){
        //console.log("FROM address of transferfrom in coinA: ", from);
        //console.log("Messege sender in coin A transfer from is: ", msg.sender);
        require(approved[from][msg.sender]>=tokens,"Tokens-A not approved for transfer");
        approved[from][msg.sender]-=tokens;
        balance[from]-=tokens;
        balance[to]+=tokens;
        return true;
    }
}