import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as crypto from 'crypto';
import * as NodeRSA from 'node-rsa';

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

export const postUserID = functions.https.onRequest(async (req, res) => {
  if (req.method === "POST") {
    if(req.body.FunctionType === "1") {
      const nonceVal = crypto.randomBytes(16).toString('base64');
      const nonceIDVal = crypto.randomBytes(16).toString('base64');
      const data = {dirtybit: 1, nonce: nonceVal};
      const set: boolean = await db.collection("challenges").doc(nonceIDVal).set(data)
      .then( function () {
        return true;
      })
      .catch(err => {
        console.error("Error writing challenge document:", err);
        return false;
      });
      if(!set) {
        return res.status(500).json({
          message: "Error writing challenge document"
        })
      }
      return res.status(200).json({
        challenge: nonceVal,
        nonceID: nonceIDVal
      })
    } else if (req.body.FunctionType ==="2") {
      console.log(req.body.readerID);
      const docSnap = await db.collection("users").doc(req.body.userID).get()  
      .then(doc => {
        if (!doc.exists) {
          console.log('No such document!');
          return res.status(500).json({
            message: "No such document!"
          })
        } else { 
          const keyString: string = doc.get("pubKey");
          return keyString;
        }
      })
      .catch(err => {
        console.log("Pubkey error", err);
        return res.status(500).json({
          message: "Error getting public key"
        })
      })
      const key = new NodeRSA(docSnap);
      let nonceValue = "";
      let verified = "";
      await statusReturn(req.body.nonceID)
        .then(value => {
          nonceValue = value;
          const nonceValueBuffer = Buffer.from(nonceValue);
          const signature = Buffer.from(req.body.signature, 'base64');
          const verify = key.verify(nonceValueBuffer, signature);
          verified = verify.toString();
        })
        .catch(err => {
          console.log('Error getting nonceID', err)
        });
      const docRef = db.collection("challenges").doc(req.body.nonceID);
      const data = {dirtybit: 0};
      const set: boolean = await docRef.set(data).then(function () {
        return true;
      })
      .catch(err => {
        console.log("Error setting challenges document with nonceIDVal2 and data2")
        return false;
      });
      if(!set) {
        const payload = { notification : { title: 'NO', body : req.body.userID.toString()}}
        const response = await admin.messaging().sendToDevice(req.body.readerID, payload);
        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            console.log('Failure sending notification to reader', error);
          } else {
            console.log('NO message sent to reader')
          }
        })
        return res.status(500).json({
          message: "Error writing challenge document 2"
        })
      } else {
        const payload = { notification : { title : 'OK', body : req.body.userID.toString()}}
        const response = await admin.messaging().sendToDevice(req.body.readerID, payload);
        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            console.log('Failure sending notification to reader', error);
          } else {
            console.log('OK Message sent to reader')
          }
        })
        return res.status(200).json({
          message: "Dirty bit set to 0",
          status: verified
        })
      }
    }
    else {
      return res.status(400).json({
        message: "Invalid Function Request"
      })
    }
  } else {
    return res.status(500).json({
      message: "Bad Request"
    })
  }
})


async function statusReturn(nonceID: string) {
  const nonceVal = await db.collection("challenges").doc(nonceID).get()
  .then(doc => {
    if (!doc.exists) {
      console.log('No such document.');
      return null;
    } else {
      const nonceValue = doc.get("nonce");
      return nonceValue;
    }
  })          
  .catch(err => {
    console.log('Error getting nonce from database!', err);
  });
  return nonceVal;
}
