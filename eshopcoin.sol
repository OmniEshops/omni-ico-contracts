pragma solidity ^0.4.12;
// https://github.com/OmniEshops/omni-ico-contracts
// https://github.com/lauro-cesar

// Based on Ethereum.org examples.

// ERC20 standard links: 
// https://github.com/ethereum/EIPs/issues/20
// https://theethereum.wiki/w/index.php/ERC20_Token_Standard

contract omniRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }


contract OmniBase {
    address public owner; 
    string public standard = 'ERC20 OmniEShops';
    string public name; 
    string public symbol;
    uint8 public decimals; 
    uint256 public totalSupply;
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Burn(address indexed from, uint256 value);
    mapping (address => uint256) public balanceOf;
    
    mapping (address => mapping (address => uint256)) public allowance;
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) revert();                               
        if (balanceOf[msg.sender] < _value) revert();          
        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                            
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) revert();                                
        if (balanceOf[_from] < _value) revert();                 
        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  
        if (_value > allowance[_from][msg.sender]) revert();     
        balanceOf[_from] -= _value;                           
        balanceOf[_to] += _value;                             
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    
    function burn(uint256 _value) returns (bool success) {
        if (balanceOf[msg.sender] < _value) revert();            
        balanceOf[msg.sender] -= _value;                      
        totalSupply -= _value;                                
        Burn(msg.sender, _value);
        return true;
    }
    function burnFrom(address _from, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) revert();                
        if (_value > allowance[_from][msg.sender]) revert();    
        balanceOf[_from] -= _value;                          
        totalSupply -= _value;                               
        Burn(_from, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {
        omniRecipient spender = omniRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }     
  
    function totalSupply() constant returns (uint totalSupply){
        return totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint balance) {
        return balanceOf[_owner];
    }

    function OmniBase() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}



contract OmniToken is OmniBase {
    function OmniToken() {
        name = "demo2027"; 
        symbol = "D27"; 
        decimals = 2;
        totalSupply =  26000000000;
        balanceOf[msg.sender] = totalSupply;
    }
}