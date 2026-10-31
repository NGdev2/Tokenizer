import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// Deploys the token. The whole supply and the owner role go to `initialOwner`, which
// defaults to the deploying account. Override it with --parameters if needed.
export default buildModule("AidarFteganChain42TestModule", (m) => {
  const initialOwner = m.getParameter("initialOwner", m.getAccount(0));

  const token = m.contract("AidarFteganChain42Test", [initialOwner]);

  return { token };
});
