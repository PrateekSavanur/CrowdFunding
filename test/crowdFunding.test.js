const { getContractFactory } = require("@nomiclabs/hardhat-ethers/types")
const { assert } = require("chai")
const { ethers, getNamedAccounts, deployments } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

// const TARGET = "1000"
// const DEADLINE = "3600"

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Crwod Funding Tests ", () => {
          let crowdFund, crowdFunding, minAmount
          beforeEach(async () => {
              accounts = await ethers.getSigners()
              deployer = accounts[0]
              funder = accounts[1]
              await deployments.fixture("deploy")
              crowdFund = await ethers.getContract("crowdFunding", deployer)
              minAmount = await crowdFund.minContribution()
          })

          describe("Constructor", () => {
              it("Initializes variables", async () => {
                  //   const target = await crowdFund.target()
                  //   const deadline = await crowdFund.deadline()
                  //   assert.equal(target.toString(), TARGET)
                  //   assert.equal(deadline.toString(), DEADLINE)
                  const manager = await crowdFund.manager()
                  assert.equal(manager, deployer.address)
              })
          })
          describe("Send Ethereum", () => {
              it("Checks if ethereum amout is correct", async () => {
                  await crowdFund.sendEth({ value: minAmount })
                  const balance = await crowdFund.getContractBalance()
                  assert.equal(balance.toString(), minAmount.toString())
              })
          })
          // Test must be written for all the functions
      })
