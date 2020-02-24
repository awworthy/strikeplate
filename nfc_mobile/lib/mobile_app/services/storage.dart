import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

// main function to generate asymmetric keys for cryptography
AsymmetricKeyPair<PublicKey, PrivateKey> getRSAKeyPair(
    SecureRandom secureRandom) {
  var RSAParameters = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
  var parameters = new ParametersWithRandom(RSAParameters, secureRandom);
  var keyGenerator = new RSAKeyGenerator();
  keyGenerator.init(parameters);
  return keyGenerator.generateKeyPair();
}

class Storage{
  String _publicKey;
  String _privateKey;
  String publicKeyName = 'SP_public_key';
  String privateKeyName = 'SP_private_key';
  AsymmetricKeyPair<PublicKey, PrivateKey> keyPair;

  // This function is attempting to promote asynchronous code
  Future<AsymmetricKeyPair<PublicKey, PrivateKey>> computeRSAKeyPair(
      SecureRandom secureRandom) async {
    return await compute(getRSAKeyPair, secureRandom);
  }

  // Getters for external functions (ie. NFC transmission functions) to obtain
  // copies of the public/private string encodings
  getPublicKey() {
    _loadPublicKey();
    if (_publicKey == null)
      _generateKeys();
    return _publicKey;
  }

  RSAPrivateKey getPrivateKey() {
    _loadPrivateKey();
    if (_privateKey == null)
      _generateKeys();
    return _parsePrivateKey(_privateKey);
  }

  // Load the stored key from memory, load null if nonexistent in memory
  _loadPublicKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _publicKey = (prefs.getString(publicKeyName) ?? null);
    print(_publicKey);
  }

  _loadPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _privateKey = (prefs.getString(privateKeyName) ?? null);
  }

  // Generate new keys using helper functions using RSA and ASN1 specifications
  // ** but first check that keys do not exist already in memory
  _generateKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Run an Isolate to multi-thread and prevent frame-skipping
    Future<AsymmetricKeyPair<PublicKey, PrivateKey>> futureKeyPair = computeRSAKeyPair(getSecureRandom());
    futureKeyPair.then((value) => keyPair = value);
    _publicKey = encodePublicKey(keyPair.publicKey);
    _privateKey = encodePrivateKey(keyPair.privateKey);

    prefs.setString(publicKeyName, _publicKey);
    prefs.setString(privateKeyName, _privateKey);
  }

  // initialization for RSAKeyPair function
  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));
    return secureRandom;
  }


  // encode the public key to base64 string for storage and transmission
  String encodePublicKey(RSAPublicKey publicKey) {
    var topLevel = new ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));

    return base64.encode(topLevel.encodedBytes);
  }

  // encode private key to base64 string for storage and transmission
  String encodePrivateKey(RSAPrivateKey privateKey) {
    var topLevel = new ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(privateKey.exponent);
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    return base64.encode(topLevel.encodedBytes);
  }

  _parsePublicKey(pemString) {
    List<int> publicKeyDER = base64.decode(pemString);
    var asn1Parser = new ASN1Parser(publicKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeyBitString = topLevelSeq.elements[1];

    var publicKeyAsn = new ASN1Parser(publicKeyBitString.contentBytes());
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject();
    var modulus = publicKeySeq.elements[0] as ASN1Integer;
    var exponent = publicKeySeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey = RSAPublicKey(
        modulus.valueAsBigInteger,
        exponent.valueAsBigInteger
    );

    return rsaPublicKey;
  }

  RSAPrivateKey _parsePrivateKey(pemString) {
    List<int> privateKeyDER = base64.decode(pemString);
    var asn1Parser = new ASN1Parser(privateKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var version = topLevelSeq.elements[0];
    var algorithm = topLevelSeq.elements[1];
    var privateKey = topLevelSeq.elements[2];

    asn1Parser = new ASN1Parser(privateKey.contentBytes());
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    version = pkSeq.elements[0];
    var modulus = pkSeq.elements[1] as ASN1Integer;
    var publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;
    var exp1 = pkSeq.elements[6] as ASN1Integer;
    var exp2 = pkSeq.elements[7] as ASN1Integer;
    var co = pkSeq.elements[8] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger
    );

    return rsaPrivateKey;
  }
}

class ParametersWithRandom<UnderlyingParameters extends CipherParameters> implements CipherParameters {
  final UnderlyingParameters parameters;
  final SecureRandom random;

  ParametersWithRandom(this.parameters, this.random);
}
