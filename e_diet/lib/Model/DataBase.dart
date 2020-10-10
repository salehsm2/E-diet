import 'package:firebase_auth/firebase_auth.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Use Constant Variables That Will Be Used Store In DB
//To Prevent Errors Like Spelling Mistakes
const String NameDB = 'name';
const String EmailDB = 'email';
const String PhotoUrlDB = 'photoUrl';
const String AgeDB = 'age';
const String WeightDB = 'weight';
const String HeightDB = 'height';
const String GoalDB = 'goal';
const String GenderDB = 'gender';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final CollectionReference users = _db.collection('users');

// Add User To DB by Creating a new Document with uid
Future<void> addUser(User user, String name) async {
  String userNmae = user.displayName == null ? name : user.displayName;
  return users
      .doc(user.uid)
      .set({
        NameDB: userNmae,
        EmailDB: user.email,
        PhotoUrlDB: user.photoURL == null ? 'null' : user.photoURL
      })
      .then((value) => print('User Added'))
      .catchError((onError) => print("Failed To Print $onError"));
}

//Add User Health Info In DB To The Doc Intiated With uid
Future<void> setUserHealthDB(
    String uid, int age, double weight, double height, String gender) {
  return users
      .doc(uid)
      .update({
        AgeDB: age,
        WeightDB: weight,
        HeightDB: height,
        GenderDB: gender,
      })
      .then((value) => print('User Health is Set'))
      .catchError((onError) => print('Failed to set user Health $onError'));
}

//Add User Goal Info In DB To The Doc Intiated With uid
Future<void> setUserGoalDB(String uid, String goalString) {
  return users
      .doc(uid)
      .update({
        GoalDB: goalString,
      })
      .then((value) => print('User Set Goal Successfully'))
      .catchError((onError) => print('Failed To Set Goal $onError'));
}

//Serach UserEmail In DB
bool getUserEmail(User user)  {
  bool found = false;
  print('Called');
   FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {

      print('Document exists on the database');
      found= true;
    }
    else {
      print('Document Doesnt Exist ');
      found= false;
    }
  }).catchError((onError) => () {
            print('Failed to find user $onError');
          });
  return found;
}

//Fetch User Data From DB through uid
Future<Map<String, dynamic>> fetchUserInfoDB(String uid) async {
  Map<String, dynamic> userInfo = new Map<String, dynamic>();
  await users.doc(uid).get().then((value) {
    userInfo.addAll({
      NameDB: value[NameDB],
      EmailDB: value[EmailDB],
      AgeDB: value[AgeDB],
      WeightDB: value[WeightDB],
      HeightDB: value[HeightDB],
      GoalDB: value[GoalDB],
      GenderDB: value[GenderDB],
      PhotoUrlDB: value[PhotoUrlDB],
    });
    print('User Data Has Been Fetched To Model');
  }).catchError(
      (onError) => print('Failed to Fetch User Data to model $onError'));

  return userInfo.isEmpty ? null : userInfo;
}

Stream<DocumentSnapshot> getUserDoc(String uid) {
  return users.doc(uid).snapshots().handleError(
      (onError) => print('Failed To Get User Doc From DB : $onError'));
}
