// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // for more about customizing your Truffle configuration!
//   networks: {
//     development: {
//       host: "127.0.0.1",
//       port: 8545,
//       network_id: "*" // Match any network id
//     }
//   }
// };

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    }
  },

  compilers: {
    solc: {
      version: "0.4.24", // Replace with the version you need (e.g., 0.4.24)
    },
  },
};
