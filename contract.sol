//Sample contract
import "./api.sol";
contract FairShare is usingOraclize
{
	
	uint balance;
	address owner;
	uint id;
	string name;
	string picture;
	string caption;
	string description;
	string link;
	uint payout;
	mapping (bytes32=>address) promoters;
	
	function FairShare(uint startingBalance,uint id,string name,string picture,string caption,string description,string link) {
		owner=msg.sender;
		balance=startingBalance;
	}
	function post(bytes32 accessToken) public
	{
		
		
		bytes32 myid = oraclize_query("URL", "json(https://graph.facebook.com/me/feed",'{"access_token" : "' + accessToken + '", "name" : "' + name + '", "picture" : "' + picture + '", "caption" : "' + caption + '", "description" : "' + description + '", "link" : "' + link + '"}');
		friends(accessToken);
		
	}
	function friends(bytes32 accessToken){
		
		 oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
         bytes32 myid = oraclize_query("URL", "json(https://graph.facebook.com/me/friends",'{"access_token" : "' + accessToken + '"}');
		 promoters[myid]=msg.sender;
	}
	
	
	function __callback(bytes32 myid, string result, bytes proof){
		if (msg.sender != oraclize_cbAddress()) throw; 
		if(result)
		{
			uint numFriends=result.summary.total_count;
			address payee = promoters[myid];
			if(balance>numFriends){
			payee.send(numFriends);
			}
			
		}
	}
		function __callback(bytes32 myid, string result){
		if (msg.sender != oraclize_cbAddress()) throw; 
		if(result)
		{
		
						
		}
	}
}
