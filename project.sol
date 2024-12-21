// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract GamifiedQA {
    address public owner;
    IERC20 public rewardToken;

    struct Question {
        uint256 id;
        address asker;
        string content;
        uint256 rewardAmount;
        uint256 totalUpvotes;
        bool answered;
        address bestAnswerer;
    }

    struct Answer {
        address answerer;
        string content;
        uint256 upvotes;
    }

    mapping(uint256 => Question) public questions;
    mapping(uint256 => Answer[]) public answers;
    mapping(address => uint256) public earnedRewards;

    uint256 public nextQuestionId;

    event QuestionAsked(address indexed asker, uint256 questionId, string content, uint256 rewardAmount);
    event AnswerSubmitted(uint256 indexed questionId, address indexed answerer, string content);
    event AnswerUpvoted(uint256 indexed questionId, uint256 indexed answerIndex, address indexed voter);
    event RewardsClaimed(address indexed expert, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardToken = IERC20(_rewardToken);
    }

    // Ask a new question with a reward
    function askQuestion(string memory content, uint256 rewardAmount) public {
        require(rewardAmount > 0, "Reward must be greater than zero.");
        questions[nextQuestionId] = Question({
            id: nextQuestionId,
            asker: msg.sender,
            content: content,
            rewardAmount: rewardAmount,
            totalUpvotes: 0,
            answered: false,
            bestAnswerer: address(0)
        });
        emit QuestionAsked(msg.sender, nextQuestionId, content, rewardAmount);
        nextQuestionId++;
    }

    // Submit an answer to a question
    function submitAnswer(uint256 questionId, string memory content) public {
        require(bytes(content).length > 0, "Answer cannot be empty.");
        require(!questions[questionId].answered, "Question already answered.");
        answers[questionId].push(Answer({
            answerer: msg.sender,
            content: content,
            upvotes: 0
        }));
        emit AnswerSubmitted(questionId, msg.sender, content);
    }

    // Upvote an answer
    function upvoteAnswer(uint256 questionId, uint256 answerIndex) public {
        require(answerIndex < answers[questionId].length, "Invalid answer index.");
        require(msg.sender != answers[questionId][answerIndex].answerer, "You cannot upvote your own answer.");

        answers[questionId][answerIndex].upvotes += 1;
        questions[questionId].totalUpvotes += 1;

        emit AnswerUpvoted(questionId, answerIndex, msg.sender);
    }

    // Mark the best answer and reward the answerer
    function markBestAnswer(uint256 questionId, uint256 answerIndex) public {
        require(msg.sender == questions[questionId].asker, "Only the asker can mark the best answer.");
        require(answerIndex < answers[questionId].length, "Invalid answer index.");
        
        Question storage q = questions[questionId];
        Answer storage bestAnswer = answers[questionId][answerIndex];

        q.answered = true;
        q.bestAnswerer = bestAnswer.answerer;

        uint256 reward = q.rewardAmount;
        earnedRewards[bestAnswer.answerer] += reward;

        emit RewardsClaimed(bestAnswer.answerer, reward);
    }

    // Claim earned rewards
    function claimRewards() public {
        uint256 amount = earnedRewards[msg.sender];
        require(amount > 0, "No rewards available.");
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient contract balance.");

        earnedRewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, amount);

        emit RewardsClaimed(msg.sender, amount);
    }

    // Contract owner can withdraw tokens
    function withdrawTokens(uint256 amount) public onlyOwner {
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient contract balance.");
        rewardToken.transfer(owner, amount);
    }
}