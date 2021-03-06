import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_mobile/admin_app/shared_admin/app_bar.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/rsa_provider.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:pointycastle/export.dart' as ac;

class StorageTest extends StatefulWidget {
  StorageTest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StorageTestState createState() => _StorageTestState();
}

class _StorageTestState extends State<StorageTest> {
  // future to hold computed text form of key
  Future<String> futureText;

  // Future reference to key pair generated by functions
  Future<ac.AsymmetricKeyPair<ac.PublicKey, ac.PrivateKey>> futureKeyPair;

  // declare current keyPair
  ac.AsymmetricKeyPair keyPair;

  // generate a new asymmetric key pair
  Future<ac.AsymmetricKeyPair<ac.PublicKey, ac.PrivateKey>>
  getKeyPair() {
    var keyHelper = RSAProvider.of(context).getKeyHelper();
    return keyHelper.computeKeyPair(keyHelper.getSecureRandom());
  }

  // for showing the snackbar when copying to clipboard is successful
  /// for testing only
  final key = new GlobalKey<ScaffoldState>();

  // allows text editing so that plaintext can be signed
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: CustomAppBar(title: 'Strikeplate'),
      drawer: MakeDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  "Generate new Key Pair",
                  style: TextStyle(
                    color: mainFG,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    // If there are any pemString being shown, then show an empty message
                    futureText = Future.value("");
                    // Generate a new keypair
                    futureKeyPair = getKeyPair();
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder<
                    ac.AsymmetricKeyPair<ac.PublicKey,
                        ac.PrivateKey>>(
                    future: futureKeyPair,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // if we are waiting for a future to be completed, show a progress indicator
                        return Center(
                          child: SpinKitFadingCube(
                          size: 100,
                          color: Colors.orangeAccent,
                        ),);
                      } else if (snapshot.hasData) {
                        // Else, store the new keypair in this state and sbow two buttons
                        this.keyPair = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            MaterialButton(
                              color: Colors.red,
                              child: Text("Get Private Key",
                                  style: TextStyle(
                                    color: mainFG,
                                  )),
                              onPressed: () {
                                setState(() {
                                  // With the stored keypair, encode the private key to
                                  // PKCS1 string and show it
                                  futureText = Future.value(
                                      RSAProvider.of(context)
                                          .getKeyHelper()
                                          .privateToString(
                                          keyPair.privateKey));
                                });
                              },
                            ),
                            MaterialButton(
                              color: Colors.green,
                              child:
                              Text("Get Public Key", style: TextStyle(color: mainFG)),
                              onPressed: () {
                                setState(() {
                                  // With the stored keypair, encode the public key to
                                  // PKCS1 and show it
                                  futureText = Future.value(
                                      RSAProvider.of(context)
                                          .getKeyHelper()
                                          .publicToString(
                                          keyPair.publicKey));
                                });
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "Text to Sign"
                              ),
                              controller: _controller,
                            ),
                            MaterialButton(
                              color: Colors.blue,
                              child:
                              Text("Sign Text", style: TextStyle(color: mainFG)),
                              onPressed: () {
                                setState(() {
                                  futureText = Future.value(
                                      RSAProvider.of(context)
                                          .getKeyHelper()
                                          .sign(
                                          _controller.text,
                                          keyPair.privateKey));
                                });
                              },
                            ),

                          ],
                        );
                      } else {
                        return Container(
                        );
                      }
                    }),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  color: mainBG,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: FutureBuilder(
                        future: futureText,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              // the inkwell is used to register the taps
                              // in order to be able to copy the text
                              child: InkWell(
                                  onTap: () {
                                    // Copies the data to the keyboard
                                    Clipboard.setData(
                                        new ClipboardData(text: snapshot.data));
                                    key.currentState.showSnackBar(new SnackBar(
                                      content: new Text("Copied to Clipboard"),
                                    ));
                                  },
                                  child: Text(snapshot.data)),
                            );
                          } else {
                            return Center(
                              child: Text("Your keys will appear here"),
                            );
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}