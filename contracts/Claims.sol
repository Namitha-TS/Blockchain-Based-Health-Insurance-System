pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/lifecycle/Destructible.sol";


/// @title Insurance Claims BlockChain
/// @author Victor Van Herk
/// @notice You can use this contract for only basic claims processing
/// @dev Function calls are implemented without side effects
contract Claims is Destructible {

    
    // mapping of required user type/addresses
    mapping (address => bool) public registered;
    mapping (address => bool) public admins;
    mapping (address => bool) public policyHolders;
    mapping (address => bool) public appraisers;
    mapping (address => bool) public adjusters;

    // Contract Owner
    //address public owner;

    // Claim Count 
    uint public claimCount;

    // Claim State
    enum ClaimState {open, appraised, approved, closed}

    // Claim Info
    struct Claim {
        uint number;
        ClaimState state;
        address policyHolder;
        address appraiser;
        address adjuster;
        string firstName;
        uint policyNumber;
        uint appraisedValue;
        uint approvedValue;

    }

    // Mapping of claims
    mapping(uint => Claim) public claims;


    // Verify address is policy holder    
    modifier verifyPolicyHolder 
    { 
      require (policyHolders[msg.sender] == true); 
      _;
    }

    // Verify address is appraiser   
    modifier verifyAppraiser 
    { 
      require (appraisers[msg.sender] == true); 
      _;
    }

    // Verify address is claims adjuster    
    modifier verifyAdjuster 
    { 
      require (adjusters[msg.sender] == true); 
      _;
    }

    // Verify claim state is open  
    modifier claimOpen(uint claimNumber) 
    { 
      require (claims[claimNumber].state == ClaimState.open); 
      _;
    }

    // Verify claim state is open  
    modifier claimAppraised(uint claimNumber) 
    { 
      require (claims[claimNumber].state == ClaimState.appraised); 
      _;
    }

    // Events - publicize actions to external listeners
    
    // Log registration events
    event LogRegistered(address accountAddress);
    event LogRegisteredPolicyHolder(address policyHolderAddress);
    event LogRegisteredAppraiser(address appraiserAddress);
    event LogRegisteredAdjuster(address adjusterAddress);

 
    /// @author Victor Van Herk
    /// @notice Constructor of claims contract
    /// @dev claim count set to zero
    constructor() public {
        // set owner of contract
        owner = msg.sender;
        claimCount = 0;
    }
   
    /// @author Victor Van Herk
    /// @notice Get owner of contract
    /// @return owner The address of contract owner
    function getOwner() public view returns(address) {
        return owner;
    }

    /// @author Victor Van Herk
    /// @notice test routine
    /// @return string
    function getOwnerName() public pure returns(string) {
        string memory ownerName = "Victor";
        return ownerName;
    }

    /// @author Victor Van Herk
    /// @notice Get claim count
    /// @return claimcount The count of claims
    function getClaimCount() public view returns(uint) {
        return claimCount;
    }

    /// @author Victor Van Herk
    /// @notice Increment the claim count
    /// @dev May want to have max claims set here if required
    function incrementClaimCount() public {
        claimCount++;
    }


    /// @author Victor Van Herk
    /// @notice Register
    /// @dev test function only
    /// @return bool
    function register() public returns (bool){
        registered[msg.sender] = true;
        emit LogRegistered(msg.sender);
        return true;
    }

    // Role related functions

    /// @author Victor Van Herk
    /// @notice Register a policy holder 
    /// @dev Emits LogRegisteredPolicyHolder event
    /// @return The users registered status
    function registerPolicyHolder() public returns (bool){
        policyHolders[msg.sender] = true;
        emit LogRegisteredPolicyHolder(msg.sender);
        return true;
    }


    /// @author Victor Van Herk
    /// @notice Register an appraiser
    /// @dev Emits LogRegisteredAppraiser event
    /// @return The users registered status
    function registerAppraiser() public returns (bool){
        appraisers[msg.sender] = true;
        emit LogRegisteredAppraiser(msg.sender);
        return true;
    }


    /// @author Victor Van Herk
    /// @notice Register a claims adjuster
    /// @dev Emits LogRegisteredAdjuster event
    /// @return The users registered status
    function registerAdjuster() public returns (bool){
        adjusters[msg.sender] = true;
        emit LogRegisteredAdjuster(msg.sender);
        return true;
    }


    // Claims processing related functions


    /// @author Victor Van Herk
    /// @notice Open a new claim
    /// @return claimNumber The claim number
    function openClaim(string firstName) public verifyPolicyHolder returns(uint) {

        incrementClaimCount();
        claims[claimCount].state = ClaimState.open;
        claims[claimCount].number = claimCount;
        claims[claimCount].policyHolder = msg.sender;
        claims[claimCount].firstName = firstName;
        return getClaimCount();
    }


    /// @author Victor Van Herk
    /// @notice Appraise value of an existing claim
    /// @param claimNumber The claim number
    /// @param appraisedValue The appraised value
    /// @return claimNumber The claim number
    function appraiseClaim(uint claimNumber, uint appraisedValue) public verifyAppraiser claimOpen(claimNumber) returns(uint) {

        claims[claimNumber].state = ClaimState.appraised;
        claims[claimNumber].appraiser = msg.sender;
        claims[claimNumber].appraisedValue = appraisedValue;
        return getClaimCount();
    }

    /// @author Victor Van Herk
    /// @notice Approve value of an appraised claim
    /// @param claimNumber The claim number
    /// @param approvedValue The approved value
    /// @return claimNumber The claim number
    function approveClaim(uint claimNumber, uint approvedValue) public verifyAdjuster claimAppraised(claimNumber) returns(uint) {

        claims[claimNumber].state = ClaimState.approved;
        claims[claimNumber].appraiser = msg.sender;
        claims[claimNumber].approvedValue = approvedValue;
        claims[claimNumber].state = ClaimState.closed;
        // vvh todo claims[claimNumber].policyHolder.transfer(msg.value);
        return getClaimCount();
    }



    /// @author Victor Van Herk
    /// @notice Get claim information
    /// @param claimNumber The claim number
    /// @return claim The claim information
    function getClaim(uint claimNumber) public view 
                returns(uint, uint, uint, uint) {

        Claim memory claim = claims[claimNumber];
        return (claim.number, claim.policyNumber, claim.appraisedValue, claim.approvedValue);
    }



    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() public {
        revert();
    }
}
