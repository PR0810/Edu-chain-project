*GamifiedQA*

## Project Description
GamifiedQA is a decentralized platform for asking and answering questions in exchange for rewards. Using a smart contract on the Ethereum blockchain, users can ask questions with a specified reward, provide answers to questions, and vote for the best answers. The answerer with the most upvotes receives the reward in ERC20 tokens. This contract aims to incentivize quality answers by gamifying the process and ensuring transparency in how rewards are distributed.

## Contract Address
0x2280Cc464276df86954B588Ede208a8C3930C370
![image](https://github.com/user-attachments/assets/8b3ca952-e24f-454d-9b3b-fc246882d053)


## Key Features
- **Ask Questions**: Users can ask questions with a reward in ERC20 tokens.
- **Submit Answers**: Users can submit answers to questions and contribute to the knowledge base.
- **Upvote Answers**: Users can upvote answers to highlight the best solutions.
- **Mark Best Answer**: The asker can mark the best answer, and the answerer receives the reward.
- **Reward Mechanism**: The answerer with the most upvotes for a question receives a reward in ERC20 tokens.
- **Rewards Claiming**: Users can claim their earned rewards once the best answer is marked.
- **Owner Withdrawal**: The contract owner can withdraw tokens if necessary, maintaining control over the contract's balance.
- **Token Compatibility**: The contract is designed to support any ERC20 token as the reward currency.

## Usage Instructions
1. **Deploy the contract**: The contract needs to be deployed to the Ethereum blockchain with the address of an ERC20 token to be used for rewards.
2. **Ask a Question**: To ask a question, call the `askQuestion()` function with the content of the question and the reward amount.
3. **Submit an Answer**: Answerers can submit their answers using the `submitAnswer()` function.
4. **Upvote Answers**: Upvote answers with the `upvoteAnswer()` function to show support for the best answers.
5. **Mark Best Answer**: Once a question is answered, the asker can call the `markBestAnswer()` function to select the best answer and distribute the reward.
6. **Claim Rewards**: The answerer can claim their earned reward by calling the `claimRewards()` function.
