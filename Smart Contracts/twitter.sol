//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Twitter{

    uint16 public MAX_TWEET_LENGTH = 200;

    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    struct User{
        string username;
        uint16 age;
    }
    
    event NewUserRegistered(address indexed user, string username);



    mapping(address =>  Tweet[] ) public tweets;
    address public owner;
    
    event TweetCreated(uint256 id,address author, string content, uint256 timestamp);
    event TweetLiked(address liker,address tweetAuthor,uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"YOU ARE NOT THE OWNER");
        _;
    }
    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLength;
    }
    function createTweet(string memory tweet) public{

        require(bytes(tweet).length <=MAX_TWEET_LENGTH,"Tweet is too long bro");

        Tweet memory newTweet = Tweet({
            id:tweets[msg.sender].length,
            author: msg.sender,
            content:tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id,newTweet.author,newTweet.content,newTweet.timestamp);

    }
    function likeTweet(address author,uint256 id) external {
        tweets[author][id].likes++;
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }
    function unlikeTweet(address author,uint256 id) external{
        require(tweets[author][id].id ==id,"TWEET DOES NOT EXIST");
        require(tweets[author][id].likes>0,"TWEET HAS NO LIKES");
        tweets[author][id].likes--;

        emit TweetUnliked(msg.sender,author,id,tweets[author][id].likes);
    }
    function getTweet(address owner, uint i) public view returns(Tweet memory){
        return tweets[owner][i];
    }

    function getAllTweets(address owner) public view returns (Tweet[] memory ){
        return tweets[owner];
    }

    mapping(address =>User) public users;

    function registerUser(string memory username,uint16 age) public {
        User storage newUser = users[msg.sender];
        newUser.username = username;
        newUser.age = age;
        emit NewUserRegistered(msg.sender, username);
    }
} 
