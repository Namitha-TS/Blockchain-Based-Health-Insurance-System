App = {
  web3Provider: null,
  contracts: {},

  policyHolders: [],
  appraisers: [],
  approvers: [],

  init: function() {
    console.log("init:");
    return App.initWeb3();
  },

  initWeb3: function() {
    console.log("initWeb3:");

    App.policyHolders.push("aaa");
    console.log(App.policyHolders[0]);

    // Check for injected web3 instance or window.ethereum for MetaMask
    if (typeof window.ethereum !== 'undefined') {
      App.web3Provider = window.ethereum;
      // Request account access if needed
      window.ethereum.request({ method: 'eth_requestAccounts' })
        .then(function(accounts) {
          console.log("Connected Account: ", accounts[0]);
          $("#account-number").text("Account # " + accounts[0]);
        })
        .catch(function(error) {
          console.error("User denied account access:", error);
        });
    } else {
      // If no injected web3 instance is detected, use Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }

    web3 = new Web3(App.web3Provider);

    // Listen for account changes in MetaMask
    window.ethereum.on('accountsChanged', function(accounts) {
      console.log('Accounts changed:', accounts);
      $("#account-number").text("Account # " + accounts[0]);
    });

    // Listen for network changes in MetaMask
    window.ethereum.on('chainChanged', function(chainId) {
      console.log('Network changed:', chainId);
    });

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Claims.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var ClaimsArtifact = data;
      App.contracts.Claims = TruffleContract(ClaimsArtifact);

      // Set the provider for our contract
      App.contracts.Claims.setProvider(App.web3Provider);

    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-register1', App.handleRegisterPolicyHolder);
    $(document).on('click', '.btn-register2', App.handleRegisterAppraiser);
    $(document).on('click', '.btn-register3', App.handleRegisterAdjuster);

    $(document).on('click', '.btn-open-claim', App.handleOpenClaim);
    $(document).on('click', '.btn-appraise-claim', App.handleAppraiseClaim);
    $(document).on('click', '.btn-approve-claim', App.handleApproveClaim);
  },

  handleOpenClaim: function(event) {
    event.preventDefault();
    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log("account[0]: " + account);
      $("#account-number").text("Account # " + account);

      var firstName = $("#first-name").val();
      console.log("The first name is: " + firstName);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute
        return claimsInstance.openClaim(firstName, { from: account });

      }).then(function(txHash) {
        return claimsInstance.getClaimCount.call();
      }).then(function(response) {
        console.log("Claim Number is: " + response);
        $("#number-of-claims").text("Number of Claims: " + response);

      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleAppraiseClaim: function(event) {
    event.preventDefault();

    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log("account[0]: " + account);
      $("#account-number").text("Account # " + account);

      var claimNumber = $("#appraisal-claim-number").val();
      var appraisalValue = $("#appraisal-value").val();
      console.log("Claim Number is : " + claimNumber);
      console.log("Appraisal Value is : " + appraisalValue);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute
        return claimsInstance.appraiseClaim(claimNumber, appraisalValue, { from: account });

      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleApproveClaim: function(event) {
    event.preventDefault();

    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log("account[0]: " + account);
      $("#account-number").text("Account # " + account);

      var claimNumber = $("#approval-claim-number").val();
      var approvalValue = $("#approval-value").val();
      console.log("Claim Number is : " + claimNumber);
      console.log("Approval Value is : " + approvalValue);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute
        return claimsInstance.approveClaim(claimNumber, approvalValue, { from: account });

      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getCount: function(claimCount) {
    alert("get count function");

    var claimsInstance;

    App.contracts.Claims.deployed().then(function(instance) {
      claimsInstance = instance;

      return claimsInstance.getClaimCount.call();
    }).then(function(claimCount) {
      $('#count').text(claimCount);
      alert(claimCount);

    }).catch(function(err) {
      console.log(err.message);
    });
  },

  handleRegisterPolicyHolder: function(event) {
    event.preventDefault();
    var name = this.textContent;

    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(account);
      $("#account-number").text("Account # " + account);

      App.policyHolders.push(account);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute register as a transaction by sending account
        return claimsInstance.registerPolicyHolder({ from: account });
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleRegisterAppraiser: function(event) {
    event.preventDefault();
    var name = this.textContent;

    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(account);
      $("#account-number").text("Account # " + account);

      App.appraisers.push(account);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute register as a transaction by sending account
        return claimsInstance.registerAppraiser({ from: account });
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleRegisterAdjuster: function(event) {
    event.preventDefault();
    var name = this.textContent;

    var claimsInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(account);
      $("#account-number").text("Account # " + account);

      App.approvers.push(account);

      App.contracts.Claims.deployed().then(function(instance) {
        claimsInstance = instance;

        // Execute register as a transaction by sending account
        return claimsInstance.registerAdjuster({ from: account });
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
