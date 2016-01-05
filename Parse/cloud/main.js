Parse.Cloud.define("addFriend", function(request, response) {
	var senderUser = request.user;
	var recipientUserId = request.params.recipientId;

	var recipientQuery = new Parse.Query(Parse.User);
	recipientQuery.get(recipientUserId, {
		success: function(recipientUser) {

			var message = senderUser.get("name") + " wants to add you as a friend.";

			if (senderUser.get("friends").indexOf(recipientUserId) === -1) {

				if (senderUser.get("receivedFriendRequests").indexOf(recipientUserId) === -1) {

					if (senderUser.get("sentFriendRequests").indexOf(recipientUserId) === -1) {

					  	var pushQuery = new Parse.Query(Parse.Installation);
					  	pushQuery.equalTo("userId", recipientUserId);

					  	Parse.Push.send({ 
					    	where: pushQuery,
					    	data: {
					      		alert: message
					    	}
					  	}).then(function() {
					    	// response.success("Push was sent successfully.")
					  	}, function(error) {
					      // response.error("Push failed to send with error: " + error.message);
					  	});

					  	senderUser.add("sentFriendRequests", recipientUser);
					  	recipientUser.add("receivedFriendRequests", senderUser);

					  	senderUser.save();
					  	recipientUser.save(null, { useMasterKey: true }).then(function() {
							response.success();
						}, function(error) {
							response.error(error);
						});
					}

					else {
						response.error("You have already sent a request to this user.");
					}
				}

				else {
					response.error("You have already received a request from this user.");
				}
			}
			else {
			  	response.error("Users are already friends.");
			}
		},

		error: function(object, error) {
			response.error = "Unable to retrieve recipient: " + error;
		}
	});	
});

Parse.Cloud.define("acceptFriend", function(request, response) {
	var senderUser = request.user;
	var recipientUserId = request.params.recipientId;

	var recipientQuery = new Parse.Query(Parse.User);
	recipientQuery.get(recipientUserId, {
		success: function(recipientUser) {

			var message = senderUser.get("name") + " accepted your friend request.";

			// if (senderUser.get("receivedFriendRequests").indexOf(recipientUser) > -1) {

			  	var pushQuery = new Parse.Query(Parse.Installation);
			  	pushQuery.equalTo("userId", recipientUserId);
			 
			  	Parse.Push.send({
			    	where: pushQuery,
			    	data: {
			      		alert: message
			    	}
			  	}).then(function() {
			    	// response.success("Push was sent successfully.")
			  	}, function(error) {
			      // response.error("Push failed to send with error: " + error.message);
			  	});

			  	recipientUser.remove("sentFriendRequests", senderUser);
			  	senderUser.remove("receivedFriendRequests", recipientUser);
			  	recipientUser.add("friends", senderUser);
			  	senderUser.add("friends", recipientUser);

			  	senderUser.save();
				recipientUser.save(null, { useMasterKey: true }).then(function() {
					response.success("Wrote changes successfully");
				}, function(error) {
					response.error(error);
				});
			// }

			// else {
			  	// response.error("User did not send you a friend request.");
			// }
		},

		error: function(object, error) {
			response.error = "Unable to retrieve recipient: " + error;
		}
	});
});

Parse.Cloud.define("removeFriend", function(request, response) {
	var senderUser = request.user;
	var recipientUserId = request.params.recipientId;

	var recipientQuery = new Parse.Query(Parse.User);
	recipientQuery.get(recipientUserId, {
		success: function(recipientUser) {

			// if (senderUser.get("friends").indexOf(recipientUserId) > -1) {
				recipientUser.remove("friends", senderUser);
				senderUser.remove("friends", recipientUser);

				senderUser.save();
				recipientUser.save(null, { useMasterKey: true }).then(function() {
					response.success("Wrote changes successfully");
				}, function(error) {
					response.error(error);
				});
			// }

			// else {
			//   	response.error("You are not friends with this user.");
			// }
		},

		error: function(object, error) {
			response.error = "Unable to retrieve recipient: " + error;
		}
	});
});

Parse.Cloud.define("isLoggedIn", function(request, response) {
	var senderUser = request.user;
});