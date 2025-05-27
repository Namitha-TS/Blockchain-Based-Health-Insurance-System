pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Claims.sol";

contract TestClaims {
  Claims claims = Claims(DeployedAddresses.Claims());


	// Testing 

    /// @author Victor Van Herk
    /// @notice Test claim number zero on contract deployment
	function testClaimNumberZero() public {

		uint claimNumber = claims.getClaimCount();

	  	uint expectedNumber = 0;

	  	Assert.equal(claimNumber, expectedNumber, "Claim Number should be zero");
	}

    /// @author Victor Van Herk
    /// @notice Test claim number correctly incremented
	function testClaimNumberIncremented() public {

		claims.incrementClaimCount();

	  	uint returnedNumber = claims.getClaimCount();

	  	uint expectedNumber = 1;

	  	Assert.equal(returnedNumber, expectedNumber, "Claim Number should be 1");
	}

    /// @author Victor Van Herk
    /// @notice Test returning hard coded owner string from contract
	function testOwnerName() public {

		string memory ownerName = claims.getOwnerName();
		Assert.equal(ownerName, "Victor", "Owner name does not match");
	}

    /// @author Victor Van Herk
    /// @notice Test contract has owner
	function testGetOwner() public {

		address contractOwner = claims.getOwner();
		bool isAccount = contractOwner > 0x0;

		Assert.equal(isAccount, true, "Owner is not valid");
	}
	
    /// @author Victor Van Herk
	/// @notice function will test registering policy holder
	/// @notice function will test opening new claim
	/// @notice function will test claim count incremented
	function testOpenClaim() public {

		uint claimNumber = claims.getClaimCount();
		bool isPolicyHolder = claims.registerPolicyHolder();

		Assert.equal(isPolicyHolder, true, "Policy Holder invalid");

		uint newClaimNumber = claims.openClaim("Vic");
		Assert.equal(newClaimNumber, claimNumber+1, "Claim count not incremented ");

	}

    /// @author Victor Van Herk
	/// @notice function will test registering appraiser
	/// @notice function will test appraising existing claim
	function testAppraiseClaim() public {

		uint claimNumber = claims.getClaimCount();
		bool isAppraiser = claims.registerAppraiser();

		Assert.equal(isAppraiser, true, "Appraiser invalid");

		uint appraisedClaimNumber = claims.appraiseClaim(claimNumber, 1500);
		Assert.equal(appraisedClaimNumber, claimNumber, "Claim not appraised");

	}

    /// @author Victor Van Herk
	/// @notice function will test registering claims adjuster
	/// @notice function will test approving existing claim
	function testApproveClaim() public {

		uint claimNumber = claims.getClaimCount();
		bool isAdjuster = claims.registerAdjuster();

		Assert.equal(isAdjuster, true, "Adjuster invalid");

		uint approvedClaimNumber = claims.approveClaim(claimNumber, 1500);
		Assert.equal(approvedClaimNumber, claimNumber, "Claim not approved");

	}

}