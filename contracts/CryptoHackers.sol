pragma solidity ^0.4.2;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract CryptoHackers is ERC721Token, Ownable  {

    uint dnaDigits = 20;
    uint dnaModulus = 10 ** dnaDigits;

    event hackerCreatedEvent(uint indexed _hackerId);
    event learnNewSkillEvent(uint indexed _hackerId);
    
    //Model a hacker
    struct Hacker {
        uint dna;
        string name;
        string gender;
        uint lvl;
        uint exp;
        uint bday;
    }

    // Store hackers
    Hacker[] public hackers; 

    // Store accounts that have created a hacker one time
    mapping (address => bool) public creaters;
    mapping (uint => address) public hackerToOwner;
    mapping (uint => uint256[]) public hackerToSkills;

    string public hello = "HelloHacker";

    constructor ( string _name, string _symbol) public ERC721Token(_name, _symbol){}

    function _createHacker (string _name, string _gender, uint _randDna)  private {
        Hacker memory _hacker = Hacker(
        {
            dna: _randDna,
            name: _name, 
            gender: _gender, 
            lvl: 1, 
            exp: 0, 
            bday: now
        });
        
        uint _hackerId = hackers.push(_hacker) - 1;
        hackerToOwner[_hackerId] = msg.sender;
        _mint(msg.sender, _hackerId);
        emit hackerCreatedEvent(_hackerId);
    }

    function _generateRandomDna(string _strValue) private view returns (uint) {
        uint _rand = uint(keccak256(_strValue));
        return _rand % dnaModulus;
    }

    function createRandomHacker(string _name, string _gender) public returns (uint){
        //user can create a hacker only one time
        // require(!creaters[msg.sender]);
        creaters[msg.sender] = true;
        uint _randDna = _generateRandomDna(_name);
        _createHacker(_name, _gender, _randDna);
        return _randDna;
    }

    function getOwnedTokens() external view returns (uint256[]) {
        return ownedTokens[msg.sender];
    }

    function _levelUp(uint _hackerId) private  {
        hackers[_hackerId].lvl ++;
    }

    function _expUp(uint _hackerId) private {
        hackers[_hackerId].exp = (hackers[_hackerId].exp + 5);
        if(hackers[_hackerId].exp == 20) {
            hackers[_hackerId].exp = 0;
            _levelUp(_hackerId);
        }
    } 

    function learnNewSkill(uint _hackerId, uint _skillId) public {
        require(hackerToOwner[_hackerId] == msg.sender);
        hackerToSkills[_hackerId].push(_skillId); 
        _expUp(_hackerId);
        emit learnNewSkillEvent(_hackerId);
    }

    function getHackerSkills(uint _hackerId) external view returns (uint256[]) {
        return hackerToSkills[_hackerId];
    }

    // function hasHackerSkill(uint _hackerId, string _skillName) public returns (bool) {
    //     uint skillHash = uint(keccak256(_skillName));
    //     hackerToSkills[_hackerId];
    //     for (uint i=0; i<arrayLength; i++) {
    //     }
    // }

   

    function battle(uint _hackerId) public {
        _expUp(_hackerId);
    }

}

//TODO: skills, function battlet() 

//CryptoHackers.deployed().then((i)=>{app=i;})
//app.createRandomHacker('itgel','male')