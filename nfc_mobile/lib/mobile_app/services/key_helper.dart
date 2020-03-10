import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import "package:asn1lib/asn1lib.dart";
import 'package:flutter/foundation.dart';
import "package:pointycastle/export.dart";

// Helper class for RSA encoding
class KeyHelper {
  // generate a public/private key pair with a future
  Future<AsymmetricKeyPair<PublicKey, PrivateKey>> computeKeyPair(
      SecureRandom secureRandom) async {
    return await compute(getKeyPair, secureRandom);
  }

  // secure random seed for computing key pair
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

  // decode public key from a string format.
  // after transmission of string public key and storage in database, use this
  // method to sign for the challenge on both the server and the client
  RSAPublicKey parsePublicFromString(pString) {
    List<int> publicKeyDER = decodePEM(pString);
    var asn1Parser = new ASN1Parser(publicKeyDER);
    var binarySequence = asn1Parser.nextObject() as ASN1Sequence;
    var modulus;
    var exponent;

    // Depending on the first element type, we either have PKCS1 or 2
    if (binarySequence.elements[0].runtimeType == ASN1Integer) {
      modulus = binarySequence.elements[0] as ASN1Integer;
      exponent = binarySequence.elements[1] as ASN1Integer;
    } else {
      var publicKeyBitString = binarySequence.elements[1];

      var publicKeyAsn = new ASN1Parser(publicKeyBitString.contentBytes());
      ASN1Sequence publicKeySeq = publicKeyAsn.nextObject();
      modulus = publicKeySeq.elements[0] as ASN1Integer;
      exponent = publicKeySeq.elements[1] as ASN1Integer;
    }

    RSAPublicKey rsaPublicKey =
    RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);

    return rsaPublicKey;
  }

  // sign plaintext input with private key, return string
  String sign(String plainText, RSAPrivateKey privateKey) {
    var signer = RSASigner(SHA256Digest(), "0609608648016503040201");
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return  base64Encode(signer.generateSignature(createListFromString(plainText)).bytes);
  }


  // used in above code for returning a string out of bytes
  Uint8List createListFromString(String s) {
    var codec = Utf8Codec(allowMalformed: true);
    return Uint8List.fromList(codec.encode(s));
  }

  // Output string value of private key. Only necessary for testing
  // **** remove this functionality later!
  RSAPrivateKey parsePrivateFromString(pString) {
    List<int> privateKeyDER = decodePEM(pString);
    var asn1Parser = new ASN1Parser(privateKeyDER);
    var binarySequence = asn1Parser.nextObject() as ASN1Sequence;

    var modulus, privateExponent, p, q;
    // Depending on the number of elements, we will either use PKCS1 or PKCS8
    if (binarySequence.elements.length == 3) {
      var privateKey = binarySequence.elements[2];

      asn1Parser = new ASN1Parser(privateKey.contentBytes());
      var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

      modulus = pkSeq.elements[1] as ASN1Integer;
      privateExponent = pkSeq.elements[3] as ASN1Integer;
      p = pkSeq.elements[4] as ASN1Integer;
      q = pkSeq.elements[5] as ASN1Integer;
    } else {
      modulus = binarySequence.elements[1] as ASN1Integer;
      privateExponent = binarySequence.elements[3] as ASN1Integer;
      p = binarySequence.elements[4] as ASN1Integer;
      q = binarySequence.elements[5] as ASN1Integer;
    }

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger);

    return rsaPrivateKey;
  }

  List<int> decodePEM(String pem) {
    return base64.decode(removeHeaderAndFooter(pem));
  }

  String removeHeaderAndFooter(String pem) {
    var startsWith = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN RSA PRIVATE KEY-----",
      "-----BEGIN RSA PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
      "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
      "-----END RSA PRIVATE KEY-----",
      "-----END RSA PUBLIC KEY-----",
      "-----END PGP PUBLIC KEY BLOCK-----",
      "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

    pem = pem.replaceAll(' ', '');
    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    for (var s in startsWith) {
      s = s.replaceAll(' ', '');
      if (pem.startsWith(s)) {
        pem = pem.substring(s.length);
      }
    }

    for (var s in endsWith) {
      s = s.replaceAll(' ', '');
      if (pem.endsWith(s)) {
        pem = pem.substring(0, pem.length - s.length);
      }
    }

    if (isOpenPgp) {
      var index = pem.indexOf('\r\n');
      pem = pem.substring(0, index);
    }

    return pem;
  }

  // encode Private key to PEM format for storage on disk later
  String privateToString(RSAPrivateKey privateKey) {

    var binarySequence = new ASN1Sequence();

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

    binarySequence.add(version);
    binarySequence.add(modulus);
    binarySequence.add(publicExponent);
    binarySequence.add(privateExponent);
    binarySequence.add(p);
    binarySequence.add(q);
    binarySequence.add(exp1);
    binarySequence.add(exp2);
    binarySequence.add(co);

    var dataBase64 = base64.encode(binarySequence.encodedBytes);

    return """-----BEGIN RSA PRIVATE KEY-----\r\n$dataBase64\r\n-----END RSA PRIVATE KEY-----""";
  }

  // Encode public key to string, likely required for OG transmission
  String publicToString(RSAPublicKey publicKey) {
    var binarySequence = new ASN1Sequence();

    binarySequence.add(ASN1Integer(publicKey.modulus));
    binarySequence.add(ASN1Integer(publicKey.exponent));

    var dataBase64 = base64.encode(binarySequence.encodedBytes);
    return """-----BEGIN RSA PUBLIC KEY-----\r\n$dataBase64\r\n-----END RSA PUBLIC KEY-----""";
  }
}

// Generate RSA public and private key pair
AsymmetricKeyPair<PublicKey, PrivateKey> getKeyPair(
    SecureRandom secureRandom) {
  var rsaParameters = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
  var parameters = new ParametersWithRandom(rsaParameters, secureRandom);
  var keyGenerator = new RSAKeyGenerator();
  keyGenerator.init(parameters);
  return keyGenerator.generateKeyPair();
}