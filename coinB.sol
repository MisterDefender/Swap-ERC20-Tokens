// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "./erc20Interface.sol";
import "hardhat/console.sol";

contract coinB is IERC20{
    string private _name = "Token-B";
    string private _symbol = "B";
    address public owner;
    address public addressOfA;
    uint private _totalSupply = 10000;
    uint public price=10;
    uint public transferFromB;
    mapping(address=>uint) balance;
    mapping(address=>mapping(address=>uint)) approved;
    constructor(address addOfA) {
        owner = msg.sender;
        balance[owner] = _totalSupply;
        addressOfA = addOfA;
        
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
    function approveAll(address spender, uint tokens) external override returns (bool){
        approved[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function balanceOf(address tokenOwner) external view override returns(uint){
        return balance[tokenOwner];
    }
    function transfer(address to, uint tokens) public override returns (bool){
    require(balance[owner]>=tokens,"Not enough tokens to transfer");
    balance[owner]-=tokens;
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
    function transferFrom(address from, address to, uint tokens) public  override returns (bool){
        //console.log("FROM address of transferfrom in coinB: ", from);
        require(approved[from][msg.sender]>=tokens,"Tokens-B not approved for transfer");
        approved[from][msg.sender]-=tokens;
        balance[from]-=tokens;
        balance[to]+=tokens;
        return true;
    }

    function exchangeCoin(uint numOfTokens) external returns(bool){
        //console.log("Function exchangeCoin() is called by: ", msg.sender);
        require(numOfTokens%price==0,"Token B cost 10 tokens of A");
        IERC20(addressOfA).transferFrom(msg.sender,owner,numOfTokens);
        transferFromB = numOfTokens/price;
        transferFrom(owner,msg.sender,transferFromB);
        return true;
    }
}
