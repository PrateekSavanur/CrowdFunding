const TARGET = 100000
const DEADLINE = 180000

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const arguments = [TARGET, DEADLINE]

    log("Deploying......")

    const crowd = await deploy("crowdFunding", {
        from: deployer,
        args: arguments,
        log: true,
    })

    log("Deployed!!!")
}

module.exports.tags = ["deploy"]
