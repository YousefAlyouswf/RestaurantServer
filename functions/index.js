const functions = require('firebase-functions');
const admin = require('firebase-admin');

 admin.initializeApp(functions.config().firebase);

var msgData;

exports.offerTrigger = functions.firestore.document(
    'Requests/{RequestsId}'
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
    return admin.firestore().collection('pushToken').get().then(snapshots => {
        var tokens = [];
        for (var token of snapshots.docs) {
            tokens.push(token.data().devtoken)
        }

        var payLoad = {
            "notification": {
                "title": "اسم العميل " + msgData.name,
                "body": "عنوان العميل " + msgData.address,
                "sound": "default"
            },
            "data": {
                "sendername": msgData.name,
                "message": msgData.address
            }
        }
        return admin.messaging().sendToDevice(tokens, payLoad).then((responce) => {
            console.log('pushed them all');
            return null;
        }).catch((err) => {
            console.log(err);
            return null;
        })
      
    })

})
